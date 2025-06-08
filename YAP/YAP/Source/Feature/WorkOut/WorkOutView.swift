//
//  WorkOutView.swift
//  YAP
//
//  Created by 여성일 on 6/6/25.
//

import SwiftUI

struct WorkOutView: View {
  @Environment(\.dismiss) private var dismiss
  let cardioWorkouts = WorkOutType.allCases.filter { $0.category == .cardio }
  let weightWorkouts = WorkOutType.allCases.filter { $0.category == .weight }
  let calorieToBurn: Int
}

extension WorkOutView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.clear.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: Spacing.large) {
        titleView
        WorkoutSectionView(title: "유산소", workouts: cardioWorkouts, calorieToBurn: calorieToBurn)
        WorkoutSectionView(title: "웨이트", workouts: weightWorkouts, calorieToBurn: calorieToBurn)
      }
    }
    .padding(.horizontal, Spacing.medium)
    .padding(.top, Spacing.small)
    .navigationBarBackButtonHidden()
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          dismiss()
        } label: {
          Image(systemName: Icon.chevronLeft.name)
            .foregroundStyle(.text)
        }
      }
    }
  }
}

private extension WorkOutView {
  var titleView: some View {
    VStack(alignment: .leading, spacing: Spacing.small) {
      Text("오늘 태워야 할 칼로리는")
        .font(.pretendard(type: .bold, size: 28))
      
      Label {
        Text("\(calorieToBurn)kcal")
          .foregroundStyle(.main)
          .font(.pretendard(type: .bold, size: 28))
      } icon: {
        Image(.burn)
          .resizable()
          .renderingMode(.template)
          .foregroundStyle(.main)
          .frame(width: 25, height: 30)
      }
    }
  }
}

private struct WorkoutSectionView: View {
  let title: String
  let workouts: [WorkOutType]
  let calorieToBurn: Int
  
  var body: some View {
    VStack(alignment: .leading, spacing: Spacing.small) {
      VStack(spacing: 4) {
        Text(title)
          .font(.pretendard(type: .bold, size: 16))
        Rectangle()
          .frame(width: 50, height: 3)
          .foregroundStyle(.main)
      }
      
      VStack(alignment: .leading) {
        ForEach(workouts, id: \.self) { type in
          WorkOutRowView(
            image: type.imageAsset,
            title: type.rawValue,
            amount: type.calculateAmout(ofCalorie: calorieToBurn)
          )
          
          if type != workouts.last {
            Divider()
              .frame(height: 1)
              .background(.darker)
          }
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    WorkOutView(calorieToBurn: 300)
  }
}
