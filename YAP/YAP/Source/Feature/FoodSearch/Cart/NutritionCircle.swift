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
  let progress: Double
  
  var body: some View {
    VStack(spacing: Spacing.small) {
      ZStack {
        Circle()
          .fill(Color.lightHover)
          .frame(width: 64, height: 64)
        Circle()
          .trim(from: 0, to: min(CGFloat(progress), 1.0))
          .stroke(LinearGradient.ctaGradient, style: StrokeStyle(lineWidth: 5, lineCap: .round))
          .frame(width: 64, height: 64)
          .rotationEffect(.degrees(-90))
          .animation(.easeInOut(duration: 0.5), value: progress)
        Text("\(Int(progress * 100))%")
          .font(.pretendard(type: .medium, size: 14))
          .foregroundColor(progress >= 90 ? .main : .black)
      }
      .padding(.bottom, 10)
      HStack {
        Text(title)
          .font(.pretendard(type: .medium, size: 15))
          .foregroundColor(.text)
        if Int(progress * 100) >= 90 && Int(progress * 100) <= 110 {
          Image(systemName: "checkmark.circle.fill")
            .frame(width: 16, height: 16)
            .font(.pretendard(type: .bold, size: 15))
            .foregroundColor(.main)
        }
      }
      .frame(height: 16)
      .scaleEffect(progress >= 90 ? 1.0 : 0.8)
      .animation(.spring(response: 0.2, dampingFraction: 0.6), value: progress)
      Text("\(current)/\(goal)g")
        .font(.pretendard(type: .medium, size: 16))
        .foregroundColor(.text)
    }
  }
}

#Preview {
  NutritionCircle(title: "dd", current: 20, goal: 100, progress: 90)
}
