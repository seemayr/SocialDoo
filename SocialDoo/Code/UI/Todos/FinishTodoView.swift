//
//  FinishTodoView.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 19.03.24.
//

import PhotosUI
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
  @Binding var selectedImage: UIImage?
  
  typealias UIViewControllerType = UIImagePickerController
  
  func makeUIViewController(context: Context) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.delegate = context.coordinator
    return imagePicker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
  
  func makeCoordinator() -> CameraView.CameraViewDelegate {
    return CameraViewDelegate(cameraView: self)
  }
  
  class CameraViewDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var cameraView: CameraView
    init(cameraView: CameraView) {
      self.cameraView = cameraView
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      let pickedImage = info[.originalImage] as? UIImage
      cameraView.selectedImage = pickedImage
    }
  }
}

struct FinishTodoView: View {
  @EnvironmentObject var router: Router
  @Environment(\.modelContext) var modelContext
  
  let todo: Todo
  
  @State var pickedImage: UIImage?
  
  @State var postText: String = ""
  @State var showCamera = false
  
  var body: some View {
    VStack {
      TextField("Say something about your todo..", text: $postText)
      
      Button("POST IMAGE") {
        showCamera = true
      }
      
      if let pickedImage {
        Image(uiImage: pickedImage)
          .resizable()
          .scaledToFit()
          .frame(width: 200, height: 200)
      }
    }
    .onChange(of: pickedImage) {
      showCamera = false
    }
    .fullScreenCover(isPresented: $showCamera, content: {
      CameraView(selectedImage: $pickedImage)
        .background(Color.black)
    })
  }
}
