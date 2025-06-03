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
      HStack {
        VStack(alignment: .leading, spacing: 12) {
          Text("몸무게")
          HStack(spacing: 4) {
            Text("\(Int(inbody.weight))")
            Text("kg")
          }
        }
        
        Spacer()
        
        VStack(alignment: .leading, spacing: 12) {
          Text("체지방량")
          HStack(spacing: 4) {
            Text("\(Int(inbody.skeletalMuscleMass))")
            Text("kg")
          }
        }
        
        Spacer()
        
        VStack(alignment: .leading, spacing: 12) {
          Text("골격근량")
          HStack(spacing: 4) {
            Text("\(Int(inbody.bodyFatMass))")
            Text("kg")
          }
        }
        
        Spacer()
        
        VStack(alignment: .leading, spacing: 12) {
          Text("기초대사량")
          HStack(spacing: 4) {
            Text("\(inbody.basalMetabolicRate)")
            Text("kcal")
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
