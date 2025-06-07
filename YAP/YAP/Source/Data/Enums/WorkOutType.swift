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
}
