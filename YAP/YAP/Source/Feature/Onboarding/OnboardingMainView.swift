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
  
  private let totalPage = 4
  
  var isCurrentStepValid: Bool {
    switch currentIndex {
    case 1: return selectedGoal != nil
    case 2: return selectedActivityLevel != nil
    case 3: return selectedMealCount != nil
    default: return true
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
            OnboardingInbodyView(currentIndex: $currentIndex)
          } else if currentIndex == 1 {
            OnboardingGoalView(
              currentIndex: $currentIndex,
              selectedGoal: $selectedGoal
            )
          } else if currentIndex == 2 {
            OnboardingActivityLevelView(
              currentIndex: $currentIndex,
              selectedActivityLevel: $selectedActivityLevel
            )
          } else {
            OnboardingMealCountView(
              currentIndex: $currentIndex,
              selectedMealCount: $selectedMealCount
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
      OnboardingResultView()
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
    currentIndex += 1
  }
  
  func goToResultButtonTapped() {
    isNext = true
  }
}

#Preview {
  OnboardingMainView()
}
