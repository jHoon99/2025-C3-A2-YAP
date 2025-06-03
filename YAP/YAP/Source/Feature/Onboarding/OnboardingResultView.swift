//
//  OnboardingResultView.swift
//  YAP
//
//  Created by 여성일 on 6/3/25.
//

import SwiftUI

struct OnboardingResultView: View {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.clear.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: Spacing.extrLarge) {
        titleView
        
        Spacer()
        
        celebrateImageView
        
        calorieInfoView
        
        Spacer()
        
        CtaButton(
          buttonName: .start,
          titleColor: .white,
          bgColor: .main
        ) { }
      }
    }
    .padding(.horizontal, Spacing.medium)
    .padding(.vertical, Spacing.extrLarge)
    .navigationBarBackButtonHidden()
  }
  
  private var titleView: some View {
    VStack(alignment: .leading, spacing: Spacing.small) {
      Text("요구 칼로리 계산이\n완료 됐어요!")
        .font(.pretendard(type: .semibold, size: 28))
        .foregroundStyle(.text)
      
      Text("당신의 목표와 라이프스타일에\n딱 맞춘 하루 권장 섭취 칼로리를 알려드릴게요.")
        .font(.pretendard(type: .semibold, size: 16))
        .foregroundStyle(.subText)
    }
  }
  
  private var celebrateImageView: some View {
    HStack {
      Spacer()
      
      Image("celebrate")
      
      Spacer()
    }
  }
  
  private var calorieInfoView: some View {
    VStack(spacing: Spacing.large) {
      HStack(alignment: .bottom) {
        Spacer()
        
        Text("요구 칼로리는")
          .font(.pretendard(type: .semibold, size: 20))
          .foregroundStyle(.text)
        
        Text("2100")
          .font(.pretendard(type: .bold, size: 28))
          .foregroundStyle(.main)
        
        Text("kcal예요.")
          .font(.pretendard(type: .semibold, size: 20))
          .foregroundStyle(.text)
        Spacer()
      }
      
      HStack {
        VStack(spacing: Spacing.small) {
          Text("탄수화물")
            .font(.pretendard(type: .semibold, size: 20))
            .foregroundStyle(.text)
          
          Text("60g")
            .font(.pretendard(type: .semibold, size: 16))
            .foregroundStyle(.subText)
        }
        
        Spacer()
        
        VStack(spacing: Spacing.small) {
          Text("단백질")
            .font(.pretendard(type: .semibold, size: 20))
            .foregroundStyle(.text)
          
          Text("60g")
            .font(.pretendard(type: .semibold, size: 16))
            .foregroundStyle(.subText)
        }
        
        Spacer()
        
        VStack(spacing: Spacing.small) {
          Text("지방")
            .font(.pretendard(type: .semibold, size: 20))
            .foregroundStyle(.text)
          
          Text("60g")
            .font(.pretendard(type: .semibold, size: 16))
            .foregroundStyle(.subText)
        }
      }
      .padding(.horizontal, Spacing.extrLarge)
    }
  }
}

#Preview {
  OnboardingResultView()
}
