//
//  InbodyInfoView.swift
//  YAP
//
//  Created by oliver on 5/31/25.
//

import SwiftData
import SwiftUI

struct InbodyInfoView: View {
  @State private var selectedRange: TimeRange = .threeMonths
  @State private var startDate: Date = initialStartDate
  @State private var endDate: Date = initialEndDate
  @State private var showRangeSelectionSheet = false
  @State private var isFirstCustomRangeSelection = true
  
  private static let initialStartDate = Date()
  private static let initialEndDate = Date()
  @Query var bodyRecords: [Inbody]
  
  var body: some View {
    ScrollView {
      VStack(spacing: Spacing.large) {
        TimeRangeSelectionButtons(
          selectedRange: $selectedRange,
          showRangeSelectionSheet: $showRangeSelectionSheet,
          isFirstCustomRangeSelection: $isFirstCustomRangeSelection
        )
        
        BodyCompositionCharts(
          bodyRecords: bodyRecords,
          selectedRange: selectedRange,
          startDate: startDate,
          endDate: endDate
        )
        
        BodyRecordCards(bodyRecords: bodyRecords.sorted { $0.date > $1.date })
      }
      .padding(16)
    }
    .scrollIndicators(.hidden)
    .sheet(isPresented: $showRangeSelectionSheet) {
      RangeSelectionSheet(
        startDate: $startDate,
        endDate: $endDate,
        showRangeSelectionSheet: $showRangeSelectionSheet,
        isFirstCustomRangeSelection: $isFirstCustomRangeSelection,
        editingStartDate: startDate,
        editingEndDate: endDate
      )
    }
    .background(.subBackground)
    .navigationTitle("인바디")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        NavigationLink {
          // TODO: OnboardingInbodyOcrView을 온보딩과 decouple해야 합니다.
          OnboardingInbodyOcrView()
        } label: {
          Image(systemName: "plus.square.dashed")
        }
      }
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
            .font(.pretendard(type: .medium, size: 14))
            .foregroundStyle(selectedRange == range ? .background : .text)
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(
              Capsule()
                .fill(selectedRange == range ? .main : .white)
            )
        })
      }
    }
  }
  
  private var needsToShowSheet: Bool {
    return selectedRange != .custom && isFirstCustomRangeSelection || selectedRange == .custom
  }
}

private struct BodyCompositionCharts: View {
  var bodyRecords: [Inbody]
  var selectedRange: TimeRange
  var startDate: Date
  var endDate: Date
  
  var body: some View {
    ForEach(BodyComposition.allCases) { component in
      BodyCompositionOverview(data: makeSeries(from: component))
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(Color.white)
        )
    }
  }
  
  private func makeSeries(from component: BodyComposition) -> ChartData.Series {
    let measurements = bodyRecords
      .filter { selectedRange.isWithinRange(from: startDate, to: endDate)($0.date) }
      .map { ($0.date, component.value(from: $0)) }
    return ChartData.Series(name: component.name, measurements: measurements)
  }
  
  private enum BodyComposition: String, CaseIterable, Identifiable {
    case weight = "체중 (kg)"
    case bodyFatMass = "체지방량 (kg)"
    case skeletalMuscleMass = "골격근량 (kg)"
    
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
}

private struct BodyRecordCards: View {
  var bodyRecords: [Inbody]
  
  var body: some View {
    VStack(spacing: 20) {
      Text("기록 보기")
        .font(.pretendard(type: .bold, size: 16))
        .frame(maxWidth: .infinity, alignment: .leading)
      
      ForEach(bodyRecords) { bodyRecord in
        InbodyCardView(inbody: bodyRecord)
          .background(.white)
          .cornerRadius(20)
      }
    }
    .padding(.top, 24)
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
          .font(.pretendard(type: .bold, size: 20))
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Button(action: {
          showRangeSelectionSheet = false
        }, label: {
          Image(systemName: "xmark")
            .foregroundStyle(.text)
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
            .font(.pretendard(type: .regular, size: 16))
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
            .font(.pretendard(type: .regular, size: 16))
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
