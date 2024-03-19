//
//  SocialDooApp.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 12.03.24.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct SocialDooApp: App {
  @StateObject var userManager = UserManager.shared
  
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
    .modelContainer(for: [Todo.self])
  }
}
