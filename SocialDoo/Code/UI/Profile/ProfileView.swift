//
//  ProfileView.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 13.03.24.
//

import SwiftUI

struct ProfileView: View {
  @EnvironmentObject var user: SocialUser
  @EnvironmentObject var userManager: UserManager
  let profileUser: SocialUser
  
  var body: some View {
    VStack {
      Text(profileUser.username)
      Text(profileUser.id)
      
      Button(user.following.contains(profileUser.id) ? "Unfollow" : "Follow") {
        userManager.triggerFollow(for: profileUser.id)
      }
    }
  }
}
