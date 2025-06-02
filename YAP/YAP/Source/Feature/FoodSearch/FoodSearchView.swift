//
//  FoodSearchView.swift
//  YAP
//
//  Created by 조재훈 on 6/1/25.
//

import SwiftUI

struct FoodSearchView: View {
  
  @StateObject private var nutritionService = NutritionService.shared
  @State private var searchText: String = ""
  @State private var isSearching: Bool = false
  
  var body: some View {
    NavigationStack {
      VStack {
        if nutritionService.foodItem.isEmpty && !isSearching {
          ContentUnavailableView(
            "음식을 검색해보세요",
            systemImage: "magnifyingglass",
            description: Text("검색창에 음식 이름을 입력하세요")
          )
        } else if isSearching {
          ProgressView("검색 중...")
        } else if nutritionService.foodItem.isEmpty && !searchText.isEmpty {
          ContentUnavailableView(
            "검색 결과가 없습니다.",
            systemImage: "exclamationmark.magnifyingglass",
            description: Text("다른 검색어로 시도해보세요.")
          )
        } else {
          List {
            ForEach(nutritionService.foodItem) { item in
              FoodItemRow(food: item)
            }
          }
          .listStyle(PlainListStyle())
        }
      }
      .searchable(text: $searchText, prompt: "음식 이름을 입력하세요.")
      .onSubmit(of: .search) {
        performSearch()
      }
      .onChange(of: searchText) { newValue in
        if newValue.isEmpty {
          nutritionService.foodItem = []
        }
      }
    }
  }
  
  private func performSearch() {
    guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    
    isSearching = true
    
    Task {
      await nutritionService.searchFood(query: searchText)
    }
  }
}

#Preview {
    FoodSearchView()
}
