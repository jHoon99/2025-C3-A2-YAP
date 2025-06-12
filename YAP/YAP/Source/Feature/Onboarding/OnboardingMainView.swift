//
//  OnboardingMainView.swift
//  YAP
//
//  Created by 여성일 on 6/3/25.
//

import SwiftUI

struct OnboardingMainView: View {
  @Environment(\.dismiss) private var dismiss
  @ObservedObject var viewModel: OnboardingViewModel
  @State private var isNext = false
  
  private let totalPage = 4
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.clear.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: Spacing.large) {
        ProgressView(value: Double(viewModel.currentIndex + 1), total: Double(totalPage))
          .tint(.main)
          .animation(.easeInOut(duration: 0.3), value: viewModel.currentIndex)
        
        ZStack {
          if viewModel.currentIndex == 0 {
            OnboardingInbodyView(viewModel: viewModel)
          } else if viewModel.currentIndex == 1 {
            OnboardingGoalView(viewModel: viewModel)
          } else if viewModel.currentIndex == 2 {
            OnboardingActivityLevelView(viewModel: viewModel)
          } else if viewModel.currentIndex == 3 {
            OnboardingMealCountView(viewModel: viewModel, isNext: $isNext)
          } else {
            EmptyView()
          }
        }
      }
      .padding(.horizontal, Spacing.medium)
      .padding(.vertical, Spacing.extraLarge)
      .navigationDestination(isPresented: $isNext) {
        OnboardingResultView(viewModel: viewModel)
      }
    }
  }
}

private extension OnboardingMainView {
  func goToResultButtonTapped() {
    isNext = true
  }
}
