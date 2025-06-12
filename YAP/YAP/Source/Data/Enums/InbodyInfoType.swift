//
//  InbodyType.swift
//  YAP
//
//  Created by 여성일 on 6/4/25.
//

import Foundation

enum InbodyInfoType: String, CaseIterable, Codable, Identifiable {
  var id: String { self.rawValue }
  
  case height = "키"
  case weight = "몸무게"
  case age = "나이"
  case bodyFatMass = "체지방량"
  case bodyFatPercentage = "체지방률"
  case basalMetabolicRate = "기초대사량"
  case skeletalMuscleMass = "골격근량"
  case leanBodyMass = "제지방량"

  var minValue: Double {
    switch self {
    case .bodyFatMass, .height, .weight:
      return 0.0
    case .skeletalMuscleMass:
      return 10.0
    case .bodyFatPercentage:
      return 3.0
    case .basalMetabolicRate:
      return 1000.0
    case .leanBodyMass, .age:
      return 0.0
    }
  }
  
  var maxValue: Double {
    switch self {
    case .height, .weight:
      return 200.0
    case .bodyFatMass:
      return 100.0
    case .skeletalMuscleMass:
      return 50.0
    case .bodyFatPercentage:
      return 50.0
    case .basalMetabolicRate:
      return 3000.0
    case .leanBodyMass, .age:
      return 0.0
    }
  }
  
  func text(value: any Numeric) -> String {
    return "당신의 \(rawValue)는(은) \(value)인가요?"
  }
}
