//
//  OnboardingViewModel.swift
//  YAP
//
//  Created by 여성일 on 6/11/25.
//

import SwiftUI

final class OnboardingViewModel: ObservableObject {
  let cameraManager: CameraManager
  
  @Published var item: OnboardingModel = .init(
    inbodyInfoItem: .init(
      height: 0.0,
      weight: 0.0,
      age: 0,
      bodyFatMass: 0.0,
      bodyFatPercentage: 0.0,
      basalMetabolicRate: 0.0,
      skeletalMuscleMass: 0.0,
      leanBodyMass: 0.0
    ),
    activityInfoItem: .init()
  )
  
  @Published var calorieRequirementsItem: CalorieRequirementsItem = .init(
    carbohydrates: 0,
    protein: 0,
    lipid: 0,
    calorie: 0
  )
  
  @Published var isDataFormatError: Bool = false
  @Published var isInbodyDataReady: Bool = false
  @Published var currentIndex: Int = 0
  
  init(cameraManager: CameraManager) {
    self.cameraManager = cameraManager
  }
  
  func captureImage() {
    Task {
      if let image = cameraManager.capturedImage() {
        let data = await FireBaseManager().callAI(image: image)
        applyInbodyData(data)
      }
    }
  }
  
  func beforeButtonTapped() {
    currentIndex -= 1
  }
  
  func nextButtonTapped() {
    currentIndex += 1
    print(currentIndex)
  }
  
  func calculrateCalorieRequirements() {
    let calorie = item.inbodyInfoItem.basalMetabolicRate * (item.activityInfoItem.activityLevel?.activityMultiplier ?? 0.0)
    let protein = item.inbodyInfoItem.leanBodyMass * 2.1
    
    let proteinKcal = calorie - (protein * 4)
    let lipid = (proteinKcal * 0.6) / 9
    let carbohydrates = (proteinKcal * 0.4) / 4
    
    self.calorieRequirementsItem = CalorieRequirementsItem(carbohydrates: Int(carbohydrates), protein: Int(protein), lipid: Int(lipid), calorie: Int(calorie))
  }
}

private extension OnboardingViewModel {
  func applyInbodyData(_ data: [String]) {
    guard data.count == 7,
          let age = Int(data[0]),
          let height = Double(data[1]),
          let weight = Double(data[2]),
          let bmr = Double(data[3]),
          let bodyFatPercentage = Double(data[4]),
          let bodyFatMass = Double(data[5]),
          let skeletalMuscleMass = Double(data[6]) else {
      DispatchQueue.main.async {
        self.isDataFormatError = true
      }
      print("잘못된 데이터 형식입니다.")
      return
    }
    
    DispatchQueue.main.async {
      self.item.inbodyInfoItem = InbodyInfoItem(
        height: height,
        weight: weight,
        age: age,
        bodyFatMass: bodyFatMass,
        bodyFatPercentage: bodyFatPercentage,
        basalMetabolicRate: bmr,
        skeletalMuscleMass: skeletalMuscleMass,
        leanBodyMass: weight - bodyFatMass // 예시: 제지방량 = 체중 - 체지방량
      )
      
      self.isInbodyDataReady = true
    }
  }
}
