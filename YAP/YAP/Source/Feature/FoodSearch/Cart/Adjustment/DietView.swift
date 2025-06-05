//
//  DietView.swift
//  YAP
//
//  Created by 조재훈 on 6/5/25.
//

import SwiftUI

struct DietView: View {
  let title: String
  let mealTime: String
  let originalCal: Int
  let adjustCal: Int
  
    var body: some View {
      VStack(alignment: .leading, spacing: Spacing.large) {
        Text(title)
          .overlay(Rectangle()
            .frame(height: 3)
            .foregroundColor(.main)
            .offset(y: 16))

        HStack {
          Text(mealTime)
          Spacer()
          HStack {
            Text("\(originalCal)")
              .font(.pretendard(type: .regular, size: 14))
              .foregroundColor(.subText)
              .strikethrough(true)
            
            Image(systemName: "arrow.right")
              .font(.pretendard(type: .regular, size: 14))
            Text("\(adjustCal)")
              .font(.pretendard(type: .semibold, size: 14))
              .foregroundColor(.main)
            Text("kcal")
              .font(.pretendard(type: .regular, size: 14))
              .foregroundColor(.subText)
          }
          .padding(.trailing, Spacing.large)
        }
        Divider()
      }
      .padding(.leading, Spacing.large)
    }
}

#Preview {
    DietView(title: "식단하기", mealTime: "두 번째 식사", originalCal: 700, adjustCal: 600)
}
