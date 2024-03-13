//
//  RootView.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 13.03.24.
//

import SwiftUI

struct RootView: View {
  @EnvironmentObject var userManager: UserManager
  
  var body: some View {
    VStack {
      Text("Hi, \(userManager.user?.username ?? "NO USER NAME") 🎉")
        .font(.headline)
    }
  }
}
