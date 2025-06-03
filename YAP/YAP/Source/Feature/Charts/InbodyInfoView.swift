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
}

extension Inbody {
  static var sampleData: [Inbody] {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    return [
      Inbody(
        date: formatter.date(from: "2024-06-05")!,
        weight: 78.0,
        height: 175.0,
        age: 31,
        bodyFatMass: 17.2,
        basalMetabolicRate: 1600,
        skeletalMuscleMass: 31.0,
        leanBodyMass: 60.8,
        bodyFatPercentage: 22.0
      ),
      Inbody(
        date: formatter.date(from: "2024-07-12")!,
        weight: 77.6,
        height: 175.0,
        age: 31,
        bodyFatMass: 16.7,
        basalMetabolicRate: 1605,
        skeletalMuscleMass: 31.3,
        leanBodyMass: 61.0,
        bodyFatPercentage: 21.5
      ),
      Inbody(
        date: formatter.date(from: "2024-08-08")!,
        weight: 77.3,
        height: 175.0,
        age: 31,
        bodyFatMass: 16.1,
        basalMetabolicRate: 1610,
        skeletalMuscleMass: 31.5,
        leanBodyMass: 61.3,
        bodyFatPercentage: 21.0
      ),
      Inbody(
        date: formatter.date(from: "2024-09-04")!,
        weight: 77.0,
        height: 175.0,
        age: 31,
        bodyFatMass: 15.5,
        basalMetabolicRate: 1615,
        skeletalMuscleMass: 31.7,
        leanBodyMass: 61.6,
        bodyFatPercentage: 20.5
      ),
      Inbody(
        date: formatter.date(from: "2024-10-10")!,
        weight: 76.6,
        height: 175.0,
        age: 31,
        bodyFatMass: 15.0,
        basalMetabolicRate: 1620,
        skeletalMuscleMass: 31.9,
        leanBodyMass: 62.0,
        bodyFatPercentage: 20.0
      ),
      Inbody(
        date: formatter.date(from: "2024-11-15")!,
        weight: 76.3,
        height: 175.0,
        age: 31,
        bodyFatMass: 14.5,
        basalMetabolicRate: 1625,
        skeletalMuscleMass: 32.0,
        leanBodyMass: 62.2,
        bodyFatPercentage: 19.6
      ),
      Inbody(
        date: formatter.date(from: "2024-12-22")!,
        weight: 75.9,
        height: 175.0,
        age: 31,
        bodyFatMass: 14.0,
        basalMetabolicRate: 1630,
        skeletalMuscleMass: 32.2,
        leanBodyMass: 62.5,
        bodyFatPercentage: 19.1
      ),
      Inbody(
        date: formatter.date(from: "2025-01-19")!,
        weight: 75.6,
        height: 175.0,
        age: 31,
        bodyFatMass: 13.5,
        basalMetabolicRate: 1635,
        skeletalMuscleMass: 32.4,
        leanBodyMass: 62.7,
        bodyFatPercentage: 18.7
      ),
      Inbody(
        date: formatter.date(from: "2025-02-22")!,
        weight: 75.2,
        height: 175.0,
        age: 31,
        bodyFatMass: 13.0,
        basalMetabolicRate: 1640,
        skeletalMuscleMass: 32.6,
        leanBodyMass: 63.0,
        bodyFatPercentage: 18.2
      ),
      Inbody(
        date: formatter.date(from: "2025-03-18")!,
        weight: 74.9,
        height: 175.0,
        age: 31,
        bodyFatMass: 12.5,
        basalMetabolicRate: 1645,
        skeletalMuscleMass: 32.8,
        leanBodyMass: 63.2,
        bodyFatPercentage: 17.8
      ),
      Inbody(
        date: formatter.date(from: "2025-04-24")!,
        weight: 74.6,
        height: 175.0,
        age: 31,
        bodyFatMass: 12.0,
        basalMetabolicRate: 1650,
        skeletalMuscleMass: 33.0,
        leanBodyMass: 63.5,
        bodyFatPercentage: 17.3
      ),
      Inbody(
        date: formatter.date(from: "2025-05-30")!,
        weight: 74.3,
        height: 175.0,
        age: 31,
        bodyFatMass: 11.5,
        basalMetabolicRate: 1655,
        skeletalMuscleMass: 33.2,
        leanBodyMass: 63.7,
        bodyFatPercentage: 16.8
      )
    ]
  }
}

struct InbodyInfoPreview: View {
  var inbody: [Inbody]
  @State private var selectedRange: TimeRange = .threeMonths
  @State private var startDate: Date = Date()
  @State private var endDate: Date = Date()
  @State private var isShowingSheet = false
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        HStack {
          ForEach(TimeRange.allCases) { range in
            Button(action: {
              selectedRange = range
              endDate = Date()
              startDate = range.startDate(endDate: endDate)
              if selectedRange == .custom {
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
          Image(systemName: "xmark")
        }
        .padding(.bottom, 8)
        DatePicker("시작일", selection: $startDate, displayedComponents: [.date])
        DatePicker("종료일", selection: $endDate, displayedComponents: [.date])
        HStack {
          Button(action: {
          }, label: {
            Text("초기화")
              .padding(.vertical, 8)
              .padding(.horizontal, 48)
          })
          .buttonStyle(.bordered)
          
          Spacer()
          
          Button(action: {
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

#Preview {
  InbodyInfoPreview(inbody: Inbody.sampleData)
}
