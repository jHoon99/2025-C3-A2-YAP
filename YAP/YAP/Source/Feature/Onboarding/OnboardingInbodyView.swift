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
            viewModel.item.inbodyInfoItem.leanBodyMass = calculateLeanBodyMass(
              weight: viewModel.item.inbodyInfoItem.weight,
              bodyFatPercentage: viewModel.item.inbodyInfoItem.bodyFatPercentage
            )
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
            viewModel.item.inbodyInfoItem.leanBodyMass = calculateLeanBodyMass(
              weight: viewModel.item.inbodyInfoItem.weight,
              bodyFatPercentage: viewModel.item.inbodyInfoItem.bodyFatPercentage
            )
          }
          
          InbodySetRowView(
            type: .bodyFatPercentage,
            value: viewModel.item.inbodyInfoItem.bodyFatPercentage,
            unit: .kg
          ) {
            selectedInfoType = .bodyFatPercentage
            viewModel.item.inbodyInfoItem.leanBodyMass = calculateLeanBodyMass(
              weight: viewModel.item.inbodyInfoItem.weight,
              bodyFatPercentage: viewModel.item.inbodyInfoItem.bodyFatPercentage
            )
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
      inbodySheetView(for: infoType)
        .presentationDetents([.height(200)])
    }
    .onChange(of: viewModel.item.inbodyInfoItem.weight) { _ in
      updateLeanBodyMass()
    }
    .onChange(of: viewModel.item.inbodyInfoItem.bodyFatPercentage) { _ in
      updateLeanBodyMass()
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
      .disabled(!viewModel.isInbodyInfoValid())
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
  
  func updateLeanBodyMass() {
    viewModel.item.inbodyInfoItem.leanBodyMass = calculateLeanBodyMass(
      weight: viewModel.item.inbodyInfoItem.weight,
      bodyFatPercentage: viewModel.item.inbodyInfoItem.bodyFatPercentage
    )
  }
  
  @ViewBuilder
  func inbodySheetView(for type: InbodyInfoType) -> some View {
    switch type {
    case .age:
      InputAgeSheet(value: $viewModel.item.inbodyInfoItem.age)
      
    case .height:
      InbodyInputSheet(
        value: $viewModel.item.inbodyInfoItem.height,
        type: type
      )
      
    case .weight:
      InbodyInputSheet(
        value: $viewModel.item.inbodyInfoItem.weight,
        type: type
      )
      
    case .basalMetabolicRate:
      InbodyInputSheet(
        value: $viewModel.item.inbodyInfoItem.basalMetabolicRate,
        type: type
      )
      
    case .skeletalMuscleMass:
      InbodyInputSheet(
        value: $viewModel.item.inbodyInfoItem.skeletalMuscleMass,
        type: type
      )
      
    case .bodyFatMass:
      InbodyInputSheet(
        value: $viewModel.item.inbodyInfoItem.bodyFatMass,
        type: type
      )
      
    case .bodyFatPercentage:
      InbodyInputSheet(
        value: $viewModel.item.inbodyInfoItem.bodyFatPercentage,
        type: type
      )
      
    case .leanBodyMass:
      InbodyInputSheet(
        value: $viewModel.item.inbodyInfoItem.leanBodyMass,
        type: type
      )
    }
  }
}

//
//#Preview {
//  OnboardingInbodyView(currentIndex: .constant(0), infoItems: .constant([]))
//}
