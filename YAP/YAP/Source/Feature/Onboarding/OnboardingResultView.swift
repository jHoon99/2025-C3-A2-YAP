//
//  OnboardingResultView.swift
//  YAP
//
//  Created by 여성일 on 6/3/25.
//

import SwiftData
import SwiftUI

struct OnboardingResultView: View {
  @Binding var onboardingItem: OnboardingItem
  
  @State private var isNext: Bool = false
  @Environment(\.modelContext) private var modelContext: ModelContext
  @Query private var inbodyData: [Inbody]
  @Query private var calorieData: [CalorieRequirements]
  @Query private var activityInfo: [ActivityInfo]
  
  private var macros: (carb: Int, protein: Int, fat: Int) {
    let leanMass = onboardingItem.inbody.first(where: { $0.type == .leanBodyMass })?.value ?? 0.0
    let proteinGrams = leanMass * 2.1
    let proteinCalories = proteinGrams * 4
    
    let remainingCalories = Double(onboardingItem.goalCalories) - proteinCalories
    let carbCalories = remainingCalories * 0.6
    let fatCalories = remainingCalories * 0.4
    
    let carbGrams = carbCalories / 4
    let fatGrams = fatCalories / 9
    
    return (
      carb: Int(carbGrams.rounded()),
      protein: Int(proteinGrams.rounded()),
      fat: Int(fatGrams.rounded())
    )
  }
  
  private var macrosRow: [MacroType: Int] {
    [
      .carbohydrate: macros.carb,
      .protein: macros.protein,
      .fat: macros.fat
    ]
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.clear.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: Spacing.extrLarge) {
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
      inbodyData.forEach {
        print($0)
      }
      
      calorieData.forEach {
        print($0)
      }
    }
    .padding(.horizontal, Spacing.medium)
    .padding(.vertical, Spacing.extrLarge)
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
        
        Text("\(onboardingItem.goalCalories )")
          .font(.pretendard(type: .bold, size: 28))
          .foregroundStyle(.main)
        
        Text("kcal예요.")
          .font(.pretendard(type: .semibold, size: 20))
          .foregroundStyle(.text)
        Spacer()
      }
      
      HStack {
        ForEach(MacroType.allCases) { type in
          MacroView(title: type.title, value: macrosRow[type] ?? 0)
          
          if type != MacroType.allCases.last {
            Spacer()
          }
        }
      }
      .padding(.horizontal, Spacing.extrLarge)
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
    if let age = onboardingItem.inbody.first(where: { $0.type == .age })?.intValue,
       let height = onboardingItem.inbody.first(where: { $0.type == .height })?.value,
       let weight = onboardingItem.inbody.first(where: { $0.type == .weight })?.value,
       let bfm = onboardingItem.inbody.first(where: { $0.type == .bodyFatMass })?.value,
       let bmr = onboardingItem.inbody.first(where: { $0.type == .basalMetabolicRate })?.value,
       let smm = onboardingItem.inbody.first(where: { $0.type == .skeletalMuscleMass })?.value,
       let lbm = onboardingItem.inbody.first(where: { $0.type == .leanBodyMass })?.value,
       let bfp = onboardingItem.inbody.first(where: { $0.type == .bodyFatPercentage })?.value {
      
      let inbody = Inbody(
        date: Date(),
        weight: weight,
        height: height,
        age: Int(age),
        bodyFatMass: bfm,
        basalMetabolicRate: Int(bmr),
        skeletalMuscleMass: smm,
        leanBodyMass: lbm,
        bodyFatPercentage: bfp
      )
      
      modelContext.insert(inbody)
    }
    
    if let activityLevel = onboardingItem.activityInfo.activityLevel,
       let goalType = onboardingItem.activityInfo.goalType,
       let mealCount = onboardingItem.activityInfo.mealCount {
      
      let activityInfo = ActivityInfo(activityLevel: activityLevel, goalType: goalType, mealCount: mealCount)
      
      modelContext.insert(activityInfo)
    }
  
    let calorie = CalorieRequirements(
      carbohydrates: Double(macros.carb),
      protein: Double(macros.protein),
      lipid: Double(macros.fat),
      calorie: onboardingItem.goalCalories
    )
    
    modelContext.insert(calorie)
  }
}

#Preview {
  OnboardingResultView(onboardingItem: .constant(.initItem))
}
