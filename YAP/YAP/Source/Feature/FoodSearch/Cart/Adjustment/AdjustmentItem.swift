//
//  AdjustmentItem.swift
//  YAP
//
//  Created by 조재훈 on 6/6/25.
//

import Foundation

struct AdjustmentItem: Identifiable {
  var id: UUID = UUID()
  var type: AdjustmentType
  var amount: Int
}
