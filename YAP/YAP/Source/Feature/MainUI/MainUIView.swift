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
  @State private var timer: Timer?
  
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
    .onAppear {
      setupMidnightTimer(testMode: false) // 테스트 시 true
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
  
  // MARK: 자정 타이머 설정
  private func setupMidnightTimer(testMode: Bool = false) {
    let calendar = Calendar.current
    let triggerTime: TimeInterval

    if testMode {
      triggerTime = 5 // 테스트: 5초 후
    } else if let nextMidnight = calendar.nextDate(after: Date(), matching: DateComponents(hour: 0), matchingPolicy: .strict) {
      triggerTime = nextMidnight.timeIntervalSinceNow
    } else {
      return
    }

    timer = Timer.scheduledTimer(withTimeInterval: triggerTime, repeats: false) { _ in
      if testMode {
        // ✅ 테스트용: 다음 날로 강제 이동
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        print("🧪 테스트 트리거: 내일로 이동됨")
        selectedDate = tomorrow
        checkAndInsertMeal(for: tomorrow)
      } else {
        // 실제 자정 처리
        let today = Calendar.current.startOfDay(for: Date())
        selectedDate = today
        checkAndInsertMeal(for: today)
      }

      setupMidnightTimer(testMode: testMode)
    }
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
