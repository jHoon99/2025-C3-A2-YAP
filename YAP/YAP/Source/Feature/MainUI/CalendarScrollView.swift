//
//  CalendarScrollView.swift
//  YAP
//
//  Created by 조운경 on 6/5/25.
//

import SwiftUI

struct CalendarScrollView: View {
  let dates: [Date]
  let itemWidth: CGFloat
  let spacing: CGFloat
  
  @Binding var selectedDate: Date
  @Binding var selectedIndex: Int
  @Binding var scrollOffset: CGFloat
  @Binding var dragOffset: CGFloat
  @Binding var didInitialScroll: Bool
  
  var body: some View {
    GeometryReader { geo in
      let totalItemWidth = itemWidth + spacing
      let centerX = geo.size.width / 2
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: spacing) {
          ForEach(0..<dates.count, id: \.self) { index in
            VStack(spacing: 4) {
              Text(dates[index].dayOfTheWeek)
                .font(.caption)
                .foregroundColor(.gray)
              
              Text(dates[index].day)
                .font(.headline)
                .foregroundColor(index == selectedIndex ? .white : .black)
                .frame(width: itemWidth, height: 36)
                .background(index == selectedIndex ? Color.blue : Color.clear)
                .clipShape(Circle())
            }
          }
        }
        .padding(.horizontal, centerX - itemWidth / 2)
        .offset(x: scrollOffset + dragOffset)
        .onAppear {
          if !didInitialScroll {
            scrollOffset  = -CGFloat(selectedIndex) * totalItemWidth
            didInitialScroll = true
          }
        }
        .gesture(
          DragGesture()
            .onChanged { value in
              dragOffset = value.translation.width
            }
            .onEnded { value in
              let predictedOffset = scrollOffset + value.translation.width
              let rawIndex = -predictedOffset / totalItemWidth
              let clampedIndex = (rawIndex).rounded().clamped(to: 0...(CGFloat(dates.count - 1)))
              
              withAnimation(.easeOut) {
                selectedIndex = Int(clampedIndex)
                scrollOffset = -CGFloat(selectedIndex) * totalItemWidth
                dragOffset = 0
                selectedDate = dates[selectedIndex]
              }
            }
        )
      }
      .frame(height: 100)
    }
  }
}
