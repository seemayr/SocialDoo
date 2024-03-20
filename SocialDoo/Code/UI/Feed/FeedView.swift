//
//  FeedView.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 19.03.24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct FeedView: View {
  @EnvironmentObject var user: SocialUser
  @StateObject var feedViewModel = FeedViewModel()
  
  var body: some View {
    ScrollView {
      VStack {
        Text("POST COUNT \(feedViewModel.allPosts.count)")
        
        ForEach(feedViewModel.allPosts, id: \.postId) { post in
          PostView(post: post)
        }
      }
    }
    .onChange(of: user.following, initial: true) {
      var feedUsers = user.following
      feedUsers.append(user.id)
      
      feedViewModel.restartFeedListener(forUsers: feedUsers)
    }
  }
}


