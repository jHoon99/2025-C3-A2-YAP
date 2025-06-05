//
//  OnboardingView.swift
//  YAP
//
//  Created by 여성일 on 5/28/25.
//

import SwiftUI

struct OnboardingView: View {
  @State private var isNext = false
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .topLeading) {
        Color.clear.ignoresSafeArea()
        VStack(alignment: .leading) {
          titleView
          
          Spacer()
          
          healthManImageView
          
          Spacer()
          
          CtaButton(buttonName: .next, titleColor: .white, bgColor: .main) {
            nextButtonTapped()
          }
        }
      }
      .padding(.horizontal, Spacing.medium)
      .padding(.vertical, Spacing.extrLarge)
      .navigationDestination(isPresented: $isNext) {
        OnboardingInbodyOcrView()
      }
    }
  }
  
  private var titleView: some View {
    VStack(alignment: .leading) {
      Text("반가워요!\n")
        .font(.pretendard(type: .semibold, size: 24))
      
      Text("요구 칼로리 계산을 위해,\n기본 정보를 입력해주세요!")
        .font(.pretendard(type: .semibold, size: 24))
    }
  }
  
  private var healthManImageView: some View {
    HStack {
      Spacer()
      
      Image(.healthMan)
      
      Spacer()
    }
  }
}

private extension OnboardingView {
  func nextButtonTapped() {
    isNext = true
  }
}

#Preview {
  OnboardingView()
}
