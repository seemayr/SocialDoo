//
//  FeedViewModel.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 20.03.24.
//

import SwiftUI
import FirebaseFirestore

class FeedViewModel: ObservableObject {
  @Published var allPosts: [SocialPost] = []
  
  var feedListener: ListenerRegistration?
  func restartFeedListener(forUsers: [String]) {
    let collRef = Firestore.firestore().collection("Post")
      .whereField("byUserId", in: forUsers)
      .order(by: "createdAt", descending: true)
    
    feedListener = collRef.addSnapshotListener({ snapshot, error in
      guard let allDocs = snapshot?.documents else { return }
      self.allPosts = allDocs.compactMap({ SocialPost.fromDocument($0) })
    })
  }
}
