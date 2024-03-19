//
//  FinishTodoView.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 19.03.24.
//

import PhotosUI
import SwiftUI
import FirebaseStorage

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
  @EnvironmentObject var user: SocialUser
  @EnvironmentObject var userManager: UserManager
  
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
        
        Button("POST") {
          uploadImage(pickedImage) { path in
            self.pickedImage = nil
            
            let post = SocialPost(
              byUserId: user.id,
              caption: todo.caption,
              mainImageReference: path
            )
            
            userManager.createPost(post)
          }
        }
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
  
  func uploadImage(_ image: UIImage, onFinished: @escaping  (String) -> Void) {
    image.prepareThumbnail(of: CGSize(width: 400, height: 400), completionHandler: { compressedImage in
      
      guard let compressedImage, let jpegImage = compressedImage.jpegData(compressionQuality: 0.8) else { return }
      
      let imageFilename = "\(UUID().uuidString).jpg"
      
      let imageRef = Storage.storage().reference().child("User/\(user.id)/Posts/\(imageFilename)")
        
      imageRef.putData(jpegImage) { metadata, error in
        if let error {
          print(error.localizedDescription)
        }
        
        guard let metadata else { return }
        
        onFinished(imageFilename)
        print("UPLOAD SUCCESS")
      }
      
    })
  }
}
