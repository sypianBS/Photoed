//
//  EditPhotoViewModel.swift
//  Photoed
//
//  Created by Beniamin on 03.10.22.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

class EditPhotoViewModel: ObservableObject {
    
    @Published var state: EditPhotoState
    
    let context = CIContext()
    
    init() {
        state = EditPhotoState(currentFilter: CIFilter.sepiaTone())
    }
    
    struct EditPhotoState {
        var inputImage: UIImage?
        var processedImage: UIImage?
        var contentMode: ContentMode = .fit
        var currentFilter: CIFilter
        var filterIntensity = 1.0
    }
    
    func restoreState() {
        self.state = EditPhotoState(currentFilter: CIFilter.sepiaTone())
    }
    
    func setInputPhoto(photo: UIImage) {
        self.state.inputImage = photo
    }
    
    func setContentMode(contentMode: ContentMode) {
        self.state.contentMode = contentMode
    }
    
    func setFilterType(filterType: CIFilter) {
        self.state.currentFilter = filterType
    }

    func applyProcessing() {
        guard let inputImage = self.state.inputImage else { return }

        let beginImage = CIImage(image: inputImage)
        self.state.currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        let inputKeys = self.state.currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { self.state.currentFilter.setValue(self.state.filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { self.state.currentFilter.setValue(self.state.filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { self.state.currentFilter.setValue(self.state.filterIntensity * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = self.state.currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
//            self.state.image = Image(uiImage: uiImage)
            self.state.processedImage = uiImage
        }
    }
}
