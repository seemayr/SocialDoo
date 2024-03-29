//
//  OnboardingView.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 13.03.24.
//

import SwiftUI

struct OnboardingView: View {
  @EnvironmentObject var userManager: UserManager
  
  @State var currentPageIndex: Int = 0
  
  var body: some View {
    TabView(selection: $currentPageIndex) {
      welcomePage.tag(0)
      explainPage.tag(1)
      setNamePage.tag(2)
      loginPage.tag(3)
    }
    .tabViewStyle(.page)
    .indexViewStyle(.page)
  }
  
  var welcomePage: some View {
    VStack {
      Text("Welcome 👋")
      Button("Next") { nextPage() }
    }
  }
  
  var explainPage: some View {
    VStack {
      Text("TODOs with your friends ✅")
      Button("Okay!") { nextPage() }
    }
  }
  
  var setNamePage: some View {
    VStack {
      Text("How do your friends call you?")
      
      TextField("Your Name", text: $userManager.username)
        .frame(maxWidth: 300)
        .padding(8)
        .background(Color.black.opacity(0.1))
        .cornerRadius(8)
      
      Button("Okay!") { nextPage() }
        .disabled(userManager.username.isEmpty)
    }
  }
  
  var loginPage: some View {
    VStack {
      Text("Last Slide :)")
      Button("LOGIN") {
        userManager.loginAnonym()
      }
    }
  }
  
  func nextPage() {
    currentPageIndex += 1
  }
}
