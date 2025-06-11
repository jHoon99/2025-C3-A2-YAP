//
//  FireBaseManager.swift
//  YAP
//
//  Created by 여성일 on 6/11/25.
//

import FirebaseAI
import UIKit
import Foundation

final class FireBaseManager {
  func callAI(image: UIImage) async -> [String] {
    do {
      let prompt = "이미지를 보고 이사람의 나이, 키, 몸무게, 기초대사량, 골격근량, 체지방량, 체지방률을 구해줘. 그리고 슬래시를 통해 구분해줘. 예를 들면 27/177/71/2300/30/17/15"
      let ai = FirebaseAI.firebaseAI(backend: .googleAI())
      let model = ai.generativeModel(modelName: "gemini-2.0-flash")
      let response = try await model.generateContent(prompt, image)
      
      if let answer = response.text {
        print("FirebaseAI response:", answer)
        let arr = answer.components(separatedBy: "/")
        print(arr)
        return arr
      }
    } catch {
      print("FirebaseAI error:", error)
    }
    
    return []
  }
}
