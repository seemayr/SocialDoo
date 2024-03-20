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

// MARK: - Firestore Document Convert
extension SocialPost {
  static func fromDocument(_ doc: DocumentSnapshot) -> SocialPost? {
    guard let documentData = doc.data() else { return nil }
    
    let postId = doc.documentID
    guard let userId = documentData["byUserId"] as? String else { return nil }
    guard let caption = documentData["caption"] as? String else { return nil }
    guard let createdAt = documentData["createdAt"] as? Timestamp else { return nil }
    
    
    let latestModification = documentData["latestModification"] as? Timestamp
    let mainImageRef = documentData["mainImageReference"] as? String
    
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
