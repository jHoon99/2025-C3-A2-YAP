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
              get: { Int(infoItem.age) },
              set: { newAge in infoItem.age = newAge })
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
