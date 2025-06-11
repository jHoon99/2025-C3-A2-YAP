//
//  InbodySetRowView.swift
//  YAP
//
//  Created by 여성일 on 6/11/25.
//

import SwiftUI

struct InbodySetRowView: View {
  let type: InbodyInfoType
  let value: Double
  let unit: UnitType
  let onTap: () -> Void
  
  var body: some View {
    HStack {
      Text(type.rawValue)
        .font(.pretendard(type: .semibold, size: 16))
      
      Spacer()
      
      InbodyInfoButton(
        value: String(value),
        unit: unit
      ) {
        if type != .leanBodyMass {
          onTap()
        }
      }
    }
  }
}
