//
//  OnboardingActivityLevelView.swift
//  YAP
//
//  Created by 여성일 on 6/3/25.
//

import SwiftUI

struct OnboardingActivityLevelView: View {
  @Binding var currentIndex: Int
  @Binding var selectedActivityLevel: ActivityType?
  @Binding var onboardingItem: OnboardingItem
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.clear.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: Spacing.extrLarge) {
        titleView
        activityLevelButtonView
      }
    }
    .navigationBarBackButtonHidden()
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
  
  private var activityLevelButtonView: some View {
    VStack(spacing: Spacing.small) {
      ForEach(ActivityType.allCases, id: \.self) { type in
        SelectButton(
          title: type.rawValue,
          caption: type.caption,
          isSelected: selectedActivityLevel == type
        ) {
          activityButtonTapped(type)
          onboardingItem.activityInfo.activityLevel = type
        }
      }
    }
  }
}

private extension OnboardingActivityLevelView {
  func activityButtonTapped(_ type: ActivityType) {
    selectedActivityLevel = type
  }
}

#Preview {
  OnboardingActivityLevelView(
    currentIndex: .constant(2),
    selectedActivityLevel: .constant(.middleActivity),
    onboardingItem: .constant(.initItem)
  )
}
