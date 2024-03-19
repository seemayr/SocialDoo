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
  @State var allPosts: [SocialPost] = []
  
  var body: some View {
    ScrollView {
      VStack {
        Text("POST COUNT \(allPosts.count)")
        
        ForEach(allPosts, id: \.postId) { post in
          PostView(post: post)
        }
      }
    }
    .task {
      await reloadAllPosts()
    }
  }
  
  @State var snapShotListener: ListenerRegistration?
  func reloadAllPosts() async {
    var postsBy: [String] = user.following
    postsBy.append(user.id)
    
    let collRef = Firestore.firestore().collection("Post")
      .whereField("byUserId", in: postsBy)
    
    snapShotListener = collRef.addSnapshotListener({ snapshot, error in
      guard let allDocs = snapshot?.documents else { return }
      self.allPosts = allDocs.compactMap({ SocialPost.fromDocument($0) })
    })
    
//    do {
//      let allDocs = try await collRef.getDocuments()
//      
//      self.allPosts = allDocs.documents.compactMap({ SocialPost.fromDocument($0) })
//      
//    } catch let error {
//      print(error.localizedDescription)
//    }
    
  }
}

struct PostView: View {
  let post: SocialPost
  
  @State var todoImage: UIImage?
  
  var body: some View {
    VStack {
      Text(post.byUserId)
        .font(.footnote)
      
      if let todoImage {
        Image(uiImage: todoImage)
          .resizable()
          .scaledToFit()
          .frame(width: 200, height: 200)
      }
      
      Text(post.caption)
      
      Text(post.createdAt.formatted())
        .font(.footnote)
    }
    .padding(8)
    .background(.gray)
    .task {
      await fetchImage()
    }
  }
  
  func fetchImage() async {
    guard let imageReference = post.mainImageReference else { return }
    
    let imageRef = Storage.storage().reference().child("User/\(post.byUserId)/Posts/\(imageReference)")
    
    imageRef.getData(maxSize: .max, completion: { data, error in
      if let error {
        print(error.localizedDescription)
      }

      guard let data else { return }
      let postImage = UIImage(data: data)
      
      todoImage = postImage
    })
    
  }
}
