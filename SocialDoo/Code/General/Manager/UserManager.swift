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
  
  var userDocumentReference: DocumentReference? {
    guard let firebaseUser else { return nil }
    return Firestore.firestore().collection("User").document(firebaseUser.uid)
  }
  
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
    guard let userDocumentReference else { return }
    
    let userData: [String: Any] = [
      "username": username
    ]
    
    userDocumentReference.setData(userData) { error in
      if let error {
        print(error.localizedDescription)
      } else {
        self.user = SocialUser(
          id: firebaseUser.uid,
          username: self.username,
          following: []
        )
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
    
    guard let userDocumentReference else { return }
    
    userDocumentReference.getDocument(completion: { snapshot, err in
      
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
  
  func triggerFollow(for userID: String) {
    guard let user else { return }
    guard let userDocumentReference else { return }
    
    if user.following.contains(userID) {
      // FOLLOWING
//      user.following = user.following.filter({ $0 != userID })
      user.following.removeAll(where: { $0 == userID })
    } else {
      // NOT FOLLOWING
      user.following.append(userID)
    }
    
    userDocumentReference.updateData([
      "following": user.following
    ]) { error in
      if let error {
        print(error.localizedDescription)
      }
    }
  }
  
  func createPost(_ post: SocialPost) {
    let postData = post.asDocument()
    let postRef = Firestore.firestore().collection("Post").document(post.postId)
    
    postRef.setData(postData) { error in
      if let error {
        print(error.localizedDescription)
      } else {
        print("POST CREATED")
      }
    }
  }
}
