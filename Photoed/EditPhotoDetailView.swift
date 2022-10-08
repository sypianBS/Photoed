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
    
    @EnvironmentObject var editPhotoViewModel: EditPhotoViewModel
    @State private var showFilterChoiceDialog = false
    @State private var showImageCropper = false
    @State private var cropShapeType: Mantis.CropShapeType = .rect
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .canUseMultiplePresetFixedRatio()
    
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
            }.onChange(of: editPhotoViewModel.state.processedImage, perform: { processedImage in
                self.editPhotoViewModel.state.inputImage = processedImage! //todoben probably just a temporary solution to show updates in the UI
            })
                .confirmationDialog("Choose filter", isPresented: $showFilterChoiceDialog) {
                    dialogViewOptionsView
                }.onDisappear {
                    self.editPhotoViewModel.restoreState()
                }.navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: closeBarButtonView, trailing: saveBarButtonView)
                .fullScreenCover(isPresented: $showImageCropper) {
//                    guard
                    ImageCropper(image: $editPhotoViewModel.state.inputImage, cropShapeType: $cropShapeType, presetFixedRatioType: $presetFixedRatioType)
                }
        } else {
            Rectangle()
                .fill(.gray)
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
    
    var isSaveButtonEnabled: Bool {
        return editPhotoViewModel.state.processedImage != nil
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
            Image(uiImage: self.editPhotoViewModel.state.inputImage)
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

