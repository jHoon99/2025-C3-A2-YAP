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
/// CtaButton(
///   buttonName: .next,
///   titleColor: .white,
///   bgColor: .main
/// ) {
///   print("버튼 액션")
/// }

public struct CtaButton: View {
  let title: String
  let titleColor: String
  let bgColor: String
  let action: () -> Void
  
  public init(
    buttonName: CtaButtonLabel,
    titleColor: CtaButtonColor,
    bgColor: CtaButtonColor,
    action: @escaping () -> Void
  ) {
    self.title = buttonName.rawValue
    self.titleColor = titleColor.rawValue
    self.bgColor = bgColor.rawValue
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      Text(title)
        .font(.pretendard(type: .medium, size: 14))
        .frame(maxWidth: .infinity)
        .padding(Spacing.medium)
        .background(Color(bgColor), in: RoundedRectangle(cornerRadius: 12))
        .foregroundStyle(titleColor == "white" ? Color.white : Color(titleColor))
    }
    .buttonStyle(.plain)
  }
}
