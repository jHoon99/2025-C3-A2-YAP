//
//  CharacterRenderView.swift
//  YAP
//
//  Created by 여성일 on 6/12/25.
//

import SceneKit
import SwiftUI

struct CharacterRenderView: UIViewRepresentable {
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        
        if let scene = try? SCNScene(named: "character.usdc") {
            sceneView.scene = scene
        } else {
            print("모델을 불러올 수 없습니다.")
        }
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = false
        sceneView.backgroundColor = .clear
        
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) { }
}
