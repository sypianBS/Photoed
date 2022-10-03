//
//  EditPhotoDetailView.swift
//  Photoed
//
//  Created by Beniamin on 26.09.22.
//

import SwiftUI

struct EditPhotoDetailView: View {
    @EnvironmentObject var editPhotoViewModel: EditPhotoViewModel
    @State private var showFilterChoiceDialog = false
    @State private var processedImage: UIImage?
    
    var body: some View {
        if editPhotoViewModel.state.inputImage != nil {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    photoView
                    editPhotoFooterView
                        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 100)
                }
            }.confirmationDialog("Choose filter", isPresented: $showFilterChoiceDialog) {
                dialogViewOptionsView
            }
        } else {
            Rectangle()
                .fill(.gray)
        }
    }
    
    var photoView: AnyView {
        return AnyView(
            Image(uiImage: self.editPhotoViewModel.state.inputImage!)
                .resizable()
                .aspectRatio(contentMode: self.editPhotoViewModel.state.contentMode)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .onTapGesture(count: 2) {
                    withAnimation{
                        self.editPhotoViewModel.setContentMode(contentMode: self.editPhotoViewModel.state.contentMode == .fit ? .fill : .fit)
                    }
                } //double tap will toggle between the modes
        )
    }
    
    var editPhotoFooterView: AnyView {
        return AnyView (
            HStack(spacing: 32) {
                Button("Theme", action: {})
                    .buttonStyle(EditPhotoButtonStyle())
                Button("Filter", action: {
                    self.showFilterChoiceDialog = true
                }).buttonStyle(EditPhotoButtonStyle())
                Button("Crop", action: {})
                    .buttonStyle(EditPhotoButtonStyle())
                Button("Save", action: {
                    PhotoSaver().writeToPhotoAlbum(image: editPhotoViewModel.state.inputImage!)
                }).buttonStyle(EditPhotoButtonStyle())
            }
        )
    }
    
    var dialogViewOptionsView: AnyView {
        return AnyView (
            VStack {
                Button("Sepia") { editPhotoViewModel.setFilterType(filterType: .sepiaTone())
                    editPhotoViewModel.applyProcessing()
                }
                Button("Pixellate") { editPhotoViewModel.setFilterType(filterType: .pixellate()) }
                //cancel button is already provided by default
            }
        )
    }
}

struct EditPhotoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.system(size: 16).bold())
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.1 : 1.0)
    }
}

