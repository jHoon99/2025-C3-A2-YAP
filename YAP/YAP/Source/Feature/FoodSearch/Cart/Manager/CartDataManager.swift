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
  
  // MARK: - 장바구니 아이템 SwiftData 저장
  func saveMeal(from cartItems: [CartItem]) async -> (success: Bool, message: String) {
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
      
      let meal = Meal(
        day: Date(),
        carbohydrates: Double(totalCarbs),
        protein: Double(totalProteins),
        lipid: Double(totalFats),
        kcal: totalCalories,
        menus: menus
      )
      
      // SwiftData 저장
      modelContext.insert(meal)
      try modelContext.save()
      
      print("식단 저장 성공: \(menus.count)개 메뉴, 총 \(totalCalories)kcal")
      return (true, "식단이 성공적으로 저장되었습니다.")
    } catch {
      print("식단 저장 실패: \(error)")
      return (false, "식단 저장에 실패했습니다. \n\(error.localizedDescription)")
    }
  }
  // MARK: - 식단 삭제 ?
}
