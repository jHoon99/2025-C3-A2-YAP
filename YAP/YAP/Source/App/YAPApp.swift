//
//  YAPApp.swift
//  YAP
//
//  Created by 여성일 on 5/28/25.
//

import SwiftData
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    AppCheckManager.shared.setProviderFactory()
    FirebaseApp.configure()

    return true
  }
}

@main
struct YAPApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  var yapModelContainer: ModelContainer = {
    let schema = Schema([
      Inbody.self,
      CalorieRequirements.self,
      ActivityInfo.self,
      Meal.self,
      Menu.self,
      CalorieToBurn.self
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
