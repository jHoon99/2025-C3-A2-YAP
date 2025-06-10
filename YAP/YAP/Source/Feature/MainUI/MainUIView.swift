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
  
  @Query var calorieToBurns: [CalorieToBurn]
  @State private var selectedDate = Date()
  @State private var showDatePicker = false
  @State private var timer: Timer?
  
  @Query private var mealData: [Meal]
  @Query private var calorieData: [CalorieRequirements]
  @Query private var activityData: [ActivityInfo]
  
  private var calorieToBurnToday: CalorieToBurn? {
    calorieToBurns.first { $0.isSameDate(as: Date()) }
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        DateSelectionView(selectedDate: $selectedDate, showDatePicker: $showDatePicker)
        
        if let excessCalorieOfToday = calorieToBurnToday {
          WorkOutNotification(calroieToBurn: excessCalorieOfToday.calorie)
        }
        
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
    .onAppear {
      checkTodayMealInitOnLaunch(testMode: false) // 테스트용(testMode가 true일 때)
    }
    .onChange(of: selectedDate) { newDate in
      print("📅 selectedDate 변경됨: \(newDate)")
      let today = Calendar.current.startOfDay(for: Date())
      if Calendar.current.isDate(today, inSameDayAs: newDate) {
        checkAndInsertMeal(for: newDate)
      }
    }
    .onDisappear {
      timer?.invalidate()
    }
    .navigationBarBackButtonHidden()
    .ignoresSafeArea()
  }
  
  private func checkTodayMealInitOnLaunch(testMode: Bool = false) {
    let calendar = Calendar.current
    let today = Calendar.current.startOfDay(for: Date())
    let lastInit = UserDefaults.standard.object(forKey: "lastMealInitDate") as? Date

    if lastInit == nil || !Calendar.current.isDate(lastInit!, inSameDayAs: today) {
      print("🍽️ 앱 재실행 - 오늘 식사 데이터 없음 → 생성")
      checkAndInsertMeal(for: today)
      UserDefaults.standard.set(today, forKey: "lastMealInitDate")
    } else {
      print("✅ 오늘 식사 데이터 이미 생성됨")
    }
    
    // ✅ testMode: 30초 후에 selectedDate를 내일로 설정하고 Meal 생성
    if testMode {
      Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { _ in
        let fakeTomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        print("🌙 [TEST] 30초 후 자정 도착! → 내일로 이동: \(formattedDate(fakeTomorrow))")

        selectedDate = fakeTomorrow
        checkAndInsertMeal(for: fakeTomorrow)
      }
    }
  }
  
  private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date)
  }
  
  // MARK: Meal 자동 생성
  private func checkAndInsertMeal(for date: Date) {
    let dayToInsert = Calendar.current.startOfDay(for: date)

    let todayMeals = mealData.filter {
      Calendar.current.isDate($0.day, inSameDayAs: dayToInsert)
    }

    guard todayMeals.isEmpty,
          let calorie = calorieData.first?.calorie,
          let activity = activityData.first else {
      return
    }

    let mealCount = activity.mealCount
    let kcalPerMeal = calorie / mealCount
    let carbPerMeal = (calorieData.first?.carbohydrates ?? 0) / Double(mealCount)
    let proteinPerMeal = (calorieData.first?.protein ?? 0) / Double(mealCount)
    let fatPerMeal = (calorieData.first?.lipid ?? 0) / Double(mealCount)

    for index in 0..<mealCount {
      let meal = Meal(
        day: dayToInsert,
        carbohydrates: 0,
        protein: 0,
        lipid: 0,
        kcal: 0,
        menus: [],
        mealIndex: index,
        targetKcal: kcalPerMeal,
        targetCarbs: carbPerMeal,
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
