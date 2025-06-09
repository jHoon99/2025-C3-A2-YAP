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
  
  @Query var calorieData: [CalorieRequirements]
  @Query var mealData: [Meal]
  
  let mainColor: LinearGradient = LinearGradient.ctaGradient
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      VStack(alignment: .leading, spacing: 8) {
        Text("오늘 남은 칼로리는 ")
          .font(.pretendard(type: .medium, size: 24))
        Text("\((calorieData.first?.calorie ?? 0) - totalCalories)kcal")
          .font(.pretendard(type: .medium, size: 24))
          .foregroundColor(.main) +
        Text("예요")
          .font(.pretendard(type: .medium, size: 24))
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
            .font(.inter(type: .bold, size: 20.4))
            .foregroundStyle(.main)
          HStack(spacing: 4) {
            Text("/")
            Text("\(calorieData.first?.calorie ?? 0)")
            Text("kcal")
          }
          .font(.inter(type: .regular, size: 15.3))
          .foregroundColor(Color(.systemGray))
        }
      }
    }
    .padding(.vertical, 24)
    .padding(.horizontal, 20)
    .background(Color.white)
    .cornerRadius(12)
  }
}

struct GradientProgressView: View {
  var progress: Double
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Capsule()
          .fill(Color.gray.opacity(0.3))
          .frame(height: 20)

        Capsule()
          .fill(LinearGradient.ctaGradient)
          .frame(
            width: min(max(CGFloat(progress) * geometry.size.width, 0), geometry.size.width),
            height: 20
          )
      }
    }
    .frame(height: 20)
  }
}

private extension CalorieSummaryView {
  var totalCalories: Int {
    mealData
      .filter { Calendar.current.isDate($0.day, inSameDayAs: selectedDate) }
      .map { $0.kcal }
      .reduce(0, +)
  }
  
  var progress: Double {
    let target = calorieData.first?.calorie ?? 1
    return Double(totalCalories) / Double(target)
  }
}

#Preview {
  CalorieSummaryView(selectedDate: .constant(Date()))
}
