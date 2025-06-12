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
  @State private var showProgress = false
  
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
      cameraManager.requestAndCheckPermissions()
      cameraManager.startSession()
      showProgress = false
      isNext = false
      viewModel.resetOcrState()
    }
    .onDisappear {
      cameraManager.stopSession()
      showProgress = false
    }
    .alert("스캔 실패", isPresented: $viewModel.isDataFormatError) {
      Button("확인", role: .cancel) {
        showProgress = false
      }
    } message: {
      Text("인바디 정보를 인식하지 못했어요.\n다시 시도하거나 직접 입력해주세요.")
    }
    .toolbar(.hidden)
    .onChange(of: viewModel.isInbodyDataReady) { _, newValue in
      if newValue {
        isNext = true
        showProgress = false
      }
    }
    .navigationDestination(isPresented: $isNext) {
      OnboardingMainView(viewModel: viewModel)
    }
    .overlay(
      Group {
        if showProgress {
          Color.black.opacity(0.4) // 배경을 살짝 어둡게
            .ignoresSafeArea()
          ProgressView("인바디 정보를 인식 중입니다...") // 로딩 텍스트 추가
            .progressViewStyle(CircularProgressViewStyle(tint: .white)) // 로딩 인디케이터 색상
            .font(.pretendard(type: .medium, size: 16))
            .foregroundStyle(.white)
        }
      }
    )
    .allowsHitTesting(!showProgress)
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
          showProgress = true
          viewModel.captureImage()
        } label: {
          Image(systemName: Icon.camera.name)
            .imageScale(.large)
            .fontWeight(.semibold)
            .foregroundStyle(.subBackground)
            .padding()
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
