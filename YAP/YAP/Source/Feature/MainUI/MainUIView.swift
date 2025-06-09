//
//  MainUIView.swift
//  YAP
//
//  Created by 조운경 on 6/2/25.
//

import SwiftData
import SwiftUI

struct MainUIView: View {
  @Query var calorieToBurns: [CalorieToBurn]
  @State private var selectedDate = Date()
  @State private var showDatePicker = false
  
  private var calorieToBurnToday: CalorieToBurn? {
    calorieToBurns.first { $0.isSameDate(as: Date()) }
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        DateSelectionView(selectedDate: $selectedDate, showDatePicker: $showDatePicker)
        
        if let excessCalorieOfToday = calorieToBurnToday {
          WorkOutNotification(calroieToBurn: excessCalorieOfToday.calorie)
        }
        
        CalorieSummaryView(selectedDate: $selectedDate)
        NutrientSectionView(selectedDate: $selectedDate)
        MealEntryView(selectedDate: $selectedDate)
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
