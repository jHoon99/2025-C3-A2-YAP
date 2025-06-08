//
//  WorkOutType.swift
//  YAP
//
//  Created by 여성일 on 6/6/25.
//
import Foundation

enum WorkOutType: String, CaseIterable, Codable, Identifiable {
  var id: String { self.rawValue }
  
  case running = "런닝"
  case bike = "실내 자전거"
  case stepmill = "천국의 계단"
  case rowing = "로잉 머신"
  case benchPress = "벤치 프레스"
  case squat = "스쿼트"
  case deadLift = "데드 리프트"
}

extension WorkOutType {
  enum Category {
    case cardio
    case weight
  }

  var category: Category {
    switch self {
    case .running, .bike, .stepmill, .rowing:
      return .cardio
    case .benchPress, .squat, .deadLift:
      return .weight
    }
  }

  var imageAsset: AssetImageString {
    switch self {
    case .running: return .running
    case .bike: return .bike
    case .stepmill: return .stepmill
    case .rowing: return .rowing
    case .benchPress: return .benchPress
    case .squat: return .squat
    case .deadLift: return .deadLift
    }
  }
  
  /// 반환하는 클로저의 파라미터는 총 칼로리입니다.
  /// 반환하는 클로저의 반환값은 유산소 운동의 경우 분 당 소모 칼로리를, 웨이트 트레이닝의 경우 세트 당 소모 칼로리입니다.
  private var amountCalculator: (Int) -> Int {
    switch self {
    case .running: return { cal in cal / 10 }
    case .bike: return { cal in cal / 8 }
    case .stepmill: return { cal in cal / 9 }
    case .rowing: return { cal in cal / 11 }
    case .benchPress: return { cal in cal / 15 }
    case .squat: return { cal in cal / 20 }
    case .deadLift: return { cal in cal / 25 }
    }
  }
  
  func calculateAmout(ofCalorie cal: Int) -> String {
    switch self.category {
    case .cardio:
      return "\(self.amountCalculator(cal))분"
    case .weight:
      return "\(self.amountCalculator(cal))세트"
    }
  }
}
