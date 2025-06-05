//
//  CalorieSheetView.swift
//  YAP
//
//  Created by 조재훈 on 6/5/25.
//

import SwiftUI

struct CalorieAdjustmentView: View {
  
  @Binding var isPresented: Bool
  
  let type: AdjustmentType // 칼로치 초과 또는 미달 타입
  let adjustmentAmount: Int // 칼로리 차이
  
  // MARK: - 칼로리 계산을 위한 더미
  private let remainMeal = 2
  private var adjustMeal: Int { // 남은 끼니수에 비례해 배분
    guard remainMeal > 0 else { return 0 }
    return adjustmentAmount / remainMeal
  }
  
    var body: some View {
      VStack(alignment: .leading, spacing: Spacing.small) {
        Text("권장 섭취량 보다")
          .font(.pretendard(type: .bold, size: 24))
        HStack {
          Text("\(adjustmentAmount)kcal")
            .font(.pretendard(type: .bold, size: 24))
            .foregroundColor(.main)
          Text("\(type == .overLimit ? "넘었어요!" : "부족해요!")")
            .font(.pretendard(type: .bold, size: 24))
        }
        Text(type == .overLimit ?
        "식단을 줄이거나 다음 식단을 조절할 수 있어요!\n만약, 먹고싶다면 운동을 해서 칼로리를 태울 수 도 있어요!"
             : "다음 식단에서 칼로리를 보충해야 해요!")
        .font(.pretendard(type: .medium, size: 16))
        .foregroundColor(.subText)
      }
      .padding(Spacing.medium)
      
      // MARK: - 케이스에 따른 옵션 선택
      if type == .overLimit {
        ExerciseView(title: "운동하기", exerciseName: "figure.run", duration: "30분")
        DietView(title: "식단하기", mealTime: "두 번째 식사", originalCal: 700, adjustCal: 700 - adjustMeal)
      } else {
        // MARK: 칼로리 미달 시 ForEach로 남은 끼니수 대로 뿌려주면..
        DietView(title: "식단하기", mealTime: "두 번째 식사", originalCal: 700, adjustCal: 700 - adjustMeal)
      }
      Spacer()
      // MARK: - 하단버튼
      HStack(spacing: Spacing.medium) {
        if type == .overLimit {
          CtaButton(buttonName: .controlMeal, titleColor: .white, bgColor: .main) {
            // 그 뭐냐,, 메인 알림으로 데이터 날라가야하죠?
            isPresented = false
          }
          CtaButton(buttonName: .burn, titleColor: .white, bgColor: .main) {
            // 여긴 전체 칼로리 조정 들어가야겠죠?
            isPresented = false
          }
        }
      }
      .padding()
    }
}

#Preview {
  CalorieAdjustmentView(isPresented: .constant(true), type: .overLimit, adjustmentAmount: 200)
}
