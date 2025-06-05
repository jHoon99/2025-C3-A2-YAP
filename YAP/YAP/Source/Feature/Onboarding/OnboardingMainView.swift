//
//  OnboardingMainView.swift
//  YAP
//
//  Created by 여성일 on 6/3/25.
//

import SwiftUI

struct OnboardingMainView: View {
  @Environment(\.dismiss) private var dismiss
  
  @State private var isNext = false
  @State private var currentIndex = 0
  @State private var selectedGoal: GoalType? = nil
  @State private var selectedActivityLevel: ActivityType? = nil
  @State private var selectedMealCount: MealCountType? = nil
  
  @State private var onboardingItems: OnboardingItem = .initItem
  
  private let totalPage = 4
  
  var isCurrentStepValid: Bool {
    guard let step = OnboardingStep(rawValue: currentIndex) else {
      return true
    }
    
    switch step {
    case .goal:
      return selectedGoal != nil
      
    case .activity:
      return selectedActivityLevel != nil
      
    case .meal:
      return selectedMealCount != nil
    }
  }
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.clear.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: Spacing.large) {
        ProgressView(value: Double(currentIndex + 1), total: Double(totalPage))
          .tint(.main)
          .animation(.easeInOut(duration: 0.3), value: currentIndex)
        
        ZStack {
          if currentIndex == 0 {
            OnboardingInbodyView(currentIndex: $currentIndex, infoItems: $onboardingItems.inbody)
          } else if currentIndex == 1 {
            OnboardingGoalView(
              currentIndex: $currentIndex,
              selectedGoal: $selectedGoal,
              onboardingItem: $onboardingItems
            )
          } else if currentIndex == 2 {
            OnboardingActivityLevelView(
              currentIndex: $currentIndex,
              selectedActivityLevel: $selectedActivityLevel,
              onboardingItem: $onboardingItems
            )
          } else {
            OnboardingMealCountView(
              currentIndex: $currentIndex,
              selectedMealCount: $selectedMealCount,
              onboardingItem: $onboardingItems
            )
          }
        }
        
        Spacer()
        
        bottomButtonView
      }
    }
    .padding(.horizontal, Spacing.medium)
    .padding(.vertical, Spacing.extrLarge)
    .navigationDestination(isPresented: $isNext) {
      OnboardingResultView(onboardingItem: $onboardingItems)
    }
  }
  
  private var bottomButtonView: some View {
    HStack {
      CtaButton(
        buttonName: .before,
        titleColor: .main,
        bgColor: .light
      ) {
        if currentIndex == 0 {
          dismiss()
        } else {
          beforeButtonTapped()
        }
      }
      
      Spacer()
      
      CtaButton(
        buttonName: .next,
        titleColor: .white,
        bgColor: .main
      ) {
        if currentIndex == 3 {
          goToResultButtonTapped()
        } else {
          nextButtonTapped()
        }
      }
      .disabled(!isCurrentStepValid)
    }
  }
}

private extension OnboardingMainView {
  func beforeButtonTapped() {
    currentIndex -= 1
  }
  
  func nextButtonTapped() {
    if currentIndex == 0 {
      if let weightItem = onboardingItems.inbody.first(where: { $0.type == .weight }),
         let fatPctItem = onboardingItems.inbody.first(where: { $0.type == .bodyFatPercentage }),
         let index = onboardingItems.inbody.firstIndex(where: { $0.type == .leanBodyMass }) {
        
        let leanBodyMass = weightItem.value * (1 - (fatPctItem.value / 100))
        onboardingItems.inbody[index].value = leanBodyMass
      }
    }
    
    currentIndex += 1
  }
  
  func goToResultButtonTapped() {
    isNext = true
  }
}

#Preview {
  OnboardingMainView()
}
