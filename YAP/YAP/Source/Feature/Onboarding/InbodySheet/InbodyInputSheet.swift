//
//  InbodyInputSheet.swift
//  YAP
//
//  Created by 여성일 on 6/4/25.
//

import SwiftUI

struct InbodyInputSheet: View {
  @Binding var value: Double
  let type: InbodyInfoType
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(type.text(value: value))
        .font(.pretendard(type: .medium, size: 16))

      Slider(value: $value, in: type.minValue...type.maxValue, step: 1)
        .tint(.main)

      Text("\(Int(value))")
        .font(.pretendard(type: .medium, size: 16))
        .frame(maxWidth: .infinity, alignment: .center)
    }
    .padding(.horizontal, Spacing.small)
  }
}
