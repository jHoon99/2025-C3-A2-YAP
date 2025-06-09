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
  let onSave: (AdjustmentChoice) -> Void
  
  let remainingMealsCount: Int // 남은 끼니 수
  let baseCaloriesPerMeal: Int // 끼니당 기본 칼로리
  
  private var adjustmentPerMeal: Int { // 남은 끼니수에 비례해 배분
    guard remainingMealsCount > 0 else { return 0 }
    return adjustmentAmount / remainingMealsCount
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: Spacing.large) {
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
        .padding(.top, Spacing.medium)
      }
      .padding(.leading, Spacing.large)
//      .padding(.top, Spacing.large)
      
      // MARK: - 케이스에 따른 옵션 선택
      VStack(spacing: Spacing.extrLarge) {
        if type == .overLimit {
          ExerciseView(duration: "30분")
          DietView(
            remainingMealCount: remainingMealsCount,
            baseCaloriePerMeal: baseCaloriesPerMeal,
            adjustmentPerMeal: adjustmentPerMeal,
            isCalorieReduction: true // 칼로리 감소
          )
          Spacer()
          HStack {
            CtaButton(buttonName: .burn, titleColor: .main, bgColor: .lightHover) {
              // 그 뭐냐,, 메인 알림으로 데이터 날라가야하죠?
              print("운동하기 선택")
              onSave(.exerciseControl)
              isPresented = false
            }
            CtaButton(buttonName: .controlMeal, titleColor: .white, bgColor: .main) {
              // 그 뭐냐,, 메인 알림으로 데이터 날라가야하죠?
              print("식단하기 선택")
              onSave(.dietControl)
              isPresented = false
            }
          }
        } else {
          // MARK: 칼로리 미달 시 ForEach로 남은 끼니수 대로 뿌려주면..
          DietView(
            remainingMealCount: remainingMealsCount,
            baseCaloriePerMeal: baseCaloriesPerMeal,
            adjustmentPerMeal: adjustmentPerMeal,
            isCalorieReduction: false // 칼로리 증가
          )
          Spacer()
          CtaButton(buttonName: .controlMeal, titleColor: .white, bgColor: .main) {
            // 여긴 전체 칼로리 조정 들어가야겠죠?
            print("식단하기 선택")
            onSave(.dietControl)
            isPresented = false
          }
        }
      }
      .padding()
    }
    .padding(.top, Spacing.large)
  }
}

//#Preview {
//  CalorieAdjustmentView(isPresented: .constant(true), type: .overLimit, adjustmentAmount: 300, onSave: {}
//  )
//}
