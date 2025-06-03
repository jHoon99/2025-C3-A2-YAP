//
//  InbodyInfoView.swift
//  YAP
//
//  Created by oliver on 5/31/25.
//

import SwiftData
import SwiftUI

enum TimeRange: String, CaseIterable, Identifiable {
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
  
  func predicate(startDate: Date, endDate: Date, calendar: Calendar = .current) -> ((Date) -> Bool) {
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

struct InbodyInfoView: View {
  @Query var inbody: [Inbody]
  @State private var selectedRange: TimeRange = .threeMonths
  @State private var startDate: Date = Date()
  @State private var endDate: Date = Date()
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        HStack {
          ForEach(TimeRange.allCases) { range in
            Button(action: {
              withAnimation {
                selectedRange = range
                endDate = Date()
                startDate = range.startDate(endDate: endDate)
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
        
        if selectedRange == .custom {
          DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
          DatePicker("End Date", selection: $endDate, displayedComponents: [.date])
        }
        
        BodyCompositionOverview(data: weightSeries)
          .padding(16)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(Color.white)
          )
        
        BodyCompositionOverview(data: bodyFatMassSeries)
          .padding(16)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(Color.white)
          )
        
        BodyCompositionOverview(data: skeletalMuscleMassSeries)
          .padding(16)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(Color.white)
          )
        
        Text("기록 보기")
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Rectangle()
          .frame(height: 300)
      }
      .padding(16)
      .background(Color("subBackground"))
    }
    .onAppear {
      startDate = selectedRange.startDate(endDate: endDate)
    }
  }
  
  var weightSeries: Data.Series {
    let measurements = inbody
      .filter { $0.date >= startDate && $0.date <= endDate }
      .map { ($0.date, $0.weight) }
    return Data.Series(name: "체중", measurements: measurements)
  }
  
  var bodyFatMassSeries: Data.Series {
    let measurements = inbody
      .filter { $0.date >= startDate && $0.date <= endDate }
      .map { ($0.date, $0.bodyFatMass) }
    return Data.Series(name: "체지방량", measurements: measurements)
  }
  
  var skeletalMuscleMassSeries: Data.Series {
    let measurements = inbody
      .filter { $0.date >= startDate && $0.date <= endDate }
      .map { ($0.date, $0.skeletalMuscleMass) }
    return Data.Series(name: "골격근량", measurements: measurements)
  }
}

struct InbodyInfoPreview: View {
  var inbody: [Inbody]
  private static let initialStartDate = Date()
  private static let initialendDate = Date()
  @State private var selectedRange: TimeRange = .threeMonths
  @State private var startDate: Date = initialStartDate
  @State private var endDate: Date = initialendDate
  @State private var editingStartDate: Date = initialStartDate
  @State private var editingEndDate: Date = initialendDate
  @State private var isShowingSheet = false
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        HStack {
          ForEach(TimeRange.allCases) { range in
            Button(action: {
              selectedRange = range
              let isInitialDate = Calendar.current.isDate(editingStartDate, equalTo: Self.initialStartDate, toGranularity: .day) &&
                                  Calendar.current.isDate(editingEndDate, equalTo: Self.initialendDate, toGranularity: .day)

              if range == .custom && isInitialDate {
                isShowingSheet = true
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
        
        BodyCompositionOverview(data: weightSeries)
          .padding(16)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(Color.white)
          )
        
        BodyCompositionOverview(data: bodyFatMassSeries)
          .padding(16)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(Color.white)
          )
        
        BodyCompositionOverview(data: skeletalMuscleMassSeries)
          .padding(16)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(Color.white)
          )
        
        Text("기록 보기")
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Rectangle()
          .frame(height: 300)
      }
      .padding(16)
      .background(Color("subBackground"))
    }
    .sheet(isPresented: $isShowingSheet) {
      VStack {
        HStack {
          Text("기간 설정")
            .font(.system(size: 20, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Button(action: {
            isShowingSheet = false
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
            isShowingSheet = false
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
  
  var weightSeries: Data.Series {
    let measurements = inbody
      .filter { selectedRange.predicate(startDate: startDate, endDate: endDate)($0.date) }
      .map { ($0.date, $0.weight) }
    return Data.Series(name: "체중", measurements: measurements)
  }
  
  var bodyFatMassSeries: Data.Series {
    let measurements = inbody
      .filter { selectedRange.predicate(startDate: startDate, endDate: endDate)($0.date) }
      .map { ($0.date, $0.bodyFatMass) }
    return Data.Series(name: "체지방량", measurements: measurements)
  }
  
  var skeletalMuscleMassSeries: Data.Series {
    let measurements = inbody
      .filter { selectedRange.predicate(startDate: startDate, endDate: endDate)($0.date) }
      .map { ($0.date, $0.skeletalMuscleMass) }
    return Data.Series(name: "골격근량", measurements: measurements)
  }
}

#Preview {
  InbodyInfoPreview(inbody: Inbody.sampleData)
}
