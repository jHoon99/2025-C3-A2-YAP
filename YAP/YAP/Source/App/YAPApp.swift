//
//  YAPApp.swift
//  YAP
//
//  Created by 여성일 on 5/28/25.
//

import SwiftData
import SwiftUI

@main
struct YAPApp: App {
  var yapModelContainer: ModelContainer = {
    let schema = Schema([
      Inbody.self,
      CalorieRequirements.self,
      ActivityInfo.self
    ])
    
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [configuration])
    } catch {
      fatalError("ModelContainer err")
    }
  }()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(yapModelContainer)
  }
}
