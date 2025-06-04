//
//  MainUIView.swift
//  YAP
//
//  Created by 조운경 on 6/2/25.
//

import SwiftUI

struct MainUIView: View {
  @State private var selectedDate = Date()
  @State private var showDatePicker = false
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        DateSelectionView()
        CalorieSummaryView()
        NutrientSectionView()
        MealEntryView(mealCount: 6)
      }
      .padding([.horizontal, .bottom], 16)
      .background(Color(.systemGray6))
      .sheet(isPresented: $showDatePicker) {
        CustomCalendarView()
      }
    }
  }
}

#Preview {
  MainUIView()
}
