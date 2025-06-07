//
//  ContentView.swift
//  YAP
//
//  Created by 여성일 on 5/28/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
  @Query var inbodyData: [Inbody]
  @Query var calorieData: [CalorieRequirements]
  @Query var activityData: [ActivityInfo]
  
  var body: some View {
    NavigationStack {
      if inbodyData.isEmpty || calorieData.isEmpty || activityData.isEmpty {
        OnboardingView()
      } else {
        MainUIView()
      }
    }
  }
}

#Preview {
  ContentView()
}
