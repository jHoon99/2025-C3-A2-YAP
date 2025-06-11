//
//  CalorieSummaryView.swift
//  YAP
//
//  Created by 조운경 on 6/2/25.
//

import SwiftData
import SwiftUI

struct CalorieSummaryView: View {
  @Binding var selectedDate: Date
  
  @State private var todayMeals: [Meal] = []
  
  @Query var calorieData: [CalorieRequirements]
  @Query var mealData: [Meal]
  
  var totalCalories: Int {
    todayMeals.map { $0.kcal }.reduce(0, +)
  }
  
  var progress: Double {
    let target = calorieData.first?.calorie ?? 1
    return Double(totalCalories) / Double(target)
  }
  
  let mainColor: LinearGradient = LinearGradient.ctaGradient
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      VStack(alignment: .leading, spacing: 8) {
        let remainingCalories = (calorieData.first?.calorie ?? 0) - totalCalories
        
        if remainingCalories >= 0 {
          Text("오늘 남은 칼로리는 ")
            .font(.pretendard(type: .medium, size: 24))
          Text("\((calorieData.first?.calorie ?? 0) - totalCalories)kcal")
            .font(.pretendard(type: .semibold, size: 24))
            .foregroundColor(.main) +
          Text("예요")
            .font(.pretendard(type: .medium, size: 24))
        } else {
          Text("오늘 ")
            .font(.pretendard(type: .medium, size: 24))
          Text("\(-remainingCalories)kcal")
            .font(.pretendard(type: .semibold, size: 24))
            .foregroundColor(.red) +
          Text(" 초과했어요")
            .font(.pretendard(type: .medium, size: 24))
        }
      }
      
      VStack(alignment: .leading, spacing: 8) {
        
        GradientProgressView(progress: progress)
          .accentColor(.main)
          .frame(height: 20)
          .scaleEffect(x: 1, y: 10, anchor: .center)
          .clipShape(RoundedRectangle(cornerRadius: 10))
        
        HStack {
          Spacer()
          Text("\(totalCalories)")
            .font(.pretendard(type: .bold, size: 24))
            .foregroundStyle(.main)
          HStack(spacing: 4) {
            Text("/")
            Text("\(calorieData.first?.calorie ?? 0)")
            Text("kcal")
          }
          .font(.pretendard(type: .regular, size: 20))
          .foregroundColor(Color(.systemGray))
        }
      }
    }
    .onAppear(perform: updateTodayMeals)
    .onChange(of: selectedDate, updateTodayMeals)
    .padding(.vertical, 24)
    .padding(.horizontal, 20)
    .background(Color.white)
    .cornerRadius(12)
  }
  
  private func updateTodayMeals() {
    todayMeals = mealData.filter {
      Calendar.current.isDate($0.day, inSameDayAs: selectedDate)
    }
  }
}

struct GradientProgressView: View {
  var progress: Double
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Capsule()
          .fill(Color.background)
          .frame(height: 20)
        
        Capsule()
          .fill(LinearGradient.ctaGradient)
          .frame(width: progress <= 1 ? CGFloat(progress) * UIScreen.main.bounds.width : 1 * UIScreen.main.bounds.width, height: 20)
      }
    }
    .frame(height: 20)
  }
}

#Preview {
  CalorieSummaryView(selectedDate: .constant(Date()))
}
