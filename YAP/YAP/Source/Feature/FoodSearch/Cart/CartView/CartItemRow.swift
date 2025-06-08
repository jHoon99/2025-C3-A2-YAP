//
//  CartItemRow.swift
//  YAP
//
//  Created by 조재훈 on 6/4/25.
//

import SwiftUI

struct CartItemRow: View {
  let item: CartItem
  
  var body: some View {
      HStack {
        Text(item.foodName)
          .font(.pretendard(type: .semibold, size: 16))
        
        Spacer()
        
        Text("\(item.calorie) kcal")
          .font(.pretendard(type: .semibold, size: 16))
          .foregroundColor(Color.placeholder)
      }
      .padding(.vertical, Spacing.small)
  }
}

#Preview {
  CartItemRow(item:
                CartItem(
                  id: UUID(),
                  foodName: "닭",
                  calorie: 200,
                  carbohydrate: 200,
                  protein: 200,
                  fat: 200,
                  quantity: 200,
                  unit: .gram)
  )
}
