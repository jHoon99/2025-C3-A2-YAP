//
//  FoodCameraCapture.swift
//  YAP
//
//  Created by Hong on 6/4/25.
//

import SwiftUI
import UIKit

struct FoodCameraCaptureView: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  var onImageCaptured: (UIImage) -> Void

  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: FoodCameraCaptureView

    init(_ parent: FoodCameraCaptureView) {
      self.parent = parent
    }

    func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
      picker.dismiss(animated: true)
      if let image = info[.originalImage] as? UIImage {
        parent.image = image
        parent.onImageCaptured(image)
      }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: true)
    }
  }
}
