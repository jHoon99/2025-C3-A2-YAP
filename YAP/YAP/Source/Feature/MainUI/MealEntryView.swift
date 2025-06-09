//
//  MealEntryView.swift
//  YAP
//
//  Created by 조운경 on 6/3/25.
//

import SwiftData
import SwiftUI

struct MealEntryView: View {
  @Binding var selectedDate: Date
  
  @Query private var calorieData: [CalorieRequirements]
  @Query private var activityData: [ActivityInfo]
  @Query private var mealData: [Meal]
  
  @State private var isNext: Bool = false
  
  let mealTitle: [String] = ["첫 식사", "두 번째 식사", "세 번째 식사", "네 번째 식사", "다섯 번째 식사", "여섯 번째 식사"]
  
  var body: some View {
    VStack(spacing: 16) {
      let mealCount: Int = activityData.first?.mealCount ?? 0
      let mealGoalkcal: Int = {
        if let total = calorieData.first?.calorie {
          return total / mealCount
        } else {
          return 0
        }
      }()
      
      let todayMeals = mealData.filter {
        Calendar.current.isDate($0.day, inSameDayAs: selectedDate)
      }
      
      ForEach(0..<mealCount, id: \.self) { index in
        let currentCalories: Int = {
          if index < todayMeals.count {
            return todayMeals[index].kcal
          } else {
            return 0
          }
        }()
        
        MealInfo(
          isNext: $isNext,
          title: mealTitle[index],
          currentCalories: currentCalories,
          targetCalories: mealGoalkcal,
          mealIndex: index)
        if index < mealCount - 1 {
          Divider()
        }
      }
    }
    .navigationDestination(isPresented: $isNext, destination: {
      FoodSearchView(loggingMealIndex: 1)
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
  let mealIndex: Int
  
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
  MealEntryView(selectedDate: .constant(Date()))
}
