//
//  EditPhotoDetailView.swift
//  Photoed
//
//  Created by Beniamin on 26.09.22.
//

import SwiftUI
import Mantis

struct EditPhotoDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var editPhotoViewModel: PhotoViewModel
    @State private var showFilterChoiceDialog = false
    @State private var showImageCropper = false
    @State private var cropShapeType: Mantis.CropShapeType = .rect
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .canUseMultiplePresetFixedRatio()
    @State private var processedImage: UIImage?
    
    var body: some View {
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
        }.navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    closeBarButtonView
                    
                    undoChangesButtonView
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    saveBarButtonView
                }
            }.fullScreenCover(isPresented: $showImageCropper) {
                ImageCropper(image: $editPhotoViewModel.state.processedImage, cropShapeType: $cropShapeType, presetFixedRatioType: $presetFixedRatioType)
            }
    }
    
    var closeBarButtonView: AnyView {
        return AnyView(
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
            }).buttonStyle(EditPhotoButtonStyle())
        )
    }
    
    var undoChangesButtonView: AnyView {
        return AnyView(
            Button(action: {
                self.editPhotoViewModel.restoreImageChanges()
            }, label: {
                Image(systemName: "arrow.uturn.backward")
                    .foregroundColor(.white)
            }).buttonStyle(EditPhotoButtonStyle())
        )
    }
    
    var isSaveButtonEnabled: Bool { //enable saving only if the image has changed
        return editPhotoViewModel.state.inputImage != editPhotoViewModel.state.processedImage
    }
    
    var saveBarButtonView: AnyView {
        return AnyView(
            Button(action: {
                if let processedImage = editPhotoViewModel.state.processedImage {
                    PhotoSaver().writeToPhotoAlbum(image: processedImage)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }, label: {
                Text("Save")
                    .foregroundColor(isSaveButtonEnabled ? .white : .gray)
            }).disabled(!isSaveButtonEnabled)
        )
    }
    
    var photoView: AnyView {
        return AnyView(
            Image(uiImage: self.editPhotoViewModel.state.processedImage)
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
                Button("Crop", action: {
                    showImageCropper.toggle()
                })
                    .buttonStyle(EditPhotoButtonStyle())
            }
        )
    }
    
    var dialogViewOptionsView: AnyView {
        return AnyView (
            VStack {
                Button("Sepia") {
                    editPhotoViewModel.setFilterType(filterType: .sepiaTone())
                    editPhotoViewModel.applyProcessing()
                }
                Button("Pixellate") { editPhotoViewModel.setFilterType(filterType: .pixellate())
                    editPhotoViewModel.applyProcessing()
                }
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

