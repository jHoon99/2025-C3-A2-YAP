//
//  MealEntryView.swift
//  YAP
//
//  Created by 조운경 on 6/3/25.
//

import SwiftUI

struct MealEntryView: View {
  @State private var isNext: Bool = false
  
  var mealCount: Int
  let mealTitle: [String] = ["첫 식사", "두 번째 식사", "세 번째 식사", "네 번째 식사", "다섯 번째 식사", "여섯 번째 식사"]
  let calories: [(current: Int, goal: Int)] = [
    (400, 700), (400, 700), (200, 700), (0, 700), (0, 700), (0, 700)
  ]
  
  var body: some View {
    VStack(spacing: 16) {
      ForEach(0..<mealCount, id: \.self) { index in
        MealInfo(
          isNext: $isNext,
          title: mealTitle[index],
          currentCalories: calories[index].current,
          targetCalories: calories[index].goal)
        if index < mealCount - 1 {
          Divider()
        }
      }
    }
    .navigationDestination(isPresented: $isNext, destination: {
      FoodSearchView()
    })
    .padding(20)
    .background(.white)
    .cornerRadius(12)
  }
}

struct MealInfo: View {
  @Binding var isNext: Bool
  
  let title: String
  let currentCalories: Int
  let targetCalories: Int
  
  var body: some View {
    HStack {
      Text(title)
        .font(.subheadline)
      
      Spacer()
      
      Text("\(currentCalories) / \(targetCalories) kcal")
        .foregroundColor(.gray)
        .font(.inter(type: .regular, size: 14))
      
      let iconName: String = currentCalories > 0 ? "checkmark" : "plus"
      let fgColor: Color = currentCalories > 0 ? .white : .main
      let bgColor: Color = currentCalories > 0 ? .main: .lightHover
      
      Button(action: {
        // 음식 추가 화면 나옴
        isNext = true
      }, label: {
        Image(systemName: iconName)
          .font(.system(size: 16, weight: .black))
          .foregroundColor(fgColor)
          .frame(width: 36, height: 36)
          .background(
            Circle()
              .fill(bgColor)
          )
      })
    }
    .padding(.horizontal)
  }
}

#Preview {
    MealEntryView(mealCount: 4)
}
