//
//  SocialDooApp.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 12.03.24.
//

import SwiftUI
import Firebase

@main
struct SocialDooApp: App {
  
  init() {
    FirebaseApp.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
