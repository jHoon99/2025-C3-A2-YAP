//
//  InbodyInputSheet.swift
//  YAP
//
//  Created by 여성일 on 6/4/25.
//

import SwiftUI

struct InbodyInputSheet: View {
  let infoItem: InbodyInfoItem
  let minimumValue: Double
  let maximumValue: Double
  let text: String
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(text)
        .font(.pretendard(type: .medium, size: 16))
      
      
//      Slider(value: infoItem, in: minimumValue...maximumValue, step: 1)
//        .tint(.main)
    }
    .padding(.horizontal, Spacing.small)
  }
}
