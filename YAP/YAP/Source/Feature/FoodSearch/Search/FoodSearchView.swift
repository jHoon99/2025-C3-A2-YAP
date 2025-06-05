//
//  FoodSearchView.swift
//  YAP
//
//  Created by 조재훈 on 6/1/25.
//

import SwiftUI

struct FoodSearchView: View {
  
  @StateObject private var nutritionService = NutritionService.shared
  @StateObject private var cartManager = CartManager()
  @State private var searchText: String = ""
  @State private var isSearching: Bool = false
  @State private var selectedFoodItem: FoodItem? = nil
  @State private var showcartView: Bool = false
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottomTrailing) {
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
                  .onTapGesture {
                    selectedFoodItem = item
                  }
              }
            }
            .listStyle(PlainListStyle())
          }
        }
        if !isSearching {
          FoodCameraView(searchedFoodName: $searchText)
            .padding()
            .padding(.bottom)
            .shadow(radius: 4, x: 0, y: 4)
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          NavigationLink(destination: CartView().environmentObject(cartManager)) {
            Button {
              showcartView = true
            } label: {
              ZStack {
                Image(systemName: "cart")
                  .foregroundColor(.text)
                
                if !cartManager.cartItems.isEmpty {
                  Text("\(cartManager.cartItems.count)")
                    .font(.pretendard(type: .light, size: 12))
                    .frame(width: 16, height: 16)
                    .foregroundColor(.mainWhite)
                    .background(.main)
                    .clipShape(Circle())
                    .offset(x: 8, y: -8)
                }
              }
            }
          }
        }
      }
      .sheet(item: $selectedFoodItem) { item in
        FoodModalView(food: item)
          .environmentObject(cartManager)
          .presentationDragIndicator(.visible)
          .presentationDetents([.fraction(0.6), .large])
      }
      .searchable(text: $searchText, prompt: "음식 이름을 입력하세요.")
      .onSubmit(of: .search) {
        performSearch()
      }
      .onChange(of: searchText) { newValue in
        if newValue.isEmpty {
          nutritionService.foodItem = []
        } else {
          performSearch()
        }
      }
    }
  }
  
  private func performSearch() {
    guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    
    isSearching = true
    
    Task {
      await nutritionService.searchFood(query: searchText)
      isSearching = false
    }
  }
}

#Preview {
  FoodSearchView()
}
