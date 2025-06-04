//
//  DateSelectionView.swift
//  YAP
//
//  Created by 조운경 on 6/2/25.
//

import SwiftUI

struct DateSelectionView: View {
  @Binding var selectedDate: Date
  @Binding var showDatePicker: Bool

  var body: some View {
    HStack {
      Text(formattedShortDate(date: selectedDate))
        .font(.title3).bold()
      Button(action: {
        showDatePicker = true
      }, label: {
        Image(systemName: "chevron.down")
          .font(.subheadline).bold()
          .foregroundColor(.gray)
      })
      Spacer()
    }
    .padding(.horizontal)
  }
  
  func formattedShortDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM.dd"
    return formatter.string(from: date)
  }
}

#Preview {
  DateSelectionView(selectedDate: .constant(Date()), showDatePicker: .constant(false))
}
