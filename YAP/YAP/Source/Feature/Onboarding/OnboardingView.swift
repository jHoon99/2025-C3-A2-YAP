//
//  OnboardingView.swift
//  YAP
//
//  Created by 여성일 on 5/28/25.
//

import SwiftUI
import SceneKit

struct OnboardingView: View {
  @ObservedObject var viewModel: OnboardingViewModel
  @State private var isNext = false
  
  let cameraManager = CameraManager()
  
  init() {
    self.viewModel = OnboardingViewModel(cameraManager: cameraManager)
  }
  
  var body: some View {
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
    .padding(.vertical, Spacing.extraLarge)
    .navigationDestination(isPresented: $isNext) {
      OnboardingInbodyOcrView(viewModel: viewModel, cameraManager: cameraManager)
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
      
      CharacterRenderView()
      
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
