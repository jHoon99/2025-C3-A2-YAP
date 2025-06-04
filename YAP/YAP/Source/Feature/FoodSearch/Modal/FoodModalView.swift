//
//  FoodModalView.swift
//  YAP
//
//  Created by 조재훈 on 6/2/25.
//

import SwiftUI

struct FoodModalView: View {
  
  let food: FoodItem
  @State private var selectedUnit: NutritionUnit = .totalGram
  @State private var quantity: Int = 1
  @State private var showCartView: Bool = false
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var cartManager: CartManager
  
  var body: some View {
    ZStack {
      Color.subBackground
        .ignoresSafeArea()
      VStack(alignment: .leading, spacing: Spacing.large) {
        VStack {
          Text(food.foodName)
            .font(.pretendard(type: .semibold, size: 24))
        }
        VStack(spacing: Spacing.medium) {
          HStack(spacing: Spacing.medium) {
            ModalCircle(
              title: "탄",
              value: food.nutrientValue(
                for: .carbohydrate,
                quantity: quantity,
                unit: selectedUnit
              ),
              unit: "g")
            ModalCircle(
              title: "단",
              value: food.nutrientValue(
                for: .protein,
                quantity: quantity,
                unit: selectedUnit
              ),
              unit: "g"
            )
            ModalCircle(
              title: "지",
              value: food.nutrientValue(
                for: .fat,
                quantity: quantity,
                unit: selectedUnit
              ),
              unit: "g")
          }
          Text("\(food.nutrientValue(for: .calorie, quantity: quantity, unit: selectedUnit))kcal")
            .font(.pretendard(type: .bold, size: 20))
            .monospacedDigit()
            .frame(width: 100, alignment: .center)
        }
        .frame(width: 346, height: 106)
        .background(Color.white)
        .cornerRadius(16)
        VStack(spacing: Spacing.medium) {
          // 인분 or g
          HStack(spacing: Spacing.medium) {
            ForEach(NutritionUnit.allCases, id: \.self) { unit in
              Button {
                withAnimation(.easeIn(duration: 0.3)) {
                  selectedUnit = unit
                  quantity = unit == .totalGram ? 1 : 100
                }
              } label: {
                Text(getDisplayText(for: unit))
                  .font(.pretendard(type: .bold, size: 16))
                  .foregroundColor(.black)
                  .frame(width: 146, height: 47)
                  .background(
                    RoundedRectangle(cornerRadius: 20)
                      .fill(selectedUnit == unit ?
                            Color.subBackground : Color.clear))
              }
            }
          }
        }
        .frame(width: 346, height: 70)
        .background(Color.white)
        .cornerRadius(32)
        // 증감
        VStack(spacing: Spacing.medium) {
          HStack(spacing: Spacing.medium) {
            Button {
              withAnimation(.easeInOut(duration: 0.2)) {
                decreaseQuantity()
              }
            } label: {
              Image(systemName: "minus")
                .font(.pretendard(type: .bold, size: 20))
                .foregroundColor(.black)
                .frame(width: 24, height: 24)
                .padding(30)
            }
            Spacer()
            Text("\(quantity)")
            Spacer()
            Button {
              withAnimation(.easeInOut(duration: 0.2)) {
                increaseQuantity()
              }
            } label: {
              Image(systemName: "plus")
                .font(.pretendard(type: .bold, size: 20))
                .foregroundColor(.black)
                .frame(width: 24, height: 24)
                .padding(30)
            }
          }
        }
        .frame(width: 342, height: 70)
        .background(Color.white)
        .cornerRadius(32)
        VStack {
          CtaButton(buttonName: .add, titleColor: .white, bgColor: .main, action: {
            cartManager.addFood(food, quantity: quantity, unit: selectedUnit)
            dismiss()
          })
        }
      }
      .padding(.horizontal, Spacing.large)
      .padding(.top, 40)
    }
  }
  // MARK: - 인분,g Text표시
  private func getDisplayText(for unit: NutritionUnit) -> String {
    switch unit {
    case .totalGram:
      return "인분 (\(food.totalSizeIntFormatted))"
    case .gram:
      return "g"
    }
  }
  // MARK: - 인분,g (quantity) 증감
  private func increaseQuantity() {
    switch selectedUnit {
    case .totalGram:
      quantity += 1
    case .gram:
      quantity += 50
    }
  }
  
  private func decreaseQuantity() {
    switch selectedUnit {
    case .totalGram:
      if quantity > 1 {
        quantity -= 1
      }
    case .gram:
      if quantity > 50 {
        quantity -= 50
      }
    }
  }
}

#Preview {
  FoodModalView(food: FoodItem(
    foodName: "닭가슴살",
    servingSize: "100g",
    totalSize: "100g",
    calories: "165",
    protein: "31",
    fat: "3.6",
    carbohydrate: "12.5",
    sugar: "0",
    dietaryFiber: "0",
    sodium: "70",
    cholesterol: "85",
    saturatedFat: "1")
  )
}
