//
//  CameraManager.swift
//  YAP
//
//  Created by 여성일 on 6/11/25.
//

import AVFoundation
import Vision
import UIKit

final class CameraManager: NSObject {
  let session = AVCaptureSession()
  var captureOnce = false
  
  private let photoOutput = AVCapturePhotoOutput()
  private let videoOutput = AVCaptureVideoDataOutput()
  private let sessionQueue = DispatchQueue(label: "CameraSessionQueue")
  
  private var latestSampleBuffer: CMSampleBuffer?
  
  override init() {
    super.init()
  }
  
  // 카메라 권한 확인 메소드
  func requestAndCheckPermissions() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { [weak self] status in
        if status {
          self?.configureSession()
          print("notDetermined")
        }
      }
      
    case .restricted:
      print("restricted")
      
    case .authorized:
      print("authorized")
      configureSession()
      
    default:
      print("거절")
    }
  }
  
  func startSession() {
    sessionQueue.async {
      if !self.session.isRunning {
        self.session.startRunning()
      }
    }
  }
  
  func stopSession() {
    sessionQueue.async {
      if self.session.isRunning {
        self.session.stopRunning()
      }
    }
  }
  
  func capturedImage() -> UIImage? {
    guard let buffer = latestSampleBuffer else {
      return nil
    }
    return bufferToUIImage(buffer: buffer)
  }
}

// private method
private extension CameraManager {
  // 카메라 세션 설정 메소드
  func configureSession() {
    session.beginConfiguration()
    
    guard let device = AVCaptureDevice.default(for: .video),
          let input = try? AVCaptureDeviceInput(device: device),
          session.canAddInput(input) else {
      print("카메라 초기화 error")
      return
    }
    session.addInput(input)
    
    if session.canAddOutput(videoOutput) {
      videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoOutputQueue"))
      session.addOutput(videoOutput)
    }
    
    if session.canAddOutput(photoOutput) {
      session.addOutput(photoOutput)
    }
    
    session.commitConfiguration()
  }
  
  // 버퍼 -> UIImage 변환 메소드
  func bufferToUIImage(buffer: CMSampleBuffer) -> UIImage? {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else { return nil }
    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
    let context = CIContext()
    
    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
    return UIImage(cgImage: cgImage)
  }
}

// Delegate
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    latestSampleBuffer = sampleBuffer
  }
}
