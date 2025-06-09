//
//  ExerciseView.swift
//  YAP
//
//  Created by 조재훈 on 6/5/25.
//

import SwiftUI

struct ExerciseView: View {
  
  let duration: String
  
  var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: Spacing.large) {
        Text("운동하기")
          .overlay(Rectangle()
            .frame(height: 3)
            .foregroundColor(.main)
            .offset(y: 16))
          .padding(.bottom, Spacing.medium)
        HStack(spacing: Spacing.large) {
          Image("running")
            .resizable()
            .frame(width: 48, height: 48)
          VStack(alignment: .leading, spacing: Spacing.small) {
            Text("런닝")
              .font(.pretendard(type: .medium, size: 16))
            Text(duration)
              .font(.pretendard(type: .semibold, size: 16))
          }
          Spacer()
        }
        .padding(.leading, Spacing.large)
      }
      Divider()
      
      VStack(alignment: .leading, spacing: Spacing.large) {
        HStack(spacing: Spacing.large) {
          Image("stepmill")
            .resizable()
            .frame(width: 48, height: 48)
          VStack(alignment: .leading, spacing: Spacing.small) {
            Text("천국의 계단")
              .font(.pretendard(type: .medium, size: 16))
            Text(duration)
              .font(.pretendard(type: .semibold, size: 16))
          }
          Spacer()
        }
        .padding(.leading, Spacing.large)
      }
    }
    .padding(.leading, Spacing.small)
//    .padding(.top, Spacing.small)
//    .padding(.bottom, Spacing.large)
  }
}

#Preview {
  ExerciseView(duration: "30분")
}
