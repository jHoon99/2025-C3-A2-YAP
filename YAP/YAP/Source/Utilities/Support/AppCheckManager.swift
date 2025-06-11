//
//  AppCheckManager.swift
//  YAP
//
//  Created by 여성일 on 6/11/25.
//


import Firebase
import FirebaseAppCheck
 
final class AppCheckManager: NSObject, AppCheckProviderFactory {
 
  public static let shared = AppCheckManager()
 
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    return AppAttestProvider(app: app)
  }
 
  public func setProviderFactory() {
#if DEBUG
     AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
#else
    AppCheck.setAppCheckProviderFactory(self)
#endif
  }
}

