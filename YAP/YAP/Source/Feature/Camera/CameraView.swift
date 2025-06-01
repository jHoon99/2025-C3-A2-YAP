//
//  CameraView.swift
//  YAP
//
//  Created by 여성일 on 6/1/25.
//

import AVFoundation
import SwiftUI

struct CameraView: View {
    @State private var isAuthorized = false
    @State private var showCamera = false

    var body: some View {
        VStack {
            if isAuthorized {
                Text("카메라 시작 가능")
                // 실제 카메라 뷰 넣기
            } else {
                Text("카메라 권한이 필요해요")
                Button("권한 요청하기") {
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        DispatchQueue.main.async {
                            isAuthorized = granted
                        }
                    }
                }
            }
        }
        .onAppear {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            isAuthorized = (status == .authorized)
        }
    }
}
