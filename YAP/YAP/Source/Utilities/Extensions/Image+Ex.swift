//
//  Image+Ex.swift
//  YAP
//
//  Created by 여성일 on 6/4/25.
//

import SwiftUI

enum AssetImageString: String {
  case celebrate
  case alertIcon
  case healthMan
  case burn
  case benchPress
  case deadLift
  case squat
  case bike
  case rowing
  case running
  case stepmill
}

extension Image {
  init(asset: AssetImageString) {
    self.init(asset.rawValue)
  }
}
