//
//  SocialPost.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 19.03.24.
//

import Foundation
import FirebaseFirestore

class SocialPost {
  var postId: String = UUID().uuidString
  var byUserId: String
  
  var createdAt: Date
  var latestModification: Date
  
  var caption: String
  
  var mainImageReference: String?
  
  init(byUserId: String, createdAt: Date = Date.now, caption: String, mainImageReference: String? = nil) {
    self.byUserId = byUserId
    self.caption = caption
    self.createdAt = createdAt
    self.latestModification = createdAt
    self.mainImageReference = mainImageReference
  }
}

extension SocialPost {
  func asDocument() -> [String: Any] {
    var document: [String: Any] = [
      "byUserId": byUserId,
      "createdAt": Timestamp(date: createdAt),
      "latestModification": Timestamp(date: latestModification),
      "caption": caption
    ]
    
    if let mainImageReference {
      document["mainImageReference"] = mainImageReference
    }
    
    return document
  }
}
