//
//  OnboardingResultView.swift
//  YAP
//
//  Created by 여성일 on 6/3/25.
//

import SwiftData
import SwiftUI

struct OnboardingResultView: View {
  @ObservedObject var viewModel: OnboardingViewModel
  @State private var isNext: Bool = false
  
  @Environment(\.modelContext) private var modelContext: ModelContext
  @Query private var inbodyData: [Inbody]
  @Query private var calorieData: [CalorieRequirements]
  @Query private var activityInfo: [ActivityInfo]
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.clear.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: Spacing.extraLarge) {
        titleView
        
        Spacer()
        
        celebrateImageView
        calorieInfoView
        
        Spacer()
        
        CtaButton(
          buttonName: .start,
          titleColor: .white,
          bgColor: .main
        ) {
          save()
          isNext = true
        }
      }
    }
    .onAppear {
      print(viewModel.item)
    }
    .padding(.horizontal, Spacing.medium)
    .padding(.vertical, Spacing.extraLarge)
    .navigationBarBackButtonHidden()
    .navigationDestination(isPresented: $isNext) {
      MainUIView()
    }
  }
  
  private var titleView: some View {
    VStack(alignment: .leading, spacing: Spacing.small) {
      Text("요구 칼로리 계산이\n완료 됐어요!")
        .font(.pretendard(type: .semibold, size: 28))
        .foregroundStyle(.text)
      
      Text("당신의 목표와 라이프스타일에\n딱 맞춘 하루 권장 섭취 칼로리를 알려드릴게요.")
        .font(.pretendard(type: .semibold, size: 16))
        .foregroundStyle(.subText)
    }
  }
  
  private var celebrateImageView: some View {
    HStack {
      Spacer()
      
      Image(.celebrate)
        .resizable()
        .frame(width: 150, height: 180)
        .padding(.leading, 25)
      
      Spacer()
    }
  }
  
  private var calorieInfoView: some View {
    VStack(spacing: Spacing.large) {
      HStack(alignment: .bottom) {
        Spacer()
        
        Text("요구 칼로리는")
          .font(.pretendard(type: .semibold, size: 20))
          .foregroundStyle(.text)
        
        Text("\(viewModel.calorieRequirementsItem.calorie)")
          .font(.pretendard(type: .bold, size: 28))
          .foregroundStyle(.main)
        
        Text("kcal예요.")
          .font(.pretendard(type: .semibold, size: 20))
          .foregroundStyle(.text)
        Spacer()
      }
      
      HStack(spacing: 64) {
        MacroView(title: "탄수화물", value: viewModel.calorieRequirementsItem.carbohydrates)
        MacroView(title: "단백질", value: viewModel.calorieRequirementsItem.protein)
        MacroView(title: "지방", value: viewModel.calorieRequirementsItem.lipid)
      }
      .padding(.horizontal, Spacing.extraLarge)
    }
  }
}

private struct MacroView: View {
  let title: String
  let value: Int
  
  var body: some View {
    VStack(spacing: Spacing.small) {
      Text(title)
        .font(.pretendard(type: .semibold, size: 20))
        .foregroundStyle(.text)
      
      Text("\(value)g")
        .font(.pretendard(type: .semibold, size: 16))
        .foregroundStyle(.subText)
    }
  }
}

private extension OnboardingResultView {
  func save() {
    let inbody = Inbody(
      date: Date(),
      weight: viewModel.item.inbodyInfoItem.weight,
      height: viewModel.item.inbodyInfoItem.height,
      age: viewModel.item.inbodyInfoItem.age,
      bodyFatMass: viewModel.item.inbodyInfoItem.bodyFatMass,
      basalMetabolicRate: Int(viewModel.item.inbodyInfoItem.basalMetabolicRate),
      skeletalMuscleMass: viewModel.item.inbodyInfoItem.skeletalMuscleMass,
      leanBodyMass: viewModel.item.inbodyInfoItem.leanBodyMass,
      bodyFatPercentage: viewModel.item.inbodyInfoItem.bodyFatPercentage
    )
    
    modelContext.insert(inbody)
    
    let calorie = CalorieRequirements(
      carbohydrates: Double(viewModel.calorieRequirementsItem.carbohydrates),
      protein: Double(viewModel.calorieRequirementsItem.protein),
      lipid: Double(viewModel.calorieRequirementsItem.lipid),
      calorie: viewModel.calorieRequirementsItem.calorie
    )
    
    modelContext.insert(calorie)
    
    let mealCount = viewModel.item.activityInfoItem.mealCount ?? 3
    
    let caloriePerMeal = mealCount > 0 ? (viewModel.calorieRequirementsItem.calorie / mealCount) : 0
    let carbohydratesPerMeal = mealCount > 0 ? (Double(viewModel.calorieRequirementsItem.carbohydrates) / Double(mealCount)) : 0.0
    let proteinPerMeal = mealCount > 0 ? (Double(viewModel.calorieRequirementsItem.protein) / Double(mealCount)) : 0.0
    let fatPerMeal = mealCount > 0 ? (Double(viewModel.calorieRequirementsItem.lipid) / Double(mealCount)) : 0.0
    
    // 끼니 수 만큼 빈 Meal 객체 생성 (끼니 당 목표만 설정, 실제 섭취량은 0인 상태)
    for index in 0..<mealCount {
      let meal = Meal(
        day: Date(),
        carbohydrates: 0,
        protein: 0,
        lipid: 0,
        kcal: 0,
        menus: [],
        mealIndex: index,
        targetKcal: caloriePerMeal,
        targetCarbs: carbohydratesPerMeal,
        targetProtein: proteinPerMeal,
        targetFat: fatPerMeal
      )
      modelContext.insert(meal)
    }
  }
}
