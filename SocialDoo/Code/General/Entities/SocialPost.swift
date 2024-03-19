//
//  SocialPost.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 19.03.24.
//

import Foundation
import FirebaseFirestore

class SocialPost {
  var postId: String
  var byUserId: String
  
  var createdAt: Date
  var latestModification: Date
  
  var caption: String
  
  var mainImageReference: String?
  
  init(
    postId: String = UUID().uuidString,
    byUserId: String,
    createdAt: Date = Date.now,
    latestModification: Date? = nil,
    caption: String,
    mainImageReference: String? = nil
  ) {
    self.postId = postId
    self.byUserId = byUserId
    self.caption = caption
    self.createdAt = createdAt
    self.latestModification = latestModification ?? createdAt
    self.mainImageReference = mainImageReference
  }
}

extension SocialPost {
  static func fromDocument(_ doc: QueryDocumentSnapshot) -> SocialPost? {
    let documentData = doc.data()
    
    let postId = doc.documentID
    guard let userId = doc["byUserId"] as? String else { return nil }
    guard let caption = doc["caption"] as? String else { return nil }
    guard let createdAt = doc["createdAt"] as? Timestamp else { return nil }
    
    
    let latestModification = doc["latestModification"] as? Timestamp
    let mainImageRef = doc["mainImageReference"] as? String
    
    return SocialPost(
      postId: postId,
      byUserId: userId,
      createdAt: createdAt.dateValue(),
      latestModification: latestModification?.dateValue(),
      caption: caption,
      mainImageReference: mainImageRef
    )
  }
  
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
