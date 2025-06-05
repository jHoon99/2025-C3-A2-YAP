//
//  ModalCircle.swift
//  YAP
//
//  Created by 조재훈 on 6/3/25.
//

import SwiftUI

struct ModalCircle: View {
  
  let title: String
  let value: Int
  let unit: String
  
    var body: some View {
      HStack(spacing: Spacing.small) {
        ZStack {
          Circle()
            .fill(Color.dark)
            .frame(width: 26, height: 26)
          Text(title)
            .font(.pretendard(type: .semibold, size: 14))
            .foregroundColor(.mainWhite)
        }
        VStack {
          Text("\(value)\(unit)")
            .font(.pretendard(type: .bold, size: 14))
            .monospacedDigit()
            .frame(width: 50, alignment: .center)
        }
      }
//      .frame(width: 68)
    }
}

#Preview {
  ModalCircle(
    title: "탄",
    value: 100,
    unit: "g"
  )
}
