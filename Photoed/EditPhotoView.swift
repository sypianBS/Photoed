//
//  EditPhotoView.swift
//  Photoed
//
//  Created by Beniamin on 25.09.22.
//

import SwiftUI

struct EditPhotoView: View {
    @Binding var pickedPhoto: UIImage?
    
    var body: some View {
        if let pickedPhoto = pickedPhoto {
            EditPhotoDetailView(image: pickedPhoto)
        } else {
            Rectangle()
                .fill(.gray)
        }
    }
}
