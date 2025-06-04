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
  
  // MARK: - 장바구니 아이템 SwiftData 저장
  func saveMeal(from cartItems: [CartItem]) async -> (sucess: Bool, message: String) {
    guard let modelContext = modelContext else {
      return (false, "ModelContext is nil")
    }
    guard !cartItems.isEmpty else {
      return (false, "저장할 메뉴가 없습니다.")
    }
    // CartItem -> Menu
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
        day: <#T##Date#>,
        carbohydrates: <#T##Double#>,
        protein: <#T##Double#>,
        lipid: <#T##Double#>,
        kcal: <#T##Int#>,
        menus: <#T##[Menu]#>
      )
    }0
  }
}

