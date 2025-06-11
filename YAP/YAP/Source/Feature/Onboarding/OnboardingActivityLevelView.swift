//
//  OnboardingActivityLevelView.swift
//  YAP
//
//  Created by 여성일 on 6/3/25.
//

import SwiftUI

struct OnboardingActivityLevelView: View {
  @ObservedObject var viewModel: OnboardingViewModel
  
  @State var selectedActivityLevel: ActivityType? = nil
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.clear.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: Spacing.extraLarge) {
        titleView
        activityLevelButtonView
        
        Spacer()
        
        bottomButtonView
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      print(viewModel.item)
    }
  }
  
  private var titleView: some View {
    VStack(alignment: .leading, spacing: Spacing.small) {
      Text("활동 수준을 선택해 주세요.")
        .font(.pretendard(type: .semibold, size: 28))
        .foregroundStyle(.text)
      
      Text("하루 동안 얼마나 움직이나요?")
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
  
  private var activityLevelButtonView: some View {
    VStack(spacing: Spacing.small) {
      ForEach(ActivityType.allCases, id: \.self) { type in
        SelectButton(
          title: type.rawValue,
          caption: type.caption,
          isSelected: selectedActivityLevel == type
        ) {
          activityButtonTapped(type)
        }
      }
    }
  }
}

private extension OnboardingActivityLevelView {
  func activityButtonTapped(_ type: ActivityType) {
    selectedActivityLevel = type
    viewModel.item.activityInfoItem.activityLevel = type
  }
}
