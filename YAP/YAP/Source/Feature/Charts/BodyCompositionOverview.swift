//
//  BodyCompositionOverview.swift
//  YAP
//
//  Created by oliver on 5/31/25.
//

import Charts
import SwiftUI

private struct BodyCompositionOverviewChart: View {
  @Environment(\.calendar) var calendar
  @Binding var rawSelectedDate: Date?
  
  var data: ChartData.Series
  private let symbolSize: CGFloat = 100
  private let lineWidth: CGFloat = 3
  
  /// rawSelectedDate이 그래프상에서 점에 해당하는지 확인
  private var selectedDate: Date? {
    if let rawSelectedDate {
      return data.measurements.first {
        calendar.isDate($0.day, inSameDayAs: rawSelectedDate)
      }?.day
    }
    
    return nil
  }
  
  var body: some View {
    let values = data.measurements
      .map { $0.amount }
    let minValue = values.min() ?? 0
    let maxValue = values.max() ?? 0
    
    Chart {
      ForEach(data.measurements, id: \.day) { element in
        LineMark(
          x: .value("Day", element.day, unit: .day),
          y: .value("Value", element.amount)
        )
      }
      .symbol(Circle())
      .lineStyle(StrokeStyle(lineWidth: lineWidth))
      .symbolSize(symbolSize)
      
      if let selectedDate {
        RuleMark(x: .value("Selected", selectedDate, unit: .day))
          .foregroundStyle(Color.background)
          .offset(yStart: 0)
          .zIndex(-1)
          .annotation(
            position: .top, spacing: 0,
            overflowResolution: .init(
              x: .fit(to: .chart),
              y: .disabled
            )
          ) {
            valueSelectionPopover
          }
      }
    }
    .chartXAxis(.hidden)
    .chartYScale(
      domain: minValue...maxValue,
      range: .plotDimension(startPadding: 8, endPadding: 8)
    )
    .chartXSelection(value: $rawSelectedDate)
  }
  
  @ViewBuilder
  var valueSelectionPopover: some View {
    if let selectedDate {
      Text(selectedDate.formattedYMD)
        .padding(6)
        .background {
          RoundedRectangle(cornerRadius: 4)
            .foregroundStyle(Color.background)
        }
    } else {
      EmptyView()
    }
  }
}

struct BodyCompositionOverview: View {
  // swiftlint:disable:next redundant_optional_initialization
  @State var rawSelectedDate: Date? = nil
  var data: ChartData.Series
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(data.name)
        .font(.pretendard(type: .semibold, size: 16))
      BodyCompositionOverviewChart(
        rawSelectedDate: $rawSelectedDate, data: data
      )
      .frame(height: 100)
    }
    .padding(16)
  }
}

#Preview {
  BodyCompositionOverview(data: ChartData.bodyCompositionData[0])
}
