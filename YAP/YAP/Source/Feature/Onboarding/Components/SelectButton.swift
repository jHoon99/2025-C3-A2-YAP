//
//  GoalButton.swift
//  YAP
//
//  Created by 여성일 on 6/3/25.
//

import SwiftUI

public struct SelectButton: View {
  let title: String
  let caption: String
  let isSelected: Bool
  let action: () -> Void
  
  public init(
    title: String,
    caption: String = "",
    isSelected: Bool = false,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.caption = caption
    self.isSelected = isSelected
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      VStack(alignment: .leading, spacing: Spacing.small) {
        HStack {
          Text(title)
            .font(.pretendard(type: .semibold, size: 18))
            .foregroundStyle(.text)
          
          Spacer()
        }
        
        if !caption.isEmpty {
          Text(caption)
            .font(.pretendard(type: .medium, size: 12))
            .foregroundStyle(.subText)
        }
      }
      .padding(.leading, Spacing.medium)
      .contentShape(Rectangle())
    }
    .frame(maxWidth: .infinity)
    .frame(height: 84)
    .background(isSelected ? .main.opacity(0.13) : .white)
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(isSelected ? .main : Color.placeholder, lineWidth: 1)
    )
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .buttonStyle(.plain)
  }
}

#Preview {
  SelectButton(title: "체중 감량", caption: "") { }
}
