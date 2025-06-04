//
//  GoalType.swift
//  YAP
//
//  Created by 여성일 on 5/30/25.
//

import Foundation

enum GoalType: String, CaseIterable, Codable {
  case diet = "체중 감량"
  case weightMaintain = "유지"
  case bulkUp = "벌크업"
}
