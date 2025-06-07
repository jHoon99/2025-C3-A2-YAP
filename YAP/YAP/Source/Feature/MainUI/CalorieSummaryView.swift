//
//  CalorieSummaryView.swift
//  YAP
//
//  Created by 조운경 on 6/2/25.
//

import SwiftData
import SwiftUI

struct CalorieSummaryView: View {
  @Query var calorieData: [CalorieRequirements]
  @State var progress: Double = 900 / 2000
  
  let mainColor: LinearGradient = LinearGradient.ctaGradient
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      VStack(alignment: .leading, spacing: 8) {
        Text("오늘 남은 칼로리는 ")
            .font(.pretendard(type: .medium, size: 24))
        Text("1100kcal")
            .font(.pretendard(type: .medium, size: 24))
            .foregroundColor(.main) +
        Text("예요")
            .font(.pretendard(type: .medium, size: 24))
      }
      
      VStack(alignment: .leading, spacing: 8) {
        
        GradientProgressView(progress: $progress)
//                ProgressView(value: 900, total: 2000)
//                    .accentColor(.main)
//                    .frame(height: 20)
//                    .scaleEffect(x: 1, y: 10, anchor: .center)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
          
        HStack {
            Spacer()
            Text("900")
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
  @Binding var progress: Double

  var body: some View {
    ZStack(alignment: .leading) {
      Capsule()
        .fill(Color.gray.opacity(0.3))
        .frame(height: 20)

      Capsule()
        .fill(LinearGradient.ctaGradient)
        .frame(width: CGFloat(progress) * UIScreen.main.bounds.width * 0.8, height: 20)
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
    CalorieSummaryView()
}
