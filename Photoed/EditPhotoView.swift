//
//  EditPhotoView.swift
//  Photoed
//
//  Created by Beniamin on 25.09.22.
//

import SwiftUI

struct EditPhotoView: View {
    @EnvironmentObject var editPhotoViewModel: EditPhotoViewModel
    
    var body: some View {
        if editPhotoViewModel.state.inputImage != nil {
            EditPhotoDetailView()
        } else {
            Rectangle()
                .fill(.gray)
        }
    }
}
