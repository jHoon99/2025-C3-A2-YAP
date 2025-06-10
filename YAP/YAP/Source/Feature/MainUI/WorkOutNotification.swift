//
//  WorkOutNotification.swift
//  YAP
//
//  Created by oliver on 6/9/25.
//

import SwiftUI

struct WorkOutNotification: View {
  let calroieToBurn: Int
  
    var body: some View {
      NavigationLink(destination: WorkOutView(calorieToBurn: calroieToBurn)) {
        WorkoutNotificationLabel()
      }
    }
}

struct WorkoutNotificationLabel: View {
  var body: some View {
    HStack(spacing: 4) {
      Image(.alertIcon)
      Text("오늘 해야 할 운동 알아보기")
        .font(.pretendard(type: .bold, size: 16))
        .foregroundStyle(.main)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.leading, 16)
    .padding(.vertical, 20)
    .background(.white)
    .cornerRadius(12)
  }
}

#Preview {
  WorkOutNotification(calroieToBurn: 300)
}
