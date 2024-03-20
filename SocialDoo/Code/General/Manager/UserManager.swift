//
//  UserManager.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 12.03.24.
//

import Foundation
import Firebase
import FirebaseStorage

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
}

// MARK: - FIREBASE AUTH (LOGIN / LOGOUT)
extension UserManager {
  /// Start listening to Firebase Auth if the current Authentication changes.
  /// The "AuthState" will change after every login, logout or auto-login after appstart.
  func activateAuthListener() {
    Auth.auth().addStateDidChangeListener { auth, user in
      self.firebaseUser = user
    }
  }
  
  /// Log into a new (anonym) firebaseUser
  /// A new User-ID will be created for this device and kept until logout or app-remove
  func loginAnonym() {
    Auth.auth().signInAnonymously { (authResult, error) in
      
      if let error {
        print(error.localizedDescription)
      }
      
      print(authResult?.user.uid ?? "No UserID")
    }
  }
  
  /// Logging out the current firebaseUser
  func logout() {
    try? Auth.auth().signOut()
  }
}

// MARK: - USERS
extension UserManager {
  /// Takes the current logged in `firebaseUser` ID and loads the corresponding SocialUser Object from Firebase into `user`
  func reloadUser() {
    if firebaseUser == nil { user = nil; return }
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
      
      self.user = SocialUser.fromDocument(snapshot)
    })
  }
  
  /// Creates a new Firestore User Document for the current logged in `firebaseUser`
  func createUser() {
    guard let firebaseUser else { return }
    guard let userDocumentReference else { return }
    
    let userObj = SocialUser(
      id: firebaseUser.uid,
      username: self.username,
      following: []
    )
    
    userDocumentReference.setData(userObj.asDocument()) { error in
      if let error {
        print(error.localizedDescription)
        return
      }
      
      self.user = userObj
    }
  }
  
  /// Returns all SocialUsers from Firebase. Using the "new" async/await pattern as example.
  func getAllUsers() async -> [SocialUser] {
    let docRef = Firestore.firestore().collection("User")
    
    do {
      let allDocs = try await docRef.getDocuments()
      
      let allUsers: [SocialUser] = allDocs.documents.compactMap({ doc in
        return SocialUser.fromDocument(doc)
      })
      
      return allUsers
      
    } catch let err {
      print(err.localizedDescription)
      return []
    }
  }
  
  /// Triggers an Un/Follow for a given userID using the current user.
  func triggerFollow(for userID: String) {
    guard let user else { return }
    guard let userDocumentReference else { return }
    
    // Can't follow yourself:
    guard userID != user.id else { return }
    
    if user.following.contains(userID) {
      // user.following = user.following.filter({ $0 != userID })
      user.following.removeAll(where: { $0 == userID })
    } else {
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
}

// MARK: - POSTS
extension UserManager {
  /// Uploads an Image in current Users /Posts directory. Return: the used filename.
  func uploadPostImage(_ image: UIImage, onFinished: @escaping  (String?) -> Void) {
    guard let user else { onFinished(nil); return }
    
    image.prepareThumbnail(of: CGSize(width: 400, height: 400), completionHandler: { compressedImage in
      
      guard let compressedImage, let jpegImage = compressedImage.jpegData(compressionQuality: 0.8) else {
        onFinished(nil)
        return
      }
      
      let imageFilename = "\(UUID().uuidString).jpg"
      
      let imageRef = Storage.storage().reference().child("User/\(user.id)/Posts/\(imageFilename)")
      
      imageRef.putData(jpegImage) { metadata, error in
        if let error {
          print(error.localizedDescription)
        }
        
        guard metadata != nil else {
          // No metadata for the image returned;
          // Something went wrong.
          
          onFinished(nil)
          return
        }
        
        print("IMAGE UPLOAD SUCCESS")
        
        // We could also use metadata.name instead of imageFilename
        onFinished(imageFilename)
      }
    })
  }
  
  /// Creates a new SocialPost Document in Firestore for current User
  func createPost(_ post: SocialPost) {
    let postData = post.asDocument()
    let postRef = Firestore.firestore().collection("Post").document(post.postId)
    
    postRef.setData(postData) { error in
      if let error {
        print(error.localizedDescription)
        return
      }
      
      print("POST CREATED")
    }
  }
}
