//
//  NutritionCircle.swift
//  YAP
//
//  Created by 조재훈 on 6/4/25.
//

import SwiftUI

struct NutritionCircle: View {
  let title: String
  let current: Int
  let goal: Int
  
  private var safeProgress: Double {
    guard goal > 0 else { return 0.0 }
    let progress = Double(current) / Double(goal)
    return max(0.0, min(progress, 1.0)) // 0 ~ 1 제한
  }
  
  private var percentage: Int {
    return Int(safeProgress * 100)
  }
  
  var body: some View {
    VStack(spacing: Spacing.small) {
      ZStack {
        Circle()
          .fill(Color.lightHover)
          .frame(width: 64, height: 64)
        Circle()
          .trim(from: 0, to: CGFloat(safeProgress))
          .stroke(LinearGradient.ctaGradient, style: StrokeStyle(lineWidth: 5, lineCap: .round))
          .frame(width: 64, height: 64)
          .rotationEffect(.degrees(-90))
          .animation(.easeInOut(duration: 0.5), value: safeProgress)
        Text("\(percentage)%")
          .font(.pretendard(type: .medium, size: 14))
          .foregroundColor(percentage >= 90 ? .main : .black)
      }
      .padding(.bottom, 10)
      HStack {
        Text(title)
          .font(.pretendard(type: .medium, size: 15))
          .foregroundColor(.text)
        if percentage >= 90 && percentage <= 110 {
          Image(systemName: "checkmark.circle.fill")
            .frame(width: 16, height: 16)
            .font(.pretendard(type: .bold, size: 15))
            .foregroundColor(.main)
        }
      }
      .frame(height: 16)
      .scaleEffect(percentage >= 90 ? 1.0 : 0.8)
      .animation(.spring(response: 0.2, dampingFraction: 0.6), value: percentage)
      Text("\(current)/\(goal)g")
        .font(.pretendard(type: .medium, size: 16))
        .foregroundColor(.text)
    }
  }
}

#Preview {
    HStack(spacing: 20) {
        NutritionCircle(title: "탄수화물", current: 100, goal: 130) // 77%
        NutritionCircle(title: "단백질", current: 35, goal: 40)     // 88%
        NutritionCircle(title: "지방", current: 18, goal: 20)       // 90%
        NutritionCircle(title: "초과", current: 300, goal: 100)     // 100% (제한됨)
    }
}
