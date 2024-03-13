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
  
  @Published var username: String = ""
  @Published var user: SocialUser?
  
  var firebaseUser: User? {
    didSet {
      reloadUser()
    }
  }
  
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
  
  func createUser() {
    guard let firebaseUser else { return }
    
    let docRef = Firestore.firestore().collection("User").document(firebaseUser.uid)
    
    let userData: [String: Any] = [
      "username": username
    ]
    
    docRef.setData(userData) { error in
      if let error {
        print(error.localizedDescription)
      } else {
        self.user = SocialUser(id: firebaseUser.uid, username: self.username)
      }
    }
    
    Task {
      await getAllUsers()
    }
    
  }
  
  func reloadUser() {
    guard let firebaseUser else {
      user = nil
      return
    }
    
    let docRef = Firestore.firestore().collection("User").document(firebaseUser.uid)
    
    docRef.getDocument(completion: { snapshot, err in
      
      if let err {
        print(err.localizedDescription)
      }
      
      guard let snapshot else { return }
      
      if !snapshot.exists {
        self.createUser()
        return
      }
      
      guard let snapshotData = snapshot.data() else { return }
      
      self.user = SocialUser.fromDocument(snapshotData, withId: firebaseUser.uid)
    })
  }
  
  func getAllUsers() async -> [SocialUser] {
    let docRef = Firestore.firestore().collection("User")
    
    do {
      let allDocs = try await docRef.getDocuments()
      
      let allUsers: [SocialUser] = allDocs.documents.compactMap({ doc in
        return SocialUser.fromDocument(doc.data(), withId: doc.documentID)
      })
      
      return allUsers
      
    } catch let err {
      print(err.localizedDescription)
      return []
    }
  }
}
