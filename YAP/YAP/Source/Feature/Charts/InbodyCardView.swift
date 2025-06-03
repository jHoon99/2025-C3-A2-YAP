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
        VStack(alignment: .leading, spacing: 12) {
          Text("몸무게")
            .font(.pretendard(type: .regular, size: 14))
            .foregroundStyle(.subText)
          HStack(spacing: 4) {
            Text("\(Int(inbody.weight))")
              .font(.pretendard(type: .regular, size: 20))
            Text("kg")
              .font(.pretendard(type: .regular, size: 14))
          }
        }
        
        Spacer()
        
        VStack(alignment: .leading, spacing: 12) {
          Text("체지방량")
            .font(.pretendard(type: .regular, size: 14))
            .foregroundStyle(.subText)
          HStack(spacing: 4) {
            Text("\(Int(inbody.skeletalMuscleMass))")
              .font(.pretendard(type: .regular, size: 20))
            Text("kg")
              .font(.pretendard(type: .regular, size: 14))
          }
        }
        
        Spacer()
        
        VStack(alignment: .leading, spacing: 12) {
          Text("골격근량")
            .font(.pretendard(type: .regular, size: 14))
            .foregroundStyle(.subText)
          HStack(spacing: 4) {
            Text("\(Int(inbody.bodyFatMass))")
              .font(.pretendard(type: .regular, size: 20))
            Text("kg")
              .font(.pretendard(type: .regular, size: 14))
          }
        }
        
        Spacer()
        
        VStack(alignment: .leading, spacing: 12) {
          Text("기초대사량")
            .font(.pretendard(type: .regular, size: 14))
            .foregroundStyle(.subText)
          HStack(spacing: 4) {
            Text("\(inbody.basalMetabolicRate)")
              .font(.pretendard(type: .regular, size: 20))
            Text("kcal")
              .font(.pretendard(type: .regular, size: 14))
          }
        }
      }
    }
    .padding(.vertical, 16)
    .padding(.horizontal, 20)
  }
}

#Preview {
  InbodyCardView(inbody: Inbody.sampleData[0])
}
