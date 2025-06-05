//
//  Calculate.swift
//  YAP
//
//  Created by 조재훈 on 6/4/25.
//

import Foundation

// MARK: - api에서 제공하는 칼로리는 100g 당 칼로리이고, String -> Int로 변환하면서 총 중량에 대한 칼로리 필요
extension FoodItem {
  var totalCaloires: Int {
    let numericCalories = calories.filter("0123456789.".contains)
    let numericTotalSize = totalSize.filter("0123456789.".contains)
    
    guard let per100g = Double(numericCalories),
          let total = Double(numericTotalSize)
    else {
      return 0
    }
    return Int((per100g / 100) * total)
  }
  
  var totalCarbohydrate: Int {
    let numericCarbo = carbohydrate.filter("0123456789.".contains)
    let numericTotalSize = totalSize.filter("0123456789.".contains)
    
    guard let per100g = Double(numericCarbo),
          let total = Double(numericTotalSize)
    else {
      return 0
    }
    return Int((per100g / 100) * total)
  }
  
  var totalProtein: Int {
    let numericProtein = protein.filter("0123456789.".contains)
    let numericTotalSize = totalSize.filter("0123456789.".contains)
    
    guard let per100g = Double(numericProtein),
          let total = Double(numericTotalSize)
    else {
      return 0
    }
    return Int((per100g / 100) * total)
  }
  
  var totalFat: Int {
    let numericFat = fat.filter("0123456789.".contains)
    let numericTotalSize = totalSize.filter("0123456789.".contains)
    
    guard let per100g = Double(numericFat),
          let total = Double(numericTotalSize)
    else {
      return 0
    }
    return Int((per100g / 100) * total)
  }
  
  var totalSizeIntFormatted: String {
    let numericTotalSize = totalSize.filter("0123456789.".contains)
    if let total = Double(numericTotalSize) {
      return "\(Int(total))g"
    }
    return totalSize
  }
  
  var formattedCarbo: Int {
    let numericCarbo = carbohydrate.filter("0123456789.".contains)
    if let total = Double(numericCarbo) {
      return Int(total)
    }
    return 0
  }
  
  var formattedProtein: Int {
    let numericProtein = protein.filter("0123456789.".contains)
    if let total = Double(numericProtein) {
      return Int(total)
    }
    return 0
  }
  
  var formattedFat: Int {
    let numericFat = fat.filter("0123456789.".contains)
    if let total = Double(numericFat) {
      return Int(total)
    }
    return 0
  }
  
  var formattedCalorie: Int {
    let numericCalorie = calories.filter("0123456789.".contains)
    if let total = Double(numericCalorie) {
      return Int(total)
    }
    return 0
  }
  
  func nutrientValue(for type: NutritionType, quantity: Int, unit: NutritionUnit) -> Int {
      switch (unit, type) {
      case (.totalGram, .calorie):
          return totalCaloires * quantity
      case (.gram, .calorie):
          return formattedCalorie * quantity / 100

      case (.totalGram, .carbohydrate):
          return totalCarbohydrate * quantity
      case (.gram, .carbohydrate):
          return formattedCarbo * quantity / 100

      case (.totalGram, .protein):
          return totalProtein * quantity
      case (.gram, .protein):
          return formattedProtein * quantity / 100

      case (.totalGram, .fat):
          return totalFat * quantity
      case (.gram, .fat):
          return formattedFat * quantity / 100
      }
  }
}
