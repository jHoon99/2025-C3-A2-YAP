//
//  NutritionModel.swift
//  YAP
//
//  Created by 조재훈 on 5/29/25.
//

import Foundation

// MARK: - API 응답구조 최상위
struct NutritionResponse: Codable {
  let header: Header
  let body: Body
}

// MARK: - API 응답구조 헤더
struct Header: Codable {
  let resultCode: String
  let resultMsg: String
}

// MARK: - API 응답구조 바디
struct Body: Codable {
  let items: [FoodItem]
}

// MARK: - 음식 영양성분 데이터
struct FoodItem: Identifiable, Codable {
  let id = UUID()
  let foodName: String
  let servingSize: String  // 영양성분 기준량
  let totalSize: String    // 총 중량
  let calories: String     // 칼로리
  let protein: String      // 단백질
  let fat: String          // 지방
  let carbohydrate: String // 탄수화물
  let sugar: String        // 당
  let dietaryFiber: String // 식이섬유
  let sodium: String       // 나트륨(mg)
  let cholesterol: String  // 콜레스테롤
  let saturatedFat: String // 포화지방

  enum CodingKeys: String, CodingKey {
    case foodName = "FOOD_NM_KR"
    case servingSize = "SERVING_SIZE"
    case totalSize = "Z10500"
    case calories = "AMT_NUM1"
    case protein = "AMT_NUM3"
    case fat = "AMT_NUM4"
    case carbohydrate = "AMT_NUM6"
    case sugar = "AMT_NUM7"
    case dietaryFiber = "AMT_NUM8"
    case sodium = "AMT_NUM13"
    case cholesterol = "AMT_NUM23"
    case saturatedFat = "AMT_NUM24"
  }
}

extension FoodItem {
  // api에서 제공하는 칼로리는 100g 당 칼로리이고, 리스트에서 보여주는건 1인분(총 중량)에 대한 칼로리
  // 그에 맞는 계산식
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
  
  var totalSizeIntFormatted: String {
    let numericTotalSize = totalSize.filter("0123456789.".contains)
    if let total = Double(numericTotalSize) {
      return "\(Int(total))g"
    }
    return totalSize
  }
}
