//
//  MLError.swift
//  YAP
//
//  Created by Hong on 6/4/25.
//

enum MLError: String {
  case failCreateModel = "모델 생성 실패"
  case failCreateVNCoreMLModel = "VNCoreMLModel생성 실패"
  case failTransImageToCGImage = "사진이 CGImage로 변환 실패"
  case failVisionHandler = "예측 핸들러 실패"
  case noVisisonResult = "비전 요청을 했지만 결과 없음"
}
