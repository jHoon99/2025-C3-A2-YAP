//
//  MacroType.swift
//  YAP
//
//  Created by 여성일 on 6/5/25.
//

import Foundation

enum MacroType: String, CaseIterable, Identifiable {
  case carbohydrate = "탄수화물"
  case protein = "단백질"
  case fat = "지방"
  
  var id: Self { self }
  
  var title: String {
    rawValue
  }
}
