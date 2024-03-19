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
  
  var body: some View {
    NavigationStack {
      VStack {
        Text("Hi, \(user.username) 🎉")
          .font(.headline)
        
        NavigationLink("AllUsers", destination: {
          UserListView()
        })
        
        NavigationLink("My Todos", destination: {
          TodoListView()
        })
        
        Button("Logout") {
          userManager.logout()
        }
      }
    }
  }
}
