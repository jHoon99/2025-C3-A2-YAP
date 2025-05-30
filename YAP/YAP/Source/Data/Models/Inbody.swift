//
//  Inbody.swift
//  YAP
//
//  Created by 여성일 on 5/28/25.
//

import Foundation
import SwiftData

@Model
class Inbody {
  var date: Date
  var weight: Double // 몸무게
  var height: Double // 키
  var age: Int // 나이
  var bodyFatMass: Double // 체지방량
  var BasalMetabolicRate: Int // 기초 대사량
  var SkeletalMuscleMass: Double // 골격근량
  var leanBodyMass: Double // 제지방량,
  var bodyFatPercentage: Double // 체지방률

  // 1:1관계
  @Relationship(deleteRule: .cascade)
  var calorie: Calorie
  
  init(date: Date,
       weight: Double,
       height: Double,
       age: Int,
       bodyFatMass: Double,
       BasalMetabolicRate: Int,
       SkeletalMuscleMass: Double,
       leanBodyMass: Double,
       bodyFatPercentage: Double,
       calorie: Calorie
  ) {
    self.date = date
    self.weight = weight
    self.height = height
    self.age = age
    self.bodyFatMass = bodyFatMass
    self.BasalMetabolicRate = BasalMetabolicRate
    self.SkeletalMuscleMass = SkeletalMuscleMass
    self.leanBodyMass = leanBodyMass
    self.bodyFatPercentage = bodyFatPercentage
    self.calorie = calorie
  }
}
