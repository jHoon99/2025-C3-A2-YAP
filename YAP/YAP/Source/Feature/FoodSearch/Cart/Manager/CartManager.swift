//
//  CartManager.swift
//  YAP
//
//  Created by 조재훈 on 6/4/25.
//

import Foundation

final class CartManager: ObservableObject {
  @Published var cartItems: [CartItem] = []
  
  // MARK: -- 장바구니에 음식 추가
  func addFood(_ food: FoodItem, quantity: Int, unit: NutritionUnit) {
    let calories = food.nutrientValue(for: .calorie, quantity: quantity, unit: unit)
    let carbs = food.nutrientValue(for: .carbohydrate, quantity: quantity, unit: unit)
    let protein = food.nutrientValue(for: .protein, quantity: quantity, unit: unit)
    let fat = food.nutrientValue(for: .fat, quantity: quantity, unit: unit)
    
    let cartItem = CartItem(
      id: UUID(),
      foodName: food.foodName,
      calorie: calories,
      carbohydrate: carbs,
      protein: protein,
      fat: fat,
      quantity: quantity,
      unit: unit
    )
    cartItems.append(cartItem)
  }
  // MARK: -- 음식 제거
  func removeFood(at index: Int) {
    cartItems.remove(at: index)
  }
  // MARK: -- 총 영양성분 계산
  var totalNutrition: Nutrition {
    Nutrition(
      calories: cartItems.reduce(0) { $0 + $1.calorie },
      carbs: cartItems.reduce(0) { $0 + $1.carbohydrate },
      protein: cartItems.reduce(0) { $0 + $1.protein },
      fat: cartItems.reduce(0) { $0 + $1.fat }
    )
  }
}

struct CartItem: Identifiable {
  let id: UUID
  let foodName: String
  let calorie: Int
  let carbohydrate: Int
  let protein: Int
  let fat: Int
  let quantity: Int
  let unit: NutritionUnit
}

struct Nutrition {
  let calories: Int
  let carbs: Int
  let protein: Int
  let fat: Int
}
