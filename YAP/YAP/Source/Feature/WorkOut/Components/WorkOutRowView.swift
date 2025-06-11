//
//  WorkOutRowView.swift
//  YAP
//
//  Created by 여성일 on 6/6/25.
//

import SwiftUI

struct WorkOutRowView: View {
  let image: AssetImageString
  let title: String
  let amount: String
}

extension WorkOutRowView {
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(asset: image)
          .resizable()
          .frame(width: 35, height: 35)
        
        VStack(alignment: .leading) {
          Text(title)
            .font(.pretendard(type: .semibold, size: 20))
          
          Text(amount)
            .font(.pretendard(type: .medium, size: 16))
            .foregroundStyle(.main)
        }
      }
    }
  }
}

#Preview {
  WorkOutRowView(image: .benchPress, title: "런닝", amount: "30분")
}
