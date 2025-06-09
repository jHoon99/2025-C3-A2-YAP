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
  func saveMeal(from cartItems: [CartItem], mealIndex: Int? = nil) async -> (success: Bool, message: String) {
    guard let modelContext = modelContext else {
      return (false, "ModelContext is nil")
    }
    guard !cartItems.isEmpty else {
      return (false, "저장할 메뉴가 없습니다.")
    }
    // CartItem -> Menu 객체로 변환
    do {
      let menus = cartItems.compactMap { item in
        Menu(
          name: item.foodName,
          carbohydrates: Double(item.carbohydrate),
          protein: Double(item.protein),
          lipid: Double(item.fat),
          kcal: item.calorie
        )
      }
      // 총 영양성분 계산
      let totalCalories = cartItems.reduce(0) { $0 + $1.calorie }
      let totalCarbs = cartItems.reduce(0) { $0 + $1.carbohydrate }
      let totalProteins = cartItems.reduce(0) { $0 + $1.protein }
      let totalFats = cartItems.reduce(0) { $0 + $1.fat }
      
      if let mealIndex = mealIndex {
        let descriptor = FetchDescriptor<Meal>(
          predicate: #Predicate { $0.mealIndex == mealIndex }
        )
        let meals = try modelContext.fetch(descriptor)
        
        if let mealToUpdate = meals.first {
          mealToUpdate.kcal = totalCalories
          mealToUpdate.carbohydrates = Double(totalCarbs)
          mealToUpdate.protein = Double(totalProteins)
          mealToUpdate.lipid = Double(totalFats)
          mealToUpdate.isComplete = true
          mealToUpdate.menus = menus
          
          print("끼니 \(mealIndex) 업데이트 : \(totalCalories)kcal")
        } else {
          return (false, "해당 끼니를 찾을 수 없습니다.")
        }
      } else {
        let meal = Meal(
          day: Date(),
          carbohydrates: Double(totalCarbs),
          protein: Double(totalProteins),
          lipid: Double(totalFats),
          kcal: totalCalories,
          menus: menus,
          mealIndex: 0,
          targetKcal: 0,
          targetCarbs: 0,
          targetProtein: 0,
          targetFat: 0
        )
        modelContext.insert(meal)
        print("\(totalCalories)")
      }
      try modelContext.save()
      return (true, "식단이 성공적으로 저장되었습니다.")
    } catch {
      print("식단 저장 실패: \(error)")
      return (false, "식단 저장에 실패했습니다. \n\(error.localizedDescription)")
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
