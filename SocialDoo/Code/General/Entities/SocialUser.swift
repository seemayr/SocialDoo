//
//  SocialUser.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 13.03.24.
//

import Foundation

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

// MARK: - HASHABLE
extension SocialUser: Hashable {
  func hash(into hasher: inout Hasher) {
    // Hash only the ID of the group:
    // Ensures that the hash value remains stable,
    // regardless of any changes to the group's mutable properties.
    hasher.combine(id)
  }
}

extension SocialUser {
  static func fromDocument(_ doc: [String: Any]?, withId: String) -> SocialUser? {
    guard let doc else { return nil }
    
    let username = (doc["username"] as? String) ?? "No Username"
    let following = (doc["following"] as? [String]) ?? []
    
    return SocialUser(id: withId, username: username, following: following)
  }
}
