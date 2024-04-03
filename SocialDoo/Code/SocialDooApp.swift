//
//  SocialDooApp.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 12.03.24.
//

import SwiftUI
import SwiftData
import Firebase
import GoogleMobileAds

@main
struct SocialDooApp: App {
  @StateObject var userManager = UserManager.shared
  @State var adManager = AdManager.shared
  
  init() {
    FirebaseApp.configure()
    
    
  }
  
  var body: some Scene {
    WindowGroup {
      if let user = userManager.user {
        RootView()
          .environmentObject(user)
      } else {
        OnboardingView()
      }
    }
    .environmentObject(userManager)
    .environment(adManager)
    
    .modelContainer(for: [Todo.self])
  }
}
