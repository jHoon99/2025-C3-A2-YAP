//
//  OnboardingInbodyOcrView.swift
//  YAP
//
//  Created by 여성일 on 6/2/25.
//

import AVFoundation
import SwiftUI

struct OnboardingInbodyOcrView: View {
  @ObservedObject var viewModel: OnboardingViewModel
  
  @State private var isNext = false
  let cameraManager: CameraManager
  
  var body: some View {
    ZStack {
      Color.clear.ignoresSafeArea()
      
      VStack(spacing: Spacing.large) {
        previewView
        ocrBottomButtonView
      }
    }
    .padding(.horizontal, Spacing.medium)
    .padding(.vertical, Spacing.extraLarge)
    .onAppear {
      cameraManager.startSession()
    }
    .onDisappear {
      cameraManager.stopSession()
    }
    .toolbar(.hidden)
    .onChange(of: viewModel.isInbodyDataReady) { _, newValue in
      if newValue {
        isNext = true
      }
    }
    .navigationDestination(isPresented: $isNext) {
      OnboardingMainView(viewModel: viewModel)
    }
  }
  
  private var previewView: some View {
    ZStack {
      GuideLineView()
        .padding(.horizontal, -5)
        .padding(.vertical, -5)
      
      CameraPreviewView(session: cameraManager.session)
      
      VStack {
        Spacer()
        
        Button {
          print("Capture Button Tapped!")
          viewModel.captureImage()
        } label: {
          Text("촬영")
            .frame(width: 50, height: 50)
            .background(Color.blue)
            .clipShape(.circle)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 12)
      }
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

//#Preview {
//  OnboardingInbodyOcrView()
//}
