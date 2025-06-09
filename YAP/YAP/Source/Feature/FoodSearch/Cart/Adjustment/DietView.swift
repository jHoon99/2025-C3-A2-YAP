//
//  DietView.swift
//  YAP
//
//  Created by 조재훈 on 6/5/25.
//

import SwiftUI

struct DietView: View {
  
  let remainingMealCount: Int
  let baseCaloriePerMeal: Int
  let adjustmentPerMeal: Int
  let isCalorieReduction: Bool
  
  private let mealTitles = ["첫 번째 식사", "두 번째 식사", "세 번째 식사", "네 번째 식사", "다섯 번째 식사", "여섯 번째 식사"]
  
    var body: some View {
      VStack(alignment: .leading, spacing: Spacing.large) {
        Text("식단하기")
          .overlay(Rectangle()
            .frame(height: 3)
            .foregroundColor(.main)
            .offset(y: 16))
          .padding(.bottom, Spacing.medium)
        
        ForEach(0..<remainingMealCount, id: \.self) { index in
          let mealIndex = index + 1
          let mealTitle = mealTitles.indices.contains(mealIndex) ? mealTitles[mealIndex] : "\(mealIndex + 1)번째 식사"
          
          MealAdjustmentRow(
            mealTitle: mealTitle,
            originalCal: baseCaloriePerMeal,
            adjustCal:
              isCalorieReduction ?
              baseCaloriePerMeal - adjustmentPerMeal :
              baseCaloriePerMeal + adjustmentPerMeal
          )
          if index < remainingMealCount - 1 {
            Divider()
          }
        }
        
        Divider()
      }
      .padding(.leading, Spacing.small)
    }
}

struct MealAdjustmentRow: View {
  let mealTitle: String
  let originalCal: Int
  let adjustCal: Int
  
  var body: some View {
    HStack {
      Text(mealTitle)
      
      Spacer()
      
      HStack {
        Text("\(originalCal)")
          .font(.pretendard(type: .regular, size: 14))
          .foregroundColor(.subText)
          .strikethrough(originalCal != adjustCal)
        
        if originalCal != adjustCal {
          Image(systemName: "arrow.right")
            .font(.pretendard(type: .regular, size: 14))
          
          Text("\(adjustCal)")
            .font(.pretendard(type: .semibold, size: 14))
            .foregroundColor(.main)
        }
        Text("kcal")
          .font(.pretendard(type: .regular, size: 14))
          .foregroundColor(.subText)
      }
      .padding(.trailing, Spacing.large)
    }
  }
}

//#Preview {
//    DietView(title: "식단하기", mealTime: "두 번째 식사", originalCal: 700, adjustCal: 600)
//}
