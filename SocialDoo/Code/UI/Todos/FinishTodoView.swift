//
//  FinishTodoView.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 19.03.24.
//

import PhotosUI
import SwiftUI

struct FinishTodoView: View {
  @EnvironmentObject var router: Router
  @Environment(\.modelContext) var modelContext
  
  let todo: Todo
  
  @State var postText: String = ""
  @State var pickedPhoto: PhotosPickerItem?
  
  var body: some View {
    VStack {
      PhotosPicker("Select Photo", selection: $pickedPhoto)
      TextField("Say something about your todo..", text: $postText)
      
      Button("POST IMAGE") {
        router.popToRoot()
        modelContext.delete(todo)
      }
      .disabled(pickedPhoto == nil)
    }
  }
}
