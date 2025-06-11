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

      ZStack {
        // 🎯 고정된 선택 원
        Circle()
          .fill(Color.main)
          .frame(width: itemWidth, height: 36)
          .position(x: centerX, y: 60)

        // 🔄 날짜 스크롤
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: spacing) {
            ForEach(Array(dates.enumerated()), id: \.offset) { index, date in
              VStack(spacing: 4) {
                Text(date.dayOfTheWeek)
                  .font(.caption)
                  .foregroundColor(.gray)

                // ⚫️ 텍스트는 항상 검정
                Text(date.day)
                  .font(.headline)
                  .foregroundColor(.black)
                  .frame(width: itemWidth, height: 36)
                  .overlay(
                    // 선택된 날짜만 흰 글자 오버레이
                    index == selectedIndex
                      ? Text(date.day)
                          .font(.headline)
                          .foregroundColor(.white)
                      : nil
                  )
                  .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                      selectedIndex = index
                      selectedDate = dates[index]
                      scrollOffset = -CGFloat(index) * (itemWidth + spacing)
                      dragOffset = 0
                    }
                  }
              }
              .frame(width: itemWidth)
            }
          }
          .padding(.horizontal, centerX - itemWidth / 2)
          .offset(x: scrollOffset + dragOffset)
          .contentShape(Rectangle())
          .onAppear {
            if !didInitialScroll {
              scrollOffset = -CGFloat(selectedIndex) * totalItemWidth
              didInitialScroll = true
            }
          }
          .gesture(
            DragGesture()
              .onChanged { value in
                dragOffset = value.translation.width
              }
              .onEnded { value in
                let predictedOffset = scrollOffset + value.predictedEndTranslation.width
                let rawIndex = -predictedOffset / totalItemWidth
                let clampedIndex = rawIndex.rounded().clamped(to: 0...(CGFloat(dates.count - 1)))

                // 📌 스냅 애니메이션
                withAnimation(.easeOut(duration: 0.2)) {
                  selectedIndex = Int(clampedIndex)
                  scrollOffset = -CGFloat(selectedIndex) * totalItemWidth
                  dragOffset = 0
                  selectedDate = dates[selectedIndex]
                }
              }
          )
        }
      }
    }
    .frame(height: 100)
  }
}
