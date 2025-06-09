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
  @State private var selectedMealIndex: Int? = nil
  
  let mealTitle: [String] = ["첫 식사", "두 번째 식사", "세 번째 식사", "네 번째 식사", "다섯 번째 식사", "여섯 번째 식사"]
  
  var body: some View {
    VStack(spacing: 16) {
      let mealCount: Int = activityData.first?.mealCount ?? 3
      
      let todayMeals = mealData.filter {
        Calendar.current.isDate($0.day, inSameDayAs: selectedDate)
      }.sorted { $0.mealIndex < $1.mealIndex }
      
      ForEach(0..<mealCount, id: \.self) { index in
        let meal = todayMeals.first { $0.mealIndex == index }
        
        if let meal = meal {
          MealInfo(meal: meal,
                   title: mealTitle.indices.contains(index) ? mealTitle[index] : "\(index)번째 식사",
                   onAdd: {
            selectedMealIndex = index
            isNext = true
          }
          )
        }
        if index < mealCount - 1 {
          Divider()
        }
      }
    }
    .navigationDestination(isPresented: $isNext, destination: {
      if let mealIndex = selectedMealIndex {
        FoodSearchView(loggingMealIndex: mealIndex)
          .environmentObject(CartManager())
      }
    })
    .padding(20)
    .background(.white)
    .cornerRadius(12)
  }
}

struct MealInfo: View {
  @Bindable var meal: Meal
  
  let title: String
  let onAdd: () -> Void
  
  var body: some View {
    HStack {
      Text(title)
        .font(.subheadline)
      
      Spacer()
      
      if meal.isComplete {
        Text("\(meal.kcal) / \(meal.targetKcal)")
      } else {
        Text("\(meal.targetKcal)")
      }
      
      // MARK: - isComplete 식단 완료 상태에 따른 아이콘
      let iconName: String = meal.isComplete == true ? "checkmark" : "plus"
      let fgColor: Color = meal.isComplete == true ? .white : .main
      let bgColor: Color = meal.isComplete == true ? .main: .lightHover
      
      Button(action: {
        if !meal.isComplete {
          onAdd()
        }
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
      .disabled(meal.isComplete == true)
    }
    .padding(.horizontal)
  }
}

#Preview {
  MealEntryView(selectedDate: .constant(Date()))
}
