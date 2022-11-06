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
    @State private var showImprovementDialog = false
    @State private var showCropShapeChoiceDialog = false
    @State private var showImageCropper = false
    @State private var cropShapeType: Mantis.CropShapeType = .rect
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .canUseMultiplePresetFixedRatio()
    @State private var processedImage: UIImage?
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(spacing: 0) {
                photoView
                editPhotoViewModel.state.isEditingColors ? intensitySliderView.frame(maxWidth: 250, minHeight: 80, maxHeight: 100) : editPhotoFooterView.frame(maxWidth: .infinity, minHeight: 80, maxHeight: 100)
            }
        }.confirmationDialog("Choose filter", isPresented: $showFilterChoiceDialog) {
            dialogViewOptionsView
        }.confirmationDialog("Choose improvement", isPresented: $showImprovementDialog) {
            improvementDialogOptionsView
        }.confirmationDialog("Choose improvement", isPresented: $showCropShapeChoiceDialog) {
            cropShapeChoiceDialogView
        }
        
        .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if editPhotoViewModel.state.isEditingColors {
                        discardColorChangeView
                    } else {
                        closeBarButtonView.padding(.trailing, 16)
                        undoChangesButtonView
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    editPhotoViewModel.state.isEditingColors ? acceptColorChangeView : saveBarButtonView
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
        return editPhotoViewModel.state.originImage != editPhotoViewModel.state.processedImage
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
    
    var acceptColorChangeView: AnyView {
        return AnyView(
            Button(action: {
//                if let processedImage = editPhotoViewModel.state.processedImage {
//                    PhotoSaver().writeToPhotoAlbum(image: processedImage)
//                    self.presentationMode.wrappedValue.dismiss()
//                }
                self.editPhotoViewModel.state.inputImage = self.editPhotoViewModel.state.processedImage
                editPhotoViewModel.restoreFilterIntensity()
            }, label: {
                Text("Apply")
                    .foregroundColor(.white)
            })
        )
    }
    
    var discardColorChangeView: AnyView {
        return AnyView(
            Button(action: {
//                if let processedImage = editPhotoViewModel.state.processedImage {
//                    PhotoSaver().writeToPhotoAlbum(image: processedImage)
//                    self.presentationMode.wrappedValue.dismiss()
//                }
                editPhotoViewModel.restoreFilterIntensity()
            }, label: {
                Text("Discard")
                    .foregroundColor(.white)
            })
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
                Button("Themes", action: {
                    self.showFilterChoiceDialog = true
                }).buttonStyle(EditPhotoButtonStyle())
                Button("Improve", action: {
                    self.showImprovementDialog = true
                }).buttonStyle(EditPhotoButtonStyle())
                Button("Crop", action: {
                    self.showCropShapeChoiceDialog = true
                }).buttonStyle(EditPhotoButtonStyle())
            }
        )
    }
    
    var intensitySliderView: AnyView {
        return AnyView (
            Slider(value: $editPhotoViewModel.state.filterIntensity, in: editPhotoViewModel.rangeForCurrentFilter)
                .onChange(of: editPhotoViewModel.state.filterIntensity) { _ in
                    print(editPhotoViewModel.state.filterIntensity.description)
                    editPhotoViewModel.applyColorProcessing()
                }
        )
    }
    
    var dialogViewOptionsView: AnyView {
        return AnyView (
            VStack {
                Button("Sepia") {
                    editPhotoViewModel.applyProcessing(filterType: .sepiaTone())
                }
                Button("Pixellate") {
                    editPhotoViewModel.applyProcessing(filterType: .pixellate())
                }
                Button("Noir") {
                    editPhotoViewModel.applyProcessing(filterType: .photoEffectNoir())
                }
                Button("Tonal") {
                    editPhotoViewModel.applyProcessing(filterType: .photoEffectTonal())
                }
                Button("Mono") {
                    editPhotoViewModel.applyProcessing(filterType: .photoEffectMono())
                }
                Button("Thermal") {
                    editPhotoViewModel.applyProcessing(filterType: .thermal())
                }
                //cancel button is already provided by default
            }
        )
    }
    
    var improvementDialogOptionsView: AnyView {
        return AnyView (
            VStack {
                Button("Saturation") {
                    editPhotoViewModel.setInitialCorrectionParameters(filterType: .saturation)
                }
                Button("Contrast") {
                        editPhotoViewModel.setInitialCorrectionParameters(filterType: .contrast)
                }
                Button("Brightness") {
                    editPhotoViewModel.setInitialCorrectionParameters(filterType: .brightness)
                }
                
            }
        )
    }
    
    var cropShapeChoiceDialogView: AnyView {
        return AnyView (
            VStack {
                Button("Rectangle") {
                    cropShapeType = .rect
                    showImageCropper = true
                }
                Button("Square") {
                    cropShapeType = .square
                    showImageCropper = true
                }
                Button("Circle") {
                    cropShapeType = .circle()
                    showImageCropper = true
                }
                Button("Heart") {
                    cropShapeType = .heart()
                    showImageCropper = true
                }
                
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

