//
//  CartView.swift
//  YAP
//
//  Created by 조재훈 on 6/4/25.
//

import SwiftUI

struct CartView: View {
  
  @EnvironmentObject var cartManager: CartManager
  
  var body: some View {
    List {
      // MARK: - 헤더 섹션
      Section {
        VStack {
          HStack {
            Text("총 열량")
              .font(.pretendard(type: .bold, size: 20))
            
            Spacer()
            
            Text("\(cartManager.totalNutrition.calories) kcal")
          }
//          .padding(Spacing.large)
          
          HStack(spacing: 48) {
            NutritionCircle(
              title: "탄수화물",
              current: cartManager.totalNutrition.carbs,
              goal: cartManager.dailyGoals.carbohydrate,
              progress: cartManager.achievementRate.carbs
            )
            NutritionCircle(
              title: "단백질",
              current: cartManager.totalNutrition.protein,
              goal: cartManager.dailyGoals.protein,
              progress: cartManager.achievementRate.protein
            )
            NutritionCircle(
              title: "지방",
              current: cartManager.totalNutrition.fat,
              goal: cartManager.dailyGoals.fat,
              progress: cartManager.achievementRate.fat
            )
          }
          .padding(.top, Spacing.large)
//          .padding(.bottom, Spacing.large)
        }
      }
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
      .listRowBackground(Color.clear)
      
      // MARK: - 메뉴 헤더 섹션
      Section {
        // 메뉴 리스트 ...
        HStack {
          Text("메뉴")
            .font(.pretendard(type: .bold, size: 20))
          Text("\(cartManager.cartItems.count)")
            .font(.pretendard(type: .bold, size: 20))
            .foregroundColor(.main)
          Spacer()
        }
//        .padding(Spacing.large)
      }
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
      .listRowBackground(Color.clear)
      
      // MARK: - 메뉴 아이템들
      if cartManager.cartItems.isEmpty {
        Section {
          VStack {
            Text("추가된 음식이 없습니다.")
              .foregroundColor(.gray)
              .padding()
              .frame(maxWidth: .infinity)
              .padding(.vertical, 40)
          }
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
      } else {
        ForEach(Array(cartManager.cartItems.enumerated()), id: \.element.id) { index, item in
          Section {
            CartItemRow(item: item)
          }
          .listRowSeparator(.hidden)
          .listRowInsets(EdgeInsets())
          .listRowBackground(Color.clear)
          .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
              withAnimation(.easeInOut(duration: 0.3)) {
                cartManager.removeFood(at: index)
              }
            } label: {
              Label("삭제", systemImage: "trash")
            }
          }
        }
      }
      // MARK: - 하단 설명 및 버튼 섹션
      Section {
        VStack {
          Text(
            "식품의 영양성분정보는 수확물의 품종, 발육, 생장환경 등에 따라 달라질 수 있으며, "
            + "조리법에 따라 달라질 수 있습니다. \n계산된 칼로리 및 성분 정보는 평균적인 수치로 참고용으로 "
            + "사용해야하며, 일부 정보에 오류가 있거나 누락이 있을 수 있습니다."
          )
          .font(.pretendard(type: .medium, size: 14))
          .foregroundColor(.subText)
          .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .background(Color.subBackground)
        
        Spacer()
        
        CtaButton(buttonName: .eat, titleColor: .white, bgColor: .main) {
          print("dd")
        }
        .padding()
      }
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
      .listRowBackground(Color.clear)
    }
  }
}

#Preview {
  CartView()
    .environmentObject(CartManager())
}
