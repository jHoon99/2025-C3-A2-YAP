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
  @Query(sort: \Meal.mealIndex) private var mealData: [Meal]
  
  @State private var isNext: Bool = false
  @State private var selectedIndex: Int? = nil
  @State private var todayMeals: [Meal] = []
  
  let mealTitle: [String] = ["첫 식사", "두 번째 식사", "세 번째 식사", "네 번째 식사", "다섯 번째 식사", "여섯 번째 식사"]
  
  var body: some View {
    VStack(spacing: 16) {
      let mealCount: Int = activityData.first?.mealCount ?? 0
      
      ForEach(todayMeals) { meal in
        let _ = print("\(meal.targetKcal)")
      }
      
      ForEach(todayMeals) { meal in
        let index = meal.mealIndex
        let targetCalories = meal.targetKcal
        let currentCalories = meal.kcal
        
        MealInfo(
          isNext: $isNext,
          selectedIndex: $selectedIndex,
          title: mealTitle[index],
          currentCalories: currentCalories,
          targetCalories: targetCalories,
          mealIndex: index)
        
        if index < mealCount - 1 {
          Divider()
        }
      }
    }
    .onAppear {
      todayMeals = mealData.filter {
        Calendar.current.isDate($0.day, inSameDayAs: selectedDate)
      }
    }
    .navigationDestination(isPresented: $isNext, destination: {
      if let index = selectedIndex {
        FoodSearchView(loggingMealIndex: index)
      } else {
        EmptyView()
      }
    })
    .padding(20)
    .background(.white)
    .cornerRadius(12)
  }
}

struct MealInfo: View {
  @Binding var isNext: Bool
  @Binding var selectedIndex: Int?
  
  let title: String
  let currentCalories: Int
  let targetCalories: Int
  let mealIndex: Int
  
  var body: some View {
    Button(action: {
      // 음식 추가 화면 나옴
      selectedIndex = mealIndex
      isNext = true
    }, label: {
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
        
        Image(systemName: iconName)
          .font(.system(size: 16, weight: .black))
          .foregroundColor(fgColor)
          .frame(width: 36, height: 36)
          .background(
            Circle()
              .fill(bgColor)
          )
      }
    })
  }
}

#Preview {
  MealEntryView(selectedDate: .constant(Date()))
}
