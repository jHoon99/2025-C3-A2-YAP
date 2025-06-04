//
//  OnboardingInbodyOcrView.swift
//  YAP
//
//  Created by 여성일 on 6/2/25.
//

import SwiftUI

struct OnboardingInbodyOcrView: View {
  @State private var isNext = false
  @State private var value = 0.5
  
  var body: some View {
    ZStack {
      Color.clear.ignoresSafeArea()
      
      VStack(spacing: Spacing.large) {
        ocrPreviewView
        ocrBottomButtonView
      }
    }
    .padding(.horizontal, Spacing.medium)
    .padding(.vertical, Spacing.extrLarge)
    .toolbar(.hidden)
    .navigationDestination(isPresented: $isNext) {
      OnboardingMainView()
    }
  }
  
  private var ocrPreviewView: some View {
    VStack(spacing: Spacing.large) {
      Text("가이드 영역에 인바디 결과지를 맞춰주세요.")
        .font(.pretendard(type: .bold, size: 16))
        .foregroundStyle(.text)
      OcrGuideLineView()
    }
  }
  
  private var ocrBottomButtonView: some View {
    VStack(spacing: Spacing.small) {
      Text("인바디 결과지가 인식되지 않는다면 직접 입력해주세요.")
        .font(.pretendard(type: .light, size: 12))
        .foregroundStyle(.text)
      
      Button {
        isEditButtonTapped()
      } label: {
        Text("직접 입력")
          .font(.pretendard(type: .bold, size: 16))
          .foregroundStyle(.text)
          .frame(maxWidth: .infinity)
      }
      .overlay(
        Rectangle()
          .frame(height: 1)
          .frame(maxWidth: 60)
          .foregroundStyle(.text)
          .padding(.bottom, 0),
        alignment: .bottom
      )
    }
    .buttonStyle(.plain)
  }
}

private extension OnboardingInbodyOcrView {
  func isEditButtonTapped() {
    isNext = true
  }
}
#Preview {
  OnboardingInbodyOcrView()
}
