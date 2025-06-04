//
//  CameraView.swift
//  YAP
//
//  Created by Hong on 6/1/25.
//

import SwiftUI
import UIKit

struct FoodCameraView {
  private var handler = ImagePredictionHandler()
  @State private var selectedImage: UIImage?
  @State private var showCamera = false
}

extension FoodCameraView: View {
  var body: some View {
    VStack(spacing: 20) {
      Button {
        showCamera = true
      } label: {
        Image(systemName: Icon.camera.name)
          .imageScale(.large)
          .fontWeight(.semibold)
          .foregroundStyle(.subBackground)
          .padding()
      }
      .background(Color.main)
      .clipShape(.circle)
      .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))
    }
    .sheet(isPresented: $showCamera) {
      FoodCameraCaptureView(image: $selectedImage) { image in
        selectedImage = image
        handler.classify(image: image)
      }
      .ignoresSafeArea(edges: .bottom)
    }
  }
}

#Preview {
  FoodCameraView()
}
