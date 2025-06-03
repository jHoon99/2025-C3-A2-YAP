//
//  InbodyInfoButton.swift
//  YAP
//
//  Created by 여성일 on 6/2/25.
//

import SwiftUI

/// **
/// 인바디 정보 수정 버튼
/// ```swift
/// InbodyInfoButton(value: "70", unit: .kg) {
///    print("버튼 눌림 액션")
/// }

public struct InbodyInfoButton: View {
  let value: String
  let unit: String
  let action: () -> Void
  
  public init(
    value: String,
    unit: UnitType,
    action: @escaping () -> Void
  ) {
    self.value = value
    self.unit = unit.rawValue
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      HStack(alignment: .center, spacing: 4) {
        Text("27")
          .font(.pretendard(type: .semibold, size: 16))
          .foregroundStyle(.darker)
        Text("세")
          .font(.pretendard(type: .semibold, size: 12))
          .foregroundStyle(.darker)
      }
    }
    .frame(width: 110, height: 35)
    .background(.light)
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}

#Preview {
  InbodyInfoButton(value: "27", unit: .age, action: { })
}
