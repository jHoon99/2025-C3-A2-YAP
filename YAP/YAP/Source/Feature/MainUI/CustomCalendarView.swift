//
//  CustomCalendarView.swift
//  YAP
//
//  Created by 조운경 on 6/2/25.
//

import SwiftUI

struct CustomCalendarView: View {
  @Binding var selectedDate: Date
  var onDismiss: () -> Void
  
  @State private var currentMonthOffset = 0
  
  init(selectedDate: Binding<Date>, onDismiss: @escaping () -> Void) {
    self._selectedDate = selectedDate
    self.onDismiss = onDismiss
    
    let calendar = Calendar.current
    let today = calendar.startOfMonth(for: Date())
    let selectedMonth = calendar.startOfMonth(for: selectedDate.wrappedValue)
    
    let offset = calendar.dateComponents([.month], from: today, to: selectedMonth).month ?? 0
    self._currentMonthOffset = State(initialValue: offset)
  }
  
  var calorieData: [Date: Int] = [
    Date(): 900,
    Date() - 86400: 800
  ]
  
  var body: some View {
    VStack(spacing: 16) {
      let days = generateDays()
      
      calendarHeader
        .padding()
      
      HStack {
        ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
          Text(day)
            .font(.caption)
            .frame(maxWidth: .infinity)
            .foregroundColor(.gray)
        }
      }
      
      ZStack(alignment: .top) {
        Color.clear.frame(height: 380)
        LazyVGrid(columns: Array(
          repeating: GridItem(.flexible()), count: 7
        ), spacing: 16) {
          ForEach(days, id: \.self) { date in
            if Calendar.current.isDate(date, equalTo: Date.distantPast, toGranularity: .day) {
              Spacer()
            } else {
              Button(action: {
                selectedDate = date
                onDismiss()
              }, label: {
                VStack(spacing: 4) {
                  Text("\(Calendar.current.component(.day, from: date))")
                    .font(.subheadline)
                    .frame(width: 36, height: 36)
                    .background(
                      Calendar.current.isDate(date, inSameDayAs: selectedDate) ? Color.main : Color.clear
                    )
                    .foregroundColor(Calendar.current.isDate(date, inSameDayAs: selectedDate) ?
                      .white : .primary
                    )
                    .clipShape(Circle())
                  
                  if let kcal = calorieData.first(where: { Calendar.current.isDate($0.key, inSameDayAs: date) })?.value {
                    Text("\(kcal)kcal")
                      .font(.pretendard(type: .regular, size: 10))
                      .foregroundColor(.white)
                      .padding(4)
                      .background(Color.main)
                      .cornerRadius(12)
                  } else {
                    Spacer()
                  }
                }
              })
            }
          }
        }
      }
    }
  }
  
  private var calendarHeader: some View {
    HStack {
      Button(action: {
        currentMonthOffset -= 1
      }, label: {
        Image(systemName: "chevron.left")
      })
      Spacer()
      Text(currentMonth)
        .font(.headline)
      Spacer()
      Button(action: {
        currentMonthOffset += 1
      }, label: {
        Image(systemName: "chevron.right")
      })
    }
  }
  
  var currentMonth: String {
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .month, value: currentMonthOffset, to: Date()) ?? Date()
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy년 M월"
    return formatter.string(from: date)
  }
  
  func generateDays() -> [Date] {
    var dates: [Date] = []
    let calendar = Calendar.current
    let today = Date()
    let displayMonth = calendar.date(
      byAdding: .month,
      value: currentMonthOffset,
      to: today)
    ?? today
    
    let range = calendar.range(of: .day, in: .month, for: displayMonth) ?? 1..<32
    let components = calendar.dateComponents([.year, .month], from: displayMonth)
    let firstOfMonth = calendar.date(from: components) ?? Date()
    let weekdayOffset = calendar.component(.weekday, from: firstOfMonth) - 1
    
    for _ in 0..<weekdayOffset {
      dates.append(Date.distantPast) // placeholder
    }
    
    for day in range {
      if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
        dates.append(date)
      }
    }
    
    return dates
  }
}

extension Calendar {
  func startOfMonth(for date: Date) -> Date {
    return self.date(from: self.dateComponents([.year, .month], from: date)) ?? date
  }
}

#Preview {
  CustomCalendarView(selectedDate: .constant(Date())) {
    // 닫기
  }
}
