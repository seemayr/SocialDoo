//
//  PostView.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 20.03.24.
//

import SwiftUI
import FirebaseStorage

struct PostView: View {
  let post: SocialPost
  
  @State var loadedTodoImage: UIImage?
  
  var body: some View {
    VStack {
      Text(post.byUserId)
        .font(.footnote)
      
      if let loadedTodoImage {
        Image(uiImage: loadedTodoImage)
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
    .onChange(of: post.mainImageReference, initial: true) {
      reloadImage()
    }
  }
  
  func reloadImage() {
    guard let imageReference = post.mainImageReference else { return }
    
    let imageRef = Storage.storage().reference().child("User/\(post.byUserId)/Posts/\(imageReference)")
    
    imageRef.getData(maxSize: .max, completion: { data, error in
      if let error {
        print(error.localizedDescription)
      }
      
      guard let data else { return }
      loadedTodoImage = UIImage(data: data)
    })
    
  }
}
