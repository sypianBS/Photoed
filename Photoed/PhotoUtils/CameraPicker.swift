//
//  CameraPicker.swift
//  Photoed
//
//  Created by Beniamin on 11.10.22.
//

import Foundation
import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage? //made photo
    
    func makeUIViewController(context: Context) -> some UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> CameraPickerCoordinator {
        CameraPickerCoordinator(self)
    }
    
    class CameraPickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            guard let image = info[.editedImage] as? UIImage else {
                return
            }
            parent.image = image
        }
    }
}
