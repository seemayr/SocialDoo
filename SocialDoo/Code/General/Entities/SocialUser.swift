//
//  SocialUser.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 13.03.24.
//

import Foundation
import FirebaseFirestore

class SocialUser: ObservableObject, Equatable {
  static func == (lhs: SocialUser, rhs: SocialUser) -> Bool {
    return lhs.id == rhs.id
  }
  
  var id: String
  var username: String
  @Published var following: [String]
  
  init(id: String, username: String, following: [String]) {
    self.id = id
    self.username = username
    self.following = following
  }
}


// MARK: - Firestore Document Convert
extension SocialUser {
  static func fromDocument(_ doc: DocumentSnapshot) -> SocialUser? {
    guard let documentData = doc.data() else { return nil }
    
    let username = documentData["username"] as? String ?? "Unnamed"
    let following = documentData["following"] as? [String] ?? []
    
    return SocialUser(id: doc.documentID, username: username, following: following)
  }
  
  func asDocument() -> [String: Any] {
    let document: [String: Any] = [
      "username": self.username,
      "following": self.following
    ]
    
    return document
  }
}

// MARK: - HASHABLE
extension SocialUser: Hashable {
  func hash(into hasher: inout Hasher) {
    // Hash only the ID of the User:
    // Ensures that the hash value remains stable for the same users,
    // regardless of any changes to the users's mutable properties.
    hasher.combine(id)
  }
}
