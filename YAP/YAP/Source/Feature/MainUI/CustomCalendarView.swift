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
  
  var calorieData: [Date: Int] = [
    Date(): 900,
    Date() - 86400: 800
  ]
  
  var body: some View {
    VStack {
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
      .padding()
      
      let days = generateDays()
      
      LazyVGrid(columns: Array(
        repeating: GridItem(.flexible()), count: 7
      ), spacing: 16) {
        ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
          Text(day)
            .font(.caption)
            .foregroundColor(.gray)
        }
        
        ForEach(days, id: \.self) { date in
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
                  .font(.pretendard(type: .regular, size: 11))
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

#Preview {
  CustomCalendarView(selectedDate: .constant(Date())) {
    // 닫기
  }
}
