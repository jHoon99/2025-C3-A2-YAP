//
//  InputAgeSheet.swift
//  YAP
//
//  Created by 여성일 on 6/4/25.
//

import SwiftUI

struct InputAgeSheet: View {
  @Binding var value: Int
  let minimumValue: Int = 10
  let maximumValue: Int = 100

  var body: some View {
    VStack(alignment: .leading) {
      Text("나이를 입력하세요")
        .font(.pretendard(type: .medium, size: 16))

      Slider(
        value: Binding<Double>(
          get: { Double(value) },
          set: { value = Int($0) }
        ),
        in: Double(minimumValue)...Double(maximumValue),
        step: 1
      )
      .tint(.main)

      Text("\(value)세")
        .font(.pretendard(type: .medium, size: 16))
        .frame(maxWidth: .infinity, alignment: .center)
    }
    .padding(.horizontal, Spacing.small)
  }
}
