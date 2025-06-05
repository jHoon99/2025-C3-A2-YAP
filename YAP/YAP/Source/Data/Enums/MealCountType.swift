//
//  MealCountType.swift
//  YAP
//
//  Created by 여성일 on 6/3/25.
//

import Foundation

enum MealCountType: String, CaseIterable {
  case one = "한 끼"
  case two = "두 끼"
  case three = "세 끼"
  case four = "네 끼"
  case five = "다섯 끼"
  case six = "여섯 끼"
  
  var intValue: Int {
    switch self {
    case .one: return 1
    case .two: return 2
    case .three: return 3
    case .four: return 4
    case .five: return 5
    case .six: return 6
    }
  }
}
