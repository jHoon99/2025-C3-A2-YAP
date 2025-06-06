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
}

extension WorkOutRowView {
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(asset: image)
          .resizable()
          .frame(width: 50, height: 50)
        
        VStack(alignment: .leading) {
          Text(title)
            .font(.pretendard(type: .semibold, size: 20))
          
          Text("30분")
            .font(.pretendard(type: .medium, size: 16))
            .foregroundStyle(.main)
        }
      }
      
//      if !isLast {
//        Rectangle()
//          .frame(height: 1)
//          .foregroundStyle(.darker)
//      }
    }
  }
}

#Preview {
  WorkOutRowView(image: .benchPress, title: "런닝")
}
