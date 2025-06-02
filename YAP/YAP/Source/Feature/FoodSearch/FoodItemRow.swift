//
//  FoodItemRow.swift
//  YAP
//
//  Created by 조재훈 on 6/1/25.
//

import SwiftUI

struct FoodItemRow: View {
  
  let food: FoodItem
  
    var body: some View {
      VStack(alignment: .leading, spacing: 12) {
        VStack(alignment: .leading, spacing: 12) {
          Text(food.foodName)
            .font(.headline)
            .fontWeight(.semibold)
          HStack {
            Text("1인분 (\(food.totalSizeIntFormatted))")
              .font(.caption)
              .foregroundColor(.secondary)
            Spacer()
            Text("\(food.totalCaloires)kcal")
              .font(.caption)
              .fontWeight(.semibold)
              .foregroundColor(.secondary)
          }
        }
      }
    }
}

#Preview {
  FoodItemRow(food: FoodItem(
    foodName: "닭가슴살",
    servingSize: "100g",
    totalSize: "200g",
    calories: "165",
    protein: "31",
    fat: "3.6",
    carbohydrate: "0",
    sugar: "0",
    dietaryFiber: "0",
    sodium: "70",
    cholesterol: "85",
    saturatedFat: "1"))
}
