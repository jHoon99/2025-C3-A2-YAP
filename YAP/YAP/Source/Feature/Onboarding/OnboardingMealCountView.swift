//
//  OnboardingMealCountView.swift
//  YAP
//
//  Created by 여성일 on 6/3/25.
//

import SwiftUI

struct OnboardingMealCountView: View {
  @ObservedObject var viewModel: OnboardingViewModel
  @State var selectedMealCount: MealCountType? = nil
  @Binding var isNext: Bool
  
  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.clear.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: Spacing.extraLarge) {
        titleView
        mealCountButtonView
        
        Spacer()
        
        bottomButtonView
      }
    }
    .navigationBarBackButtonHidden()
  }
  
  private var titleView: some View {
    VStack(alignment: .leading, spacing: Spacing.small) {
      Text("이제 마지막이에요\n끼니 수를 설정해주세요. ")
        .font(.pretendard(type: .semibold, size: 28))
        .foregroundStyle(.text)
      
      Text("각 끼니별로 섭취하면 좋은 칼로리 정보를 알려드릴게요.\n꼭 규칙적인 식사가 아니어도 괜찮아요.")
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
        bgColor: .main,
        isDisabled: selectedMealCount == nil
      ) {
        isNext = true 
      }
    }
  }
  
  private var mealCountButtonView: some View {
    LazyVGrid(columns: columns, spacing: Spacing.small) {
      ForEach(MealCountType.allCases, id: \.self) { type in
        SelectButton(
          title: type.rawValue,
          isSelected: selectedMealCount == type
        ) {
          mealCountButtonTapped(type)
        }
      }
    }
  }
}

private extension OnboardingMealCountView {
  func mealCountButtonTapped(_ type: MealCountType) {
    selectedMealCount = type
    viewModel.item.activityInfoItem.mealCount = type.intValue
    viewModel.calculrateCalorieRequirements()
  }
}
