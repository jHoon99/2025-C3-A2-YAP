//
//  DateSelectionView.swift
//  YAP
//
//  Created by 조운경 on 6/2/25.
//

import SwiftUI

struct DateSelectionView: View {
  @Binding var selectedDate: Date
  @Binding var showDatePicker: Bool
  
  @State private var dates: [Date] = []

  let itemWidth: CGFloat = 36
  let spacing: CGFloat = 16
  
  @State private var scrollOffset: CGFloat = 0
  @State private var dragOffset: CGFloat = 0
  @State private var selectedIndex: Int = 100 // 0 ~ 200 중 가운데 = 오늘
  @State private var didInitialScroll: Bool = false

  var body: some View {
    VStack {
      HStack {
        Text(formattedShortDate(date: selectedDate))
          .font(.pretendard(type: .bold, size: 20))
          .foregroundStyle(Color.text)
          
        Button(action: {
          showDatePicker = true
        }, label: {
          Image(systemName: "arrowtriangle.down.fill")
            .resizable()
            .frame(width: 16, height: 10)
            .foregroundStyle(Color.text)
        })
        Spacer()
        
        NavigationLink {
          InbodyInfoView()
        } label: {
          Image(systemName: "chart.xyaxis.line")
            .foregroundStyle(.text)
        }
      }
      
      CalendarScrollView(
        dates: dates,
        itemWidth: itemWidth,
        spacing: spacing,
        selectedDate: $selectedDate,
        selectedIndex: $selectedIndex,
        scrollOffset: $scrollOffset,
        dragOffset: $dragOffset,
        didInitialScroll: $didInitialScroll
      )
      .frame(height: 100)
    }
    .padding(.horizontal, 16)
    .onAppear {
      dates = generateDates(centeredAround: selectedDate)
    }
    .onChange(of: selectedDate) { newValue in
      dates = generateDates(centeredAround: newValue)
      if let index = dates.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: newValue)
      }) {
        selectedIndex = index
        scrollOffset = -CGFloat(index) * (itemWidth + spacing)
      }
    }
  }
  
  private func dayOfWeek(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "E"
    return formatter.string(from: date)
  }
  
  private func day(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter.string(from: date)
  }
  
  func formattedShortDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM.dd"
    return formatter.string(from: date)
  }
  
  func generateDates(centeredAround date: Date) -> [Date] {
    (0..<201).compactMap {
      Calendar.current.date(byAdding: .day, value: $0 - 100, to: date)
    }
  }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}

#Preview {
  DateSelectionView(selectedDate: .constant(Date()), showDatePicker: .constant(false))
}

extension Date {
  var dayOfTheWeek: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "E"
    return formatter.string(from: self)
  }
  
  var day: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter.string(from: self)
  }
}
