//
//  InputAgeSheet.swift
//  YAP
//
//  Created by 여성일 on 6/4/25.
//

import SwiftUI

struct InputAgeSheet: View {
  @Binding var infoItem: InbodyInfoItem
  
  private let ageRange = Array(19...100)
  
  var body: some View {
    VStack {
      Picker("나이",
             selection: Binding(
              get: { Int(infoItem.value) },
              set: { newAge in infoItem.value = Double(newAge) })
      ) {
        ForEach(ageRange, id: \.self) { age in
          Text("\(age) 세")
            .tag(age)
        }
      }
      .pickerStyle(.wheel)
      .labelsHidden()
      .frame(height: 200)
    }
  }
}

#Preview {
  InputAgeSheet(infoItem: .constant(InbodyInfoItem.init(type: .age, value: 18.0, unit: .age)))
}
