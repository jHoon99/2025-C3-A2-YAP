//
//  OnboardingGoalView.swift
//  YAP
//
//  Created by 여성일 on 6/3/25.
//

import SwiftUI

struct OnboardingGoalView: View {
  @ObservedObject var viewModel: OnboardingViewModel
  @State var selectedGoal: GoalType? = nil
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.clear.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: Spacing.extraLarge) {
        titleView
        goalButtonView
        
        Spacer()
        
        bottomButtonView
      }
    }
    .navigationBarBackButtonHidden()
  }
  
  private var titleView: some View {
    VStack(alignment: .leading, spacing: Spacing.small) {
      Text("목표를 설정해 주세요")
        .font(.pretendard(type: .semibold, size: 28))
        .foregroundStyle(.text)
      
      Text("이제 어떤 목표를 향해 갈지 알려주세요.")
        .font(.pretendard(type: .semibold, size: 16))
        .foregroundStyle(.subText)
    }
  }
  
  private var bottomButtonView: some View {
    HStack {
      CtaButton(
        buttonName: .before,
        titleColor: .main,
        bgColor: .light
      ) {
        viewModel.beforeButtonTapped()
      }
      
      Spacer()
      
      CtaButton(
        buttonName: .next,
        titleColor: .white,
        bgColor: .main
      ) {
        viewModel.nextButtonTapped()
      }
    }
  }
  
  private var goalButtonView: some View {
    VStack(spacing: Spacing.small) {
      ForEach(GoalType.allCases, id: \.self) { type in
        SelectButton(
          title: type.rawValue,
          isSelected: selectedGoal == type
        ) {
          goalButtonTapped(type)
        }
      }
    }
  }
}

private extension OnboardingGoalView {
  func goalButtonTapped(_ type: GoalType) {
    selectedGoal = type
    viewModel.item.activityInfoItem.goalType = type
  }
}
