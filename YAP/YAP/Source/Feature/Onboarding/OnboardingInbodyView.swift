//
//  OnboardingInbodyView.swift
//  YAP
//
//  Created by 여성일 on 6/2/25.
//

import SwiftUI

struct OnboardingInbodyView: View {
  @Environment(\.dismiss) private var dismiss
  @Binding var currentIndex: Int
  
  @State var selectedInfoType: InbodyInfoType? = nil
  
  @Binding var infoItems: [InbodyInfoItem]
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      VStack(alignment: .leading, spacing: Spacing.extrLarge) {
        titleView
        infoView
      }
    }
    .navigationBarBackButtonHidden()
    .sheet(item: $selectedInfoType) { infoType in
      if let index = infoItems.firstIndex(where: { $0.type == infoType }) {
        if infoType == .age {
          InputAgeSheet(infoItem: $infoItems[index])
            .presentationDetents([.height(200)])
        } else {
          InbodyInputSheet(
            infoItem: $infoItems[index],
            minimumValue: infoType.minValue,
            maximumValue: infoType.maxValue,
            text: infoType
              .text(
                value: infoItems[index].value
              )
          )
          .presentationDetents([.height(200)])
        }
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
  
  private var infoView: some View {
    VStack(alignment: .leading, spacing: Spacing.large) {
      ForEach($infoItems) { $item in
        HStack {
          Text(item.type.rawValue)
            .font(.pretendard(type: .semibold, size: 16))
          
          Spacer()
          
          InbodyInfoButton(
            value: formattedValue(for: item),
            unit: item.unit
          ) {
            if item.type != .leanBodyMass {
              selectedInfoType = item.type
            }
          }
        }
      }
    }
  }
}

private extension OnboardingInbodyView {
  func nextButtonTapped() {
    currentIndex += 1
  }
  
  func beforeButtonTapped() {
    dismiss()
  }
  
  func formattedValue(for item: InbodyInfoItem) -> String {
    switch item.type {
    case .age, .basalMetabolicRate:
      return "\(Int(item.value))"
    case .leanBodyMass:
      if let weightItem = infoItems.first(where: { $0.type == .weight }),
         let fatPctItem = infoItems.first(where: { $0.type == .bodyFatPercentage }) {
        let lbm = calculateLeanBodyMass(
          weight: weightItem.value,
          bodyFatPercentage: fatPctItem.value
        )
        return String(format: "%.1f", lbm)
      } else {
        return "-"
      }
    default:
      return String(format: "%.1f", item.value)
    }
  }
  
  func calculateLeanBodyMass(weight: Double, bodyFatPercentage: Double) -> Double {
    return weight * (1 - (bodyFatPercentage / 100))
  }
}

#Preview {
  OnboardingInbodyView(currentIndex: .constant(0), infoItems: .constant([]))
}
