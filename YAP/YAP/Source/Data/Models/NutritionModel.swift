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
