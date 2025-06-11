//
//  ExerciseView.swift
//  YAP
//
//  Created by 조재훈 on 6/5/25.
//

import SwiftUI

struct ExerciseView: View {
  
  let duration: String
  let imageName: String
  let title: String
  
  var body: some View {
    HStack(spacing: Spacing.large) {
      Image(imageName)
        .resizable()
        .frame(width: 48, height: 48)
      VStack(alignment: .leading, spacing: Spacing.small) {
        Text(title)
          .font(.pretendard(type: .medium, size: 16))
        Text(duration)
          .font(.pretendard(type: .semibold, size: 16))
          .foregroundColor(.main)
      }
      Spacer()
    }
    Divider()
  }
}

#Preview {
  ExerciseView(duration: "30분", imageName: "running", title: "런닝")
}
