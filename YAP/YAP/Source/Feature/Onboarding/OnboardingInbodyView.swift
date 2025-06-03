//
//  OnboardingInbodyView.swift
//  YAP
//
//  Created by 여성일 on 6/2/25.
//

import SwiftUI

struct InfoItem: Identifiable {
  let id = UUID()
  let title: String
  let value: String
  let unit: UnitType
}

struct OnboardingInbodyView: View {
  @Environment(\.dismiss) private var dismiss
  @Binding var currentIndex: Int
  
  let infoItems: [InfoItem] = [
    InfoItem(title: "나이", value: "27", unit: .age),
    InfoItem(title: "키", value: "177", unit: .cm),
    InfoItem(title: "체중", value: "70", unit: .kg),
    InfoItem(title: "근육량", value: "30", unit: .kg),
    InfoItem(title: "체지방률", value: "15", unit: .kg)
  ]
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      VStack(alignment: .leading, spacing: Spacing.extrLarge) {
        titleView
        
        infoView
      }
    }
    .navigationBarBackButtonHidden()
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
    VStack(alignment: .leading, spacing: Spacing.extrLarge) {
      ForEach(infoItems) { item in
        HStack {
          Text(item.title)
            .font(.pretendard(type: .semibold, size: 16))
          
          Spacer()
          
          InbodyInfoButton(value: item.value, unit: item.unit) { }
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
}
#Preview {
  OnboardingInbodyView(currentIndex: .constant(0))
}
