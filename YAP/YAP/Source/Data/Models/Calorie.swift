//
//  Calorie.swift
//  YAP
//
//  Created by 여성일 on 5/30/25.
//

import Foundation
import SwiftData

@Model
class Menu {
  var name: String
  var carbohydrates: Double // 탄수화물
  var protein: Double // 단백질
  var lipid: Double // 지방
  var kcal: Int
  
  init(
    name: String,
    carbohydrates: Double,
    protein: Double,
    lipid: Double,
    kcal: Int
  ) {
    self.name = name
    self.carbohydrates = carbohydrates
    self.protein = protein
    self.lipid = lipid
    self.kcal = kcal
  }
}

@Model
class Meal {
  var day: Date // 날짜
  var carbohydrates: Double // 탄수화물
  var protein: Double // 단백질
  var lipid: Double // 지방
  var kcal: Int //칼로리
  
  @Relationship(deleteRule: .cascade)
  var menus: [Menu]

  init(
    day: Date,
    carbohydrates: Double,
    protein: Double,
    lipid: Double,
    kcal: Int,
    menus: [Menu]
  ) {
    self.day = day
    self.carbohydrates = carbohydrates
    self.protein = protein
    self.lipid = lipid
    self.kcal = kcal
    self.menus = menus
  }
}
