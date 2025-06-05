//
//  CameraViewModel.swift
//  YAP
//
//  Created by Hong on 6/1/25.
//

import SwiftUI

@Observable
final class ImagePredictionHandler {
  var predictions: [ImagePredictor.Prediction] = []
  var errorMessage: String?
  
  private let predictor = ImagePredictor()
  
  func classify(image: UIImage) {
    errorMessage = nil
    predictions = []
    
    do {
      try predictor.makePredictions(for: image) { [weak self] result in
        guard let self else { return }
        DispatchQueue.main.async {
          self.predictions = result ?? []
        }
      }
    } catch {
      DispatchQueue.main.async {
        self.errorMessage = error.localizedDescription
      }
    }
  }
}
