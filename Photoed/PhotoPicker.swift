//
//  PhotoPicker.swift
//  Photoed
//
//  Created by Beniamin on 25.09.22.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode //needed to dismiss after image was picked
    @Binding var image: UIImage? //chosen photo
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<PhotoPicker>) {
        
    }
    
    func makeCoordinator() -> PhotoPickerCoordinator {
        PhotoPickerCoordinator(self)
    }
}

class PhotoPickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: PhotoPicker
    
    init(_ parent: PhotoPicker) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[.originalImage] as? UIImage {
            parent.image = uiImage
        }
        parent.presentationMode.wrappedValue.dismiss()
    }
}
