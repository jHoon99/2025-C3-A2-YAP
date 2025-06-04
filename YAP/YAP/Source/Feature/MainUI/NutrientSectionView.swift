//
//  NutrientSectionView.swift
//  YAP
//
//  Created by 조운경 on 6/3/25.
//

import SwiftUI

struct NutrientSectionView: View {
  let carbonColor: Color = .main
  let proteinColor: Color = .green
  let lipidColor: Color = .dark
  
  var body: some View {
    VStack(spacing: 24) {
      HStack {
        Text("아래 그래프에서 담을 수 있는 ") +
        Text("탄").foregroundColor(.blue) +
        Text(".") +
        Text("단").foregroundColor(.blue) +
        Text(".") +
        Text("지").foregroundColor(.blue) +
        Text("를 확인해보세요!")
      }
      .font(.pretendard(type: .medium, size: 14))
      .multilineTextAlignment(.center)
      HStack(spacing: 24) {
        NutrientRing(nutrient: "탄수화물", value: 30, total: 120, mainColor: carbonColor)
        NutrientRing(nutrient: "단백질", value: 30, total: 120, mainColor: proteinColor)
        NutrientRing(nutrient: "지방", value: 30, total: 120, mainColor: lipidColor)
      }
    }
    .padding(.horizontal, 32)
    .padding(.vertical, 30)
    .background(Color.white)
    .cornerRadius(12)
  }
}

struct NutrientRing: View {
  let nutrient: String
  let value: Double
  let total: Double
  let mainColor: Color
  
  var body: some View {
    VStack(spacing: 8) {
      ZStack {
        Circle()
          .fill(Color.main.opacity(0.12))
          .strokeBorder(Color.main.opacity(0.24), lineWidth: 8)
        
        TrimmedCircle(progress: (total - value) / total)
          .strokeBorder(
            mainColor,
            style: StrokeStyle(lineWidth: 8, lineCap: .round)
          )
        
        Text("\(trimmedNumberString(from: value))g")
          .font(.title)
      }
      .frame(width: 100, height: 100)
      
      Text(nutrient)
        .font(.caption)
        .foregroundColor(.black)
    }
  }
  
  // 정수는 정수로, 소수이면 소수 아래 두 번째 자리까지 출럭시켜주는 함수
  func trimmedNumberString(from value: Double) -> String {
      let formatter = NumberFormatter()
      formatter.minimumFractionDigits = 0
      formatter.maximumFractionDigits = 2
      formatter.numberStyle = .decimal
      return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
  }
}

// 진행바, 일반으로 짜면 오류 계속 나서 이렇게 했음
struct TrimmedCircle: InsettableShape {
    var progress: Double
    var insetAmount: CGFloat = 0  // InsettableShape 요구

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = (min(rect.width, rect.height) / 2) - insetAmount
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startAngle = -90.0
        let endAngle = startAngle + (360.0 * progress)

        path.addArc(center: center,
                    radius: radius,
                    startAngle: .degrees(startAngle),
                    endAngle: .degrees(endAngle),
                    clockwise: false)

        return path
    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}

#Preview {
    NutrientSectionView()
}
