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
  
  var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        HStack {
          ForEach(TimeRange.allCases) { range in
            Button(action: {
              selectedRange = range
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
        .padding(16)
        
        BodyCompositionOverview(data: weightSeries)
          .padding(16)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(Color.white)
          )
          .padding(16)
        BodyCompositionOverview(data: bodyFatMassSeries)
          .padding(16)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(Color.white)
          )
          .padding(16)
        BodyCompositionOverview(data: skeletalMuscleMassSeries)
          .padding(16)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(Color.white)
          )
          .padding(16)
        
        Text("기록 보기")
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(16)
        Rectangle()
          .frame(height: 300)
          .padding(16)
      }
      .background(Color("subBackground"))
    }
  }
  
  var weightSeries: Data.Series {
    let measurements = inbody
      .filter { $0.date >= selectedRange.startDate() }
      .map { ($0.date, $0.weight) }
    return Data.Series(name: "체중", measurements: measurements)
  }
  
  var bodyFatMassSeries: Data.Series {
    let measurements = inbody
      .filter { $0.date >= selectedRange.startDate() }
      .map { ($0.date, $0.bodyFatMass) }
    return Data.Series(name: "체지방량", measurements: measurements)
  }
  
  var skeletalMuscleMassSeries: Data.Series {
    let measurements = inbody
      .filter { $0.date >= selectedRange.startDate() }
      .map { ($0.date, $0.skeletalMuscleMass) }
    return Data.Series(name: "골격근량", measurements: measurements)
  }
}

enum TimeRange: String, CaseIterable, Identifiable {
  case threeMonths = "3개월"
  case sixMonths = "6개월"
  case oneYear = "1년"
  
  var id: String { rawValue }
  
  func startDate(relativeTo endDate: Date = Date(), calendar: Calendar = .current) -> Date {
    switch self {
    case .threeMonths:
      return calendar.date(byAdding: .month, value: -3, to: endDate)!
    case .sixMonths:
      return calendar.date(byAdding: .month, value: -6, to: endDate)!
    case .oneYear:
      return calendar.date(byAdding: .year, value: -1, to: endDate)!
    }
  }
}

#Preview {
  InbodyInfoView()
}
