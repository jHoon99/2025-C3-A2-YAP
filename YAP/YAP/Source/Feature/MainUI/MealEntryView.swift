//
//  MealEntryView.swift
//  YAP
//
//  Created by 조운경 on 6/3/25.
//

import SwiftUI

struct MealEntryView: View {
  var mealCount: Int
  let mealTitle: [String] = ["첫 식사", "두 번째 식사", "세 번째 식사", "네 번째 식사", "다섯 번째 식사", "여섯 번째 식사"]
  let currentCalories: [Int] = [400, 400, 400, 400]
  let targetCaloires: Int = 700
  
  var body: some View {
    VStack(spacing: 16) {
      
    }
    .padding(20)
    .background(.white)
    .cornerRadius(12)
  }
}

struct MealInfo: View {
  let title: String
  let currentCalories: Int
  let targetCalories: Int
  
  var body: some View {
    Text("Meal Info")
  }
}

#Preview {
    MealEntryView(mealCount: 4)
}
