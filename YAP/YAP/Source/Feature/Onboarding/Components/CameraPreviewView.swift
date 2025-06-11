//
//  CameraPreviewView.swift
//  YAP
//
//  Created by 여성일 on 6/11/25.
//

import AVFoundation
import SwiftUI
import UIKit

struct CameraPreviewView: UIViewRepresentable {
  let session: AVCaptureSession
  
  // 비디오 프리뷰 레이어
  class VideoPreviewView: UIView {
    override class var layerClass: AnyClass {
      AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
      guard let layer = self.layer as? AVCaptureVideoPreviewLayer else {
          fatalError("Expected AVCaptureVideoPreviewLayer")
      }
      return layer
    }
  }
  
  func makeUIView(context: Context) -> VideoPreviewView {
    let view = VideoPreviewView()
    
    view.backgroundColor = .black
    view.videoPreviewLayer.session = session
    view.videoPreviewLayer.videoGravity = .resizeAspectFill
    view.videoPreviewLayer.session = session
    return view
  }
  
  func updateUIView(_ uiView: VideoPreviewView, context: Context) {
    uiView.videoPreviewLayer.frame = uiView.bounds
  }
}
