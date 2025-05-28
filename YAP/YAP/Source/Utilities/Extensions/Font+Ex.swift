//
//  Font+Ex.swift
//  YAP
//
//  Created by 여성일 on 5/28/25.
//

import SwiftUI

extension Font {
  enum Pretendard {
    case bold
    case semibold
    case medium
    case regular
    case light
    
    var value: String {
      switch self {
      case .bold:
        return "Pretendard-Bold"
      case .semibold:
        return "Pretendard-SemiBold"
      case .medium:
        return "Pretendard-Medium"
      case .regular:
        return "Pretendard-Medium"
      case .light:
        return "Pretendard-Medium"
      }
    }
  }
  
  static func pretendard(type: Pretendard, size: CGFloat) -> Font {
    return .custom(type.value, size: size)
  }
}
