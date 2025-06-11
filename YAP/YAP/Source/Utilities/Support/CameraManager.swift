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
  private var isSessionConfigured = false

  override init() {
    super.init()
  }

  func requestAndCheckPermissions() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
        if granted {
          self?.configureSessionIfNeeded()
        } else {
          print("사용자가 카메라 접근을 거부했습니다.")
        }
      }

    case .authorized:
      configureSessionIfNeeded()

    case .restricted, .denied:
      print("카메라 접근이 제한되었거나 거부됨")

    @unknown default:
      print("알 수 없는 권한 상태")
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

private extension CameraManager {
  func configureSessionIfNeeded() {
    guard !isSessionConfigured else {
      print("이미 세션이 구성되어 있음")
      return
    }
    isSessionConfigured = true
    configureSession()
  }

  func configureSession() {
    session.beginConfiguration()

    // 입력 설정
    guard let device = AVCaptureDevice.default(for: .video),
          let input = try? AVCaptureDeviceInput(device: device),
          session.canAddInput(input) else {
      print("카메라 입력 설정 실패")
      session.commitConfiguration()
      return
    }
    session.addInput(input)

    // 비디오 출력 설정
    if session.canAddOutput(videoOutput) {
      videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoOutputQueue"))
      session.addOutput(videoOutput)
    }

    // 사진 출력 설정
    if session.canAddOutput(photoOutput) {
      session.addOutput(photoOutput)
    }

    session.commitConfiguration()
  }

  func bufferToUIImage(buffer: CMSampleBuffer) -> UIImage? {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else { return nil }
    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
    let context = CIContext()

    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
    return UIImage(cgImage: cgImage)
  }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    latestSampleBuffer = sampleBuffer
  }
}
