//
//  OcrGuideLineView.swift
//  YAP
//
//  Created by 여성일 on 6/2/25.
//

import SwiftUI

struct GuideLineView: View {
  private let cornerLength: CGFloat = 25
  private let lineWidth: CGFloat = 5
  private let color: Color = .main
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.clear.ignoresSafeArea()
        
        Group {
          cornerView
            .position(x: 0, y: 0)
            .offset(x: cornerLength / 2, y: cornerLength / 2)
          
          cornerView
            .rotationEffect(.degrees(90))
            .position(x: geometry.size.width, y: 0)
            .offset(x: -cornerLength / 2, y: cornerLength / 2)
          
          cornerView
            .rotationEffect(.degrees(180))
            .position(x: geometry.size.width, y: geometry.size.height)
            .offset(x: -cornerLength / 2, y: -cornerLength / 2)
          
          cornerView
            .rotationEffect(.degrees(270))
            .position(x: 0, y: geometry.size.height)
            .offset(x: cornerLength / 2, y: -cornerLength / 2)
        }
      }
    }
  }
  
  private var cornerView: some View {
    ZStack(alignment: .topLeading) {
      Rectangle()
        .fill(color)
        .frame(width: cornerLength, height: lineWidth)
      Rectangle()
        .fill(color)
        .frame(width: lineWidth, height: cornerLength)
    }
    .frame(width: cornerLength, height: cornerLength, alignment: .topLeading)
  }
}
