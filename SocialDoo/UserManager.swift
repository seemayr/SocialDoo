//
//  UserManager.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 12.03.24.
//

import Foundation
import Firebase

class UserManager: ObservableObject {
  public static let shared = UserManager()
  private init() {
    activateAuthListener()
  }
  
  @Published var user: SocialUser?
  
  var firebaseUser: User? {
    didSet {
      reloadUser()
    }
  }
  
  @Published var username: String = ""
  
  func activateAuthListener() {
    Auth.auth().addStateDidChangeListener { auth, user in
      self.firebaseUser = user
    }
  }
  
  func loginAnonym() {
    Auth.auth().signInAnonymously { (authResult, error) in
      
      if let error {
        print(error.localizedDescription)
      }
      
      print(authResult?.user.uid ?? "No UserID")
    }
  }
  
  func logout() {
    try? Auth.auth().signOut()
  }
  
  func reloadUser() {
    guard let firebaseUser else {
      user = nil
      return
    }
    
    let docRef = Firestore.firestore().collection("User").document(firebaseUser.uid)
    
    docRef.getDocument(completion: { snapshot, err in
      
    })
  }
}
