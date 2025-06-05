//
//  ExerciseView.swift
//  YAP
//
//  Created by 조재훈 on 6/5/25.
//

import SwiftUI

struct ExerciseView: View {
  
  let title: String
  let exerciseName: String
  let duration: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: Spacing.large) {
      Text(title)
        .overlay(Rectangle()
          .frame(height: 3)
          .foregroundColor(.main)
          .offset(y: 16))
      HStack {
        Image(systemName: exerciseName)
          .frame(width: 48, height: 48)
        VStack(alignment: .leading, spacing: Spacing.small) {
          Text(exerciseName)
            .font(.pretendard(type: .medium, size: 16))
          Text(duration)
            .font(.pretendard(type: .semibold, size: 16))
        }
        Spacer()
      }
      .padding(.leading, Spacing.large)
    }
    .padding(.leading, Spacing.large)
    .padding(.top, Spacing.medium)
    Divider()
    
    VStack(alignment: .leading, spacing: Spacing.large) {
      HStack {
        Image(systemName: exerciseName)
          .frame(width: 48, height: 48)
        VStack(alignment: .leading, spacing: Spacing.small) {
          Text(exerciseName)
            .font(.pretendard(type: .medium, size: 16))
          Text(duration)
            .font(.pretendard(type: .semibold, size: 16))
        }
        Spacer()
      }
      .padding(.leading, Spacing.large)
    }
    .padding(.leading, Spacing.large)
    .padding(.top, Spacing.small)
  }
}

#Preview {
  ExerciseView(title: "운동하기", exerciseName: "런닝", duration: "30분")
}
