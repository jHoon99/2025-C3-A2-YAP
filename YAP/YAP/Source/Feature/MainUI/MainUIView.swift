//
//  MainUIView.swift
//  YAP
//
//  Created by 조운경 on 6/2/25.
//

import SwiftData
import SwiftUI

struct MainUIView: View {
  @Environment(\.modelContext) private var modelContext
  
  @State private var selectedDate = Date()
  @State private var showDatePicker = false
  
  @Query private var mealData: [Meal]
  @Query private var calorieData: [CalorieRequirements]
  @Query private var activityData: [ActivityInfo]
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        DateSelectionView(selectedDate: $selectedDate, showDatePicker: $showDatePicker)
        CalorieSummaryView(selectedDate: $selectedDate)
        NutrientSectionView(selectedDate: $selectedDate)
        MealEntryView(selectedDate: $selectedDate)
      }
      .padding([.horizontal, .bottom], 16)
      .padding(.top, 64)
      .background(Color(.systemGray6))
      .sheet(isPresented: $showDatePicker) {
        CustomCalendarView(selectedDate: $selectedDate, onDismiss: {
          showDatePicker = false
        })
        .presentationDetents([.height(500)])
      }
    }
    .navigationBarBackButtonHidden()
    .ignoresSafeArea()
  }
  
  private func checkAndInsertMeal() {
    let today = Calendar.current.startOfDay(for: selectedDate)
    let todayMeals = mealData.filter {
      Calendar.current.isDate($0.day, inSameDayAs: today)
    }
    
    guard todayMeals.isEmpty,
          let calorie = calorieData.first?.calorie,
          let activity = activityData.first else {
      return
    }
    
    let mealCount = activity.mealCount
    guard mealCount > 0 else { return }
    
    let caloriePerMeal = calorie / mealCount
    let carbsPerMeal = (calorieData.first?.carbohydrates ?? 0) / Double(mealCount)
    let proteinPerMeal = (calorieData.first?.protein ?? 0) / Double(mealCount)
    let fatPerMeal = (calorieData.first?.lipid ?? 0) / Double(mealCount)
    
    for index in 0..<mealCount {
      let meal = Meal(
        day: today,
        carbohydrates: 0,
        protein: 0,
        lipid: 0,
        kcal: 0,
        menus: [],
        mealIndex: index,
        targetKcal: caloriePerMeal,
        targetCarbs: carbsPerMeal,
        targetProtein: proteinPerMeal,
        targetFat: fatPerMeal
      )
      modelContext.insert(meal)
    }
  }
}

#Preview {
  NavigationStack {
    MainUIView()
  }
}
