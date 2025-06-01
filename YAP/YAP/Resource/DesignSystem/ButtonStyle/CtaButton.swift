//
//  CtaButton.swift
//  YAP
//
//  Created by Hong on 6/1/25.
//

import SwiftUI

/// **
/// 공통 CTA 버튼
/// ```swift
/// CtaButton(buttonName: .add) {
///    print("버튼 눌림 액션")
/// }

public struct CtaButton: View {
  let title: String
  let action: () -> Void
  
  public init(
    buttonName: CtaButtonLabel,
    action: @escaping () -> Void
  ) {
    self.title = buttonName.rawValue
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      Text(title)
        .font(.pretendard(type: .medium, size: 14))
        .frame(maxWidth: .infinity)
        .padding(Spacing.medium)
        .background(Color.main, in: RoundedRectangle(cornerRadius: 12))
        .foregroundStyle(.white)
    }
  }
}
