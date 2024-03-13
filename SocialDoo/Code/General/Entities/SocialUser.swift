//
//  SocialUser.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 13.03.24.
//

import Foundation

class SocialUser: ObservableObject {
  var id: String
  var username: String
  @Published var following: [String]
  
  init(id: String, username: String, following: [String]) {
    self.id = id
    self.username = username
    self.following = following
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
