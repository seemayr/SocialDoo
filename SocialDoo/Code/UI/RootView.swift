//
//  RootView.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 13.03.24.
//

import SwiftUI

struct RootView: View {
  @EnvironmentObject var user: SocialUser
  @EnvironmentObject var userManager: UserManager
  
  @Environment(AdManager.self) var adManager
  
  var body: some View {
    StackRouter() {
      VStack {
        Text("Hi, \(user.username) 🎉")
          .font(.headline)
        
        NavigationLink(value: Router.Destination.userList, label: {
          Text("All Users")
        })
        
        Text("SETUP: \(adManager.setupDone) - Interstitla Loaded: \(adManager.interstitial != nil)")
        Button("SHOW INTERSTITIAL") {
          adManager.showInterstitial()
        }
        
        NavigationLink(value: Router.Destination.feedView, label: {
          Text("FEED")
        })
        
        NavigationLink(value: Router.Destination.todoList, label: {
          Text("Todo List")
        })
        
        Button("Logout") {
          userManager.logout()
        }
      }
    }
  }
}
