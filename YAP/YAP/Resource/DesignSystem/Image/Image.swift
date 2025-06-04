//
//  Image.swift
//  YAP
//
//  Created by Hong on 6/4/25.
//

enum Icon {
  case camera
  case arrowtriangleDownFill
  case checkmark
  case plus
  case circleFill
  case xmark
  case minus
  case chevronLeft
  case checkmarkCircleFill
  case forkKnifeCircle
}

extension Icon {
  var name: String {
    switch self {
    case .camera:
      return "camera"
    case .arrowtriangleDownFill:
      return "arrowtriangle.down.fill"
    case .checkmark:
      return "checkmark"
    case .plus:
      return "plus"
    case .circleFill:
      return "circle.fill"
    case .xmark:
      return "xmark"
    case .minus:
      return "minus"
    case .chevronLeft:
      return "chevron.left"
    case .checkmarkCircleFill:
      return "checkmark.circle.fill"
    case .forkKnifeCircle:
      return "fork.knife.circle"
    }
  }
}
