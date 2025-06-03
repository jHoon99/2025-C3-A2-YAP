//
//  InbodyInfoView.swift
//  YAP
//
//  Created by oliver on 5/31/25.
//

import SwiftData
import SwiftUI

struct InbodyInfoView: View {
  @Query var inbody: [Inbody]
  private static let initialStartDate = Date()
  private static let initialendDate = Date()
  
  @State private var selectedRange: TimeRange = .threeMonths
  @State private var startDate: Date = initialStartDate
  @State private var endDate: Date = initialendDate
  @State private var showRangeSelectionSheet = false
  @State private var isFirstCustomRangeSelection = true
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        TimeRangeSelectionButtons(
          selectedRange: $selectedRange,
          showRangeSelectionSheet: $showRangeSelectionSheet,
          isFirstCustomRangeSelection: $isFirstCustomRangeSelection
        )
        
        ForEach(BodyComposition.allCases) { component in
          BodyCompositionOverview(data: makeSeries(from: component))
            .padding(16)
            .background(
              RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
            )
        }
        
        Text("기록 보기")
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Rectangle()
          .frame(height: 300)
      }
      .padding(16)
      .background(Color("subBackground"))
    }
    .sheet(isPresented: $showRangeSelectionSheet ) {
      RangeSelectionSheet(
        startDate: $startDate,
        endDate: $endDate,
        showRangeSelectionSheet: $showRangeSelectionSheet,
        isFirstCustomRangeSelection: $isFirstCustomRangeSelection,
        editingStartDate: startDate,
        editingEndDate: endDate
      )
    }
  }
  
  private func makeSeries(from component: BodyComposition) -> Data.Series {
    let measurements = inbody
      .filter { selectedRange.isWithinRange(from: startDate, to: endDate)($0.date) }
      .map { ($0.date, component.value(from: $0)) }
    return Data.Series(name: component.name, measurements: measurements)
  }
}

struct InbodyInfoPreview: View {
  var inbody: [Inbody]
  private static let initialStartDate = Date()
  private static let initialendDate = Date()
  
  @State private var selectedRange: TimeRange = .threeMonths
  @State private var startDate: Date = initialStartDate
  @State private var endDate: Date = initialendDate
  @State private var showRangeSelectionSheet = false
  @State private var isFirstCustomRangeSelection = true
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        TimeRangeSelectionButtons(
          selectedRange: $selectedRange,
          showRangeSelectionSheet: $showRangeSelectionSheet,
          isFirstCustomRangeSelection: $isFirstCustomRangeSelection
        )
        
        ForEach(BodyComposition.allCases) { component in
          BodyCompositionOverview(data: makeSeries(from: component))
            .padding(16)
            .background(
              RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
            )
        }
        
        Text("기록 보기")
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Rectangle()
          .frame(height: 300)
      }
      .padding(16)
      .background(Color("subBackground"))
    }
    .sheet(isPresented: $showRangeSelectionSheet ) {
      RangeSelectionSheet(
        startDate: $startDate,
        endDate: $endDate,
        showRangeSelectionSheet: $showRangeSelectionSheet,
        isFirstCustomRangeSelection: $isFirstCustomRangeSelection,
        editingStartDate: startDate,
        editingEndDate: endDate
      )
    }
  }
  
  private func makeSeries(from component: BodyComposition) -> Data.Series {
    let measurements = inbody
      .filter { selectedRange.isWithinRange(from: startDate, to: endDate)($0.date) }
      .map { ($0.date, component.value(from: $0)) }
    return Data.Series(name: component.name, measurements: measurements)
  }
}

private enum TimeRange: String, CaseIterable, Identifiable {
  case threeMonths = "3개월"
  case sixMonths = "6개월"
  case oneYear = "1년"
  case custom = "기간 설정"
  
  var id: String { rawValue }
  
  func startDate(endDate: Date, calendar: Calendar = .current) -> Date {
    switch self {
    case .threeMonths:
      return calendar.date(byAdding: .month, value: -3, to: endDate)!
    case .sixMonths:
      return calendar.date(byAdding: .month, value: -6, to: endDate)!
    case .oneYear:
      return calendar.date(byAdding: .year, value: -1, to: endDate)!
    case .custom:
      return Date()
    }
  }
  
  func isWithinRange(from startDate: Date, to endDate: Date, calendar: Calendar = .current) -> ((Date) -> Bool) {
    switch self {
    case .threeMonths:
      return { day in
        day >= calendar.date(byAdding: .month, value: -3, to: endDate)!
      }
    case .sixMonths:
      return { day in
        day >= calendar.date(byAdding: .month, value: -6, to: endDate)!
      }
    case .oneYear:
      return { day in
        day >= calendar.date(byAdding: .year, value: -1, to: endDate)!
      }
    case .custom:
      return { day in
        day >= startDate && day <= endDate
      }
    }
  }
}

private enum BodyComposition: String, CaseIterable, Identifiable {
  case weight = "체중"
  case bodyFatMass = "체지방량"
  case skeletalMuscleMass = "골격근량"
  
  var id: Self { self }
  
  var name: String {
    self.rawValue
  }
  
  func value(from inbody: Inbody) -> Double {
    switch self {
    case .weight: return inbody.weight
    case .bodyFatMass: return inbody.bodyFatMass
    case .skeletalMuscleMass: return inbody.skeletalMuscleMass
    }
  }
}

private struct TimeRangeSelectionButtons: View {
  @Binding var selectedRange: TimeRange
  @Binding var showRangeSelectionSheet: Bool
  @Binding var isFirstCustomRangeSelection: Bool
  
  var body: some View {
    HStack {
      ForEach(TimeRange.allCases) { range in
        Button(action: {
          if range == .custom && needsToShowSheet {
            selectedRange = range
            showRangeSelectionSheet = true
          } else {
            selectedRange = range
          }
        }, label: {
          Text(range.rawValue)
            .foregroundStyle(selectedRange == range ? Color("background") : Color("textColor"))
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(
              Capsule()
                .fill(selectedRange == range ? Color("main") : Color.white)
            )
        })
      }
    }
  }
  
  private var needsToShowSheet: Bool {
    return selectedRange != .custom && isFirstCustomRangeSelection || selectedRange == .custom
  }
}

private struct RangeSelectionSheet: View {
  @Binding var startDate: Date
  @Binding var endDate: Date
  @Binding var showRangeSelectionSheet: Bool
  @Binding var isFirstCustomRangeSelection: Bool
  
  @State var editingStartDate: Date
  @State var editingEndDate: Date
  
  var body: some View {
    VStack {
      HStack {
        Text("기간 설정")
          .font(.system(size: 20, weight: .bold))
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Button(action: {
          showRangeSelectionSheet = false
        }, label: {
          Image(systemName: "xmark")
        })
      }
      .padding(.bottom, 8)
      DatePicker("시작일", selection: $editingStartDate, displayedComponents: [.date])
      DatePicker("종료일", selection: $editingEndDate, displayedComponents: [.date])
      HStack {
        Button(action: {
          editingStartDate = startDate
          editingEndDate = endDate
        }, label: {
          Text("초기화")
            .padding(.vertical, 8)
            .padding(.horizontal, 48)
        })
        .buttonStyle(.bordered)
        
        Spacer()
        
        Button(action: {
          startDate = editingStartDate
          endDate = editingEndDate
          showRangeSelectionSheet = false
          if isFirstCustomRangeSelection {
            isFirstCustomRangeSelection = false
          }
        }, label: {
          Text("적용하기")
            .padding(.vertical, 8)
            .padding(.horizontal, 48)
        })
        .buttonStyle(.borderedProminent)
      }
      .padding(.top, 20)
    }
    .padding(18)
    .presentationDetents([.height(260)])
    .presentationCornerRadius(24)
  }
}

#Preview {
  InbodyInfoPreview(inbody: Inbody.sampleData)
}
