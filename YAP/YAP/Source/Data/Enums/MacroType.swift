//
//  MacroType.swift
//  YAP
//
//  Created by 여성일 on 6/5/25.
//

import Foundation

enum MacroType: CaseIterable, Identifiable {
  case carbohydrate
  case protein
  case fat
  
  var id: Self { self }
  
  var title: String {
    switch self {
    case .carbohydrate: return "탄수화물"
    case .protein: return "단백질"
    case .fat: return "지방"
    }
  }
}
