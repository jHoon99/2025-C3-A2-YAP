//
//  OnboardingStep.swift.swift
//  YAP
//
//  Created by 여성일 on 6/4/25.
//

enum OnboardingStep: Int, CaseIterable {
  case goal = 1
  case activity
  case meal
  
  var index: Int {
    rawValue
  }
}
