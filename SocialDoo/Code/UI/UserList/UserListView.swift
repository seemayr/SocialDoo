//
//  UserListView.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 13.03.24.
//

import SwiftUI

struct UserListView: View {
  @EnvironmentObject var userManager: UserManager
  @State var allUsers: [SocialUser] = []
  
  var body: some View {
    VStack {
      List(allUsers, id: \.id) { user in
        NavigationLink(user.username, destination: {
          ProfileView(profileUser: user)
        })
      }
    }
    .task {
      allUsers = await userManager.getAllUsers()
    }
  }
}
