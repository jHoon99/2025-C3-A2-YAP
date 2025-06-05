//
//  Enum.swift
//  YAP
//
//  Created by 여성일 on 5/28/25.
//

import Foundation

enum ActivityType: String, CaseIterable, Codable {
  case verylittleActivity = "매우 적은 활동"
  case littleActivity = "적은 활동"
  case middleActivity = "중간 활동"
  case vigorousActivity = "격한 활동"
  case veryVigorousActivity = "매우 격한 활동"
  
  var caption: String {
    switch self {
    case .verylittleActivity:
      return "거의 하루 종일 앉아서 지내는 좌식 생활"
      
    case .littleActivity:
      return "가끔 가볍게 움직이거나 운동하는 라이트한 생활"
      
    case .middleActivity:
      return "매일은 아니어도 종종 운동하고 적당히 움직이는 균형 잡힌 생활"
      
    case .vigorousActivity:
      return "매일 꾸준한 운동과 활발한 움직임이 있는 고활동 생활"
      
    case .veryVigorousActivity:
      return "지속적인 신체 활동과 고강도 운동이 포함된 매우 높은 활동 생활"
    }
  }
  
  var activityMultiplier: Double {
    switch self {
    case .littleActivity: return 1.2
    case .verylittleActivity: return 1.375
    case .middleActivity: return 1.55
    case .vigorousActivity: return 1.725
    case .veryVigorousActivity: return 1.9
    }
  }
}
