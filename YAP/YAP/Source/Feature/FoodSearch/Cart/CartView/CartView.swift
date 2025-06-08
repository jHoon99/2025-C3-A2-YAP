//
//  CartView.swift
//  YAP
//
//  Created by 조재훈 on 6/4/25.
//

import SwiftData
import SwiftUI

struct CartView: View {
  
  @StateObject private var dataManager = CartDataManager()
  @EnvironmentObject var cartManager: CartManager
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  
  @State private var isSaving = false
  @State private var showSaveAlert = false
  @State private var saveMessage = ""
  
  //  @State private var showCalorieSheet = false
  //  @State private var calorieAdjustmentType: AdjustmentType?
  //  @State private var calorieAdjustmentAmount: Int = 0
  @State private var adjustmentItem: AdjustmentItem? = nil
  
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
        }
      }
      .listRowClearStyle()
      
      // MARK: - 메뉴 헤더 섹션
      Section {
        // 메뉴 리스트 ...
        HStack {
          Text("메뉴")
            .font(.pretendard(type: .bold, size: 20))
          Text("\(cartManager.cartItems.count)")
            .font(.pretendard(type: .bold, size: 20))
            .foregroundColor(.main)
        }
      }
      .listRowClearStyle()
      
      // MARK: - 메뉴 아이템들
      if cartManager.cartItems.isEmpty {
        Section {
          
          Text("추가된 음식이 없습니다.")
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 30)
        .listRowClearStyle()
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
      Spacer()
        .listRowClearStyle()
      
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
          
          .frame(maxWidth: .infinity)
          .background(Color.subBackground)
          VStack {
            CtaButton(buttonName: .eat, titleColor: .white, bgColor: .main) {
              print("dd")
              if !cartManager.cartItems.isEmpty {
                trigger()
              }
            }
          }
          .padding(.top, Spacing.extrLarge)
        }
      }
      .listRowClearStyle()
    }
    
    .onAppear {
      dataManager.setModelContext(modelContext)
    }
    .sheet(item: $adjustmentItem, content: { item in
      CalorieAdjustmentView(
        isPresented: Binding(
          get: { adjustmentItem != nil },
          set: { if !$0 { adjustmentItem = nil } } // 시트가 닫힐 때 nil로 변경
        ),
        type: item.type,
        adjustmentAmount: item.amount,
        onSave: {
          saveCart()
        }
      )
      .presentationDetents([.fraction(0.9)])
      .presentationDragIndicator(.visible)
    }
    )
    
    .alert("식단 저장 성공!", isPresented: $showSaveAlert) {
      Button("확인") {
        if saveMessage.contains("성공") {
          cartManager.cartItems.removeAll()
          dismiss()
        }
      }
    } message: {
      Text(saveMessage)
    }
  }
  // MARK: - 저장하기전에 AdjustmnetSheet 띄울지 말지
  private func trigger() {
    // CartManager에서 일일 목표 칼로리 가져오기 (더미상태)
    let dailGoalCalories = cartManager.dailyGoals.calories
    let currentCalories = cartManager.totalNutrition.calories
    let difference = dailGoalCalories - currentCalories
    
    if difference > 200 {
      adjustmentItem = AdjustmentItem(type: .underLimit, amount: difference)
    } else if difference < -200 {
      adjustmentItem = AdjustmentItem(type: .overLimit, amount: abs(difference))
    } else {
      saveCart()
    }
  }
  
  // MARK: - 저장함수 여러가지 상태변경
  private func saveCart() {
    isSaving = true
    
    Task {
      let result = await dataManager.saveMeal(from: cartManager.cartItems)
      
      await MainActor.run {
        saveMessage = result.message
        showSaveAlert = true
        isSaving = false
      }
    }
  }
}
extension View {
  func listRowClearStyle() -> some View {
    self
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
      .listRowBackground(Color.clear)
  }
}

#Preview {
  CartView()
    .environmentObject(CartManager())
}
