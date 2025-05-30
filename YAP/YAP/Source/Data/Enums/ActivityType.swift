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
}
