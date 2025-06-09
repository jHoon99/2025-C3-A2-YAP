//
//  CartDataManager.swift
//  YAP
//
//  Created by 조재훈 on 6/5/25.
//

import Foundation
import SwiftData

class CartDataManager: ObservableObject {
  private var modelContext: ModelContext?
  
  func setModelContext(_ context: ModelContext) {
    self.modelContext = context
  }
  
  // MARK: - 장바구니 아이템 SwiftData 저장, mealIndex를 추가해서 끼니별 업데이트
  func saveMeal(
    from cartItems: [CartItem],
    mealIndex: Int? = nil,
    adjsutmentRemainMeal: Bool,
    adjustmentAmount: Int,
    adjustmentType: AdjustmentType?
  ) async -> (success: Bool, message: String) {
    
    guard let modelContext = modelContext else {
      return (false, "ModelContext is nil")
    }
    guard !cartItems.isEmpty else {
      return (false, "저장할 메뉴가 없습니다.")
    }
    
    do {
      let menus = convertCartItemsToMenu(cartItems)
      let nutrition = calculateTotalNutrition(from: cartItems)
      
      // 실제 섭취량으로 업데이트
      if let mealIndex = mealIndex {
        try await updateExistingMeal(
          mealIndex: mealIndex,
          nutrition: nutrition,
          menus: menus
        )
        if adjsutmentRemainMeal {
          try await adjustRemainMealTarget(
            currentMealIndex: mealIndex,
            adjustmentAmount: adjustmentAmount,
            adjustmentType: adjustmentType
          )
        }
      } else {
        try createNewMeal(nutrition: nutrition, menus: menus)
      }
      try modelContext.save()
      
      return (true, "식단이 성공적으로 저장되었습니다.")
    } catch {
      print("식단 저장 실패: \(error)")
      return (false, "식단 저장에 실패했습니다.\(error.localizedDescription)")
    }
  }
  
  
  // MARK: - 가장 최근에 저장된 Meal 객체 반환
  func getLatestMeal() async -> Meal? {
    guard let modelContext = modelContext else { return nil }
    
    let descriptor = FetchDescriptor<Meal>(
      sortBy: [SortDescriptor(\.day, order: .reverse)]
    )
    
    do {
      let meals = try modelContext.fetch(descriptor)
      return meals.first
    } catch {
      print("최신 Meal 조회 실패: \(error)")
      return nil
    }
  }
}

extension CartDataManager {
  // MARK: - 장바구니 아이템들을 Menu 객체로 변환
  // cartItem: 변환할 장바구니 아이템들
  func convertCartItemsToMenu(_ cartItems: [CartItem]) -> [Menu] {
    return cartItems.compactMap { item in
      Menu(
        name: item.foodName,
        carbohydrates: Double(item.carbohydrate),
        protein: Double(item.protein),
        lipid: Double(item.fat),
        kcal: item.calorie
      )
    }
  }
  // MARK: - 장바구니 아이템들 총 영양성분 계산
  // cartItem: 계산할 장바구니 아이템들
  func calculateTotalNutrition(from cartItmes: [CartItem]) -> TotalNutrition {
    let totalCalories = cartItmes.reduce(0) { $0 + $1.calorie }
    let totalCarbs = cartItmes.reduce(0) { $0 + $1.carbohydrate }
    let totalProteins = cartItmes.reduce(0) { $0 + $1.protein }
    let totalFats = cartItmes.reduce(0) { $0 + $1.fat }
    
    return TotalNutrition(
      calorie: totalCalories,
      carbs: totalCarbs,
      protein: totalProteins,
      fat: totalFats
    )
  }
  // MARK: - 기존 끼니 데이터를 섭취량으로 업데이트
  // mealIndex: 업데이트할 끼니 인덱스
  // nutrition: 실제 섭취한 총 영양성분
  // menus: 섭취한 개별 음식 데이터
  func updateExistingMeal(
    mealIndex: Int,
    nutrition: TotalNutrition,
    menus: [Menu]
  ) async throws {
    // 해당 끼니 찾기
    let descriptor = FetchDescriptor<Meal>(
      predicate: #Predicate<Meal> { $0.mealIndex == mealIndex }
    )
    let meals = try modelContext!.fetch(descriptor)
    
    guard let mealToUpdate = meals.first else {
      throw SaveError.mealNotFound(mealIndex: mealIndex)
    }
    
    // 실제 섭취량으로 업데이트 (목표값은 그대로 유지)
    mealToUpdate.kcal = nutrition.calorie
    mealToUpdate.carbohydrates = Double(nutrition.carbs)
    mealToUpdate.protein = Double(nutrition.protein)
    mealToUpdate.lipid = Double(nutrition.fat)
    mealToUpdate.isComplete = true
    mealToUpdate.menus = menus
  }
  // MARK: - 남은 끼니들의 목표 칼로리와 영양소 조정
  // currentMealIndex: 방금 완료한 끼니 인덱스
  // adjustmentAmount: 조정할 총 칼로리량
  // adjustmentType: 조정타입 (.underLimit, .overLimit)
  func adjustRemainMealTarget(currentMealIndex: Int, adjustmentAmount: Int, adjustmentType: AdjustmentType?) async throws {
    guard let adjustmentType = adjustmentType else {
      return
    }
    
    // 완료되지 않은 && 현재 끼니보다 나중 끼니 찾기
    let remainDescriptor = FetchDescriptor<Meal>(
      predicate: #Predicate<Meal> {
        !$0.isComplete && $0.mealIndex > currentMealIndex
      }
    )
    let remainMeal = try modelContext!.fetch(remainDescriptor)
    
    guard !remainMeal.isEmpty else {
      print("조정할 남은 끼니가 없슴")
      return
    }
    // 칼로리 조정 방향 결정
    let adjustmentSign = (adjustmentType == .overLimit) ? -1 : 1
    let adjustmentPerMeal = (adjustmentAmount / remainMeal.count) * adjustmentSign
    
    // 각 남은 끼니의 target 비례적으로 조정
    for meal in remainMeal {
      updateMealTarget(meal: meal, adjustmnetPerMeal: adjustmentPerMeal)
    }
  }
  // MARK: - 개별 목표값들 비례적으로 조정 로직
  // meal: 조정할 끼니 객체
  // adjustmentPerMeal: 끼니당 조정할 칼로리량
  func updateMealTarget(meal: Meal, adjustmnetPerMeal: Int) {
    let oldTargetKcal = meal.targetKcal
    meal.targetKcal = oldTargetKcal + adjustmnetPerMeal
    
    // 탄단지도 같이 조정
    if oldTargetKcal > 0 {
      let ratio = Double(meal.targetKcal) / Double(oldTargetKcal)
      meal.targetCarbs *= ratio
      meal.targetProtein *= ratio
      meal.targetFat *= ratio
    }
  }
  
  func createNewMeal(nutrition: TotalNutrition, menus: [Menu]) throws {
    let meal = Meal(
      day: Date(),
      carbohydrates: Double(nutrition.carbs),
      protein: Double(nutrition.protein),
      lipid: Double(nutrition.fat),
      kcal: nutrition.calorie,
      menus: menus,
      mealIndex: 0,
      targetKcal: 500,      // 기본값
      targetCarbs: 60.0,    // 기본값
      targetProtein: 25.0,  // 기본값
      targetFat: 20.0
    )
    modelContext!.insert(meal)
    print("새로운 끼니 생성 완료 (기본값 사용)")
  }
}


struct TotalNutrition {
  let calorie: Int
  let carbs: Int
  let protein: Int
  let fat: Int
}

enum SaveError: Error {
  case mealNotFound(mealIndex: Int)
  
  var localizedDescription: String {
    switch self {
    case .mealNotFound(let mealIndex):
      return "끼니 인덱스 \(mealIndex)를 못찾음"
    }
  }
}
