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
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
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
                editPhotoFooterView
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 100)
            }
        }.confirmationDialog("Choose filter", isPresented: $showFilterChoiceDialog) {
            Button("Sepia") { editPhotoViewModel.setFilterType(filterType: .sepiaTone())
                editPhotoViewModel.applyProcessing()
            }
            Button("Pixellate") { editPhotoViewModel.setFilterType(filterType: .pixellate()) }
            //cancel button is already provided by default
        }
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
}

struct EditPhotoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.system(size: 16).bold())
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.1 : 1.0)
    }
}

