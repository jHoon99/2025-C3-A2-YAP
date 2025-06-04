//
//  ImagePredictor.swift
//  YAP
//
//  Created by Hong on 6/1/25.
//

import UIKit
import Vision

final class ImagePredictor {
  static func createImageClassifier() -> VNCoreMLModel {
    let defaultConfig = MLModelConfiguration()
    
    let imageClassifierWrapper = try? _150classesFood(configuration: defaultConfig)
    
    guard
      let foodClassifier = imageClassifierWrapper
    else {
      fatalError(MLError.failCreateModel.rawValue)
    }
    
    let foodClassifierModel = foodClassifier.model
    
    guard
      let imageClassifierVisionModel = try? VNCoreMLModel(for: foodClassifierModel)
    else {
      fatalError(MLError.failCreateVNCoreMLModel.rawValue)
    }
    
    return imageClassifierVisionModel
  }
  
  static let imageClassifier = createImageClassifier()
  
  struct Prediction: Equatable {
    let classification: String
    let confidencePercentage: String
  }
  
  typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void
  private var predictionHandlers = [VNRequest: ImagePredictionHandler]()
  
  private func createImageClassificationRequest() -> VNImageBasedRequest {
    
    let imageClassificationRequest = VNCoreMLRequest(model: ImagePredictor.imageClassifier,
                                                     completionHandler: visionRequestHandler)
    
    imageClassificationRequest.imageCropAndScaleOption = .centerCrop
    return imageClassificationRequest
  }
  
  func makePredictions(
    for photo: UIImage,
    completionHandler: @escaping ImagePredictionHandler
  ) throws {
    let orientation = CGImagePropertyOrientation(photo.imageOrientation)
    
    guard
      let photoImage = photo.cgImage
    else {
      fatalError(MLError.failTransImageToCGImage.rawValue)
    }
    
    let imageClassificationRequest = createImageClassificationRequest()
    predictionHandlers[imageClassificationRequest] = completionHandler
    
    let handler = VNImageRequestHandler(cgImage: photoImage, orientation: orientation)
    let requests: [VNRequest] = [imageClassificationRequest]
    
    try handler.perform(requests)
  }
  
  private func visionRequestHandler(_ request: VNRequest, error: Error?) {
    guard
      let predicitionHandler = predictionHandlers.removeValue(forKey: request)
    else {
      fatalError(MLError.failVisionHandler.rawValue)
    }
    
    var predicitions: [Prediction]?
    
    defer {
      predicitionHandler(predicitions)
    }
    
    if let error = error {
      print(error.localizedDescription)
      return
    }
    
    if request.results == nil {
      print(MLError.noVisisonResult.rawValue)
    }
    
    guard
      let observations = request.results as? [VNClassificationObservation]
    else { return }
    
    predicitions = observations.map {
      Prediction(classification: $0.identifier, confidencePercentage: String($0.confidence))
    }
  }
}
