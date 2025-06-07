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
        DateSelectionView(selectedDate: $selectedDate, showDatePicker: $showDatePicker)
        CalorieSummaryView()
        NutrientSectionView()
        MealEntryView()
      }
      .padding([.horizontal, .bottom], 16)
      .padding(.top, 64)
      .background(Color(.systemGray6))
      .sheet(isPresented: $showDatePicker) {
        CustomCalendarView(selectedDate: $selectedDate, onDismiss: {
          showDatePicker = false
        })
        .presentationDetents([.height(500)])
      }
    }
    .navigationBarBackButtonHidden()
    .ignoresSafeArea()
  }
}

#Preview {
  NavigationStack {
    MainUIView()
  }
}
