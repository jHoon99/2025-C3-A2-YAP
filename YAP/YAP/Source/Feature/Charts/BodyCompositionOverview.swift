//
//  BodyCompositionOverview.swift
//  YAP
//
//  Created by oliver on 5/31/25.
//

import Charts
import SwiftUI

private struct BodyCompositionOverviewChart: View {
  @Binding var rawSelectedDate: Date?
  @Environment(\.calendar) var calendar
  
  let symbolSize: CGFloat = 100
  let lineWidth: CGFloat = 3
  var data: ChartData.Series
  
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
          .foregroundStyle(Color.gray.opacity(0.3))
          .offset(yStart: -50)
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
  
  /// rawSelectedDate이 그래프상에서 점에 해당하는지 확인
  private var selectedDate: Date? {
    if let rawSelectedDate {
      return data.measurements.first {
        calendar.isDate($0.day, inSameDayAs: rawSelectedDate)
      }?.day
    }
    
    return nil
  }
  
  @ViewBuilder
  var valueSelectionPopover: some View {
    if let selectedDate {
      Text(selectedDate.formattedYMD)
        .padding(6)
        .background {
          RoundedRectangle(cornerRadius: 4)
            .foregroundStyle(Color.gray.opacity(0.12))
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
