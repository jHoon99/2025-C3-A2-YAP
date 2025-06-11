//
//  OnboardingInbodyView.swift
//  YAP
//
//  Created by 여성일 on 6/2/25.
//

import SwiftUI

struct OnboardingInbodyView: View {
  @ObservedObject var viewModel: OnboardingViewModel
  
  @Environment(\.dismiss) private var dismiss
  @State var selectedInfoType: InbodyInfoType? = nil
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      VStack(alignment: .leading, spacing: Spacing.extraLarge) {
        titleView
        
        VStack(spacing: Spacing.medium) {
          InbodySetRowView(
            type: .age,
            value: Double(viewModel.item.inbodyInfoItem.age),
            unit: .age
          ) {
            selectedInfoType = .age
          }
          
          InbodySetRowView(
            type: .height,
            value: viewModel.item.inbodyInfoItem.height,
            unit: .cm
          ) {
            selectedInfoType = .height
          }
          
          InbodySetRowView(
            type: .weight,
            value: viewModel.item.inbodyInfoItem.weight,
            unit: .kg
          ) {
            selectedInfoType = .weight
          }
          
          InbodySetRowView(
            type: .basalMetabolicRate,
            value: viewModel.item.inbodyInfoItem.basalMetabolicRate,
            unit: .kcal
          ) {
            selectedInfoType = .basalMetabolicRate
          }
          
          InbodySetRowView(
            type: .skeletalMuscleMass,
            value: viewModel.item.inbodyInfoItem.skeletalMuscleMass,
            unit: .kg
          ) {
            selectedInfoType = .skeletalMuscleMass
          }
          
          InbodySetRowView(
            type: .bodyFatMass,
            value: viewModel.item.inbodyInfoItem.bodyFatMass,
            unit: .kg
          ) {
            selectedInfoType = .bodyFatMass
          }
          
          InbodySetRowView(
            type: .bodyFatPercentage,
            value: viewModel.item.inbodyInfoItem.bodyFatPercentage,
            unit: .kg
          ) {
            selectedInfoType = .bodyFatPercentage
          }
          
          InbodySetRowView(
            type: .leanBodyMass,
            value: viewModel.item.inbodyInfoItem.leanBodyMass,
            unit: .kg
          ) {
            selectedInfoType = .leanBodyMass
          }
        }
        
        Spacer()
        
        bottomButtonView
      }
    }
    .navigationBarBackButtonHidden()
    .sheet(item: $selectedInfoType) { infoType in
      if infoType == .age {
        InputAgeSheet(infoItem: $viewModel.item.inbodyInfoItem)
          .presentationDetents([.height(200)])
      } else {
        
      }
    }
  }
  
  private var titleView: some View {
    VStack(alignment: .leading, spacing: Spacing.small) {
      Text("인바디 정보가 정확한가요?")
        .font(.pretendard(type: .semibold, size: 28))
        .foregroundStyle(.text)
      
      Text("다시 인식하거나 직접 수정할 수 있어요.")
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
        dismiss()
      }
      
      Spacer()
      
      CtaButton(
        buttonName: .next,
        titleColor: .white,
        bgColor: .main
      ) {
        nextButtonTapped()
      }
    }
  }
}

private extension OnboardingInbodyView {
  func nextButtonTapped() {
    viewModel.currentIndex += 1
  }
  
  func beforeButtonTapped() {
    dismiss()
  }
  
  func calculateLeanBodyMass(weight: Double, bodyFatPercentage: Double) -> Double {
    return weight * (1 - (bodyFatPercentage / 100))
  }
}

//
//#Preview {
//  OnboardingInbodyView(currentIndex: .constant(0), infoItems: .constant([]))
//}
