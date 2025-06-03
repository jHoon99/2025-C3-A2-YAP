//
//  InbodyCardView.swift
//  YAP
//
//  Created by oliver on 6/3/25.
//

import SwiftUI

struct InbodyCardView: View {
  var inbody: Inbody
  
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text(inbody.date.formattedYMD)
        .font(.pretendard(type: .medium, size: 14))
        .foregroundStyle(.darkHover)
      
      HStack {
        InbodyItemView(name: "몸무게", value: "\(Int(inbody.weight))", unit: "kg")
        Spacer()
        InbodyItemView(name: "체지방량", value: "\(Int(inbody.bodyFatMass))", unit: "kg")
        Spacer()
        InbodyItemView(name: "골격근량", value: "\(Int(inbody.skeletalMuscleMass))", unit: "kg")
        Spacer()
        InbodyItemView(name: "기초대사량", value: "\(inbody.basalMetabolicRate)", unit: "kcal")
      }
    }
    .padding(.vertical, 16)
    .padding(.horizontal, 20)
  }
}

struct InbodyItemView: View {
  let name: String
  let value: String
  let unit: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(name)
        .font(.pretendard(type: .regular, size: 14))
        .foregroundStyle(.subText)
      HStack(spacing: 4) {
        Text(value)
          .font(.pretendard(type: .regular, size: 20))
        Text(unit)
          .font(.pretendard(type: .regular, size: 14))
      }
    }
  }
}

#Preview {
  InbodyCardView(inbody: Inbody.sampleData[0])
}
