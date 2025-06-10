//
//  ExcessCalorie.swift
//  YAP
//
//  Created by oliver on 6/10/25.
//

import SwiftData
import Foundation

@Model
class CalorieToBurn {
  var date: Date
  var calorie: Int
  
  init(date: Date, calorie: Int) {
    self.date = date.startOfDay
    self.calorie = calorie
  }
  
  func isSameDate(as date: Date) -> Bool {
    return self.date == date.startOfDay
  }
  
  func addCalorie(_ amount: Int) {
    self.calorie += amount
  }
}
