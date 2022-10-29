//
//  PhotoViewModel.swift
//  Photoed
//
//  Created by Beniamin on 03.10.22.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

class PhotoViewModel: ObservableObject {
    
    @Published var state: PhotoState
    
    static let shared = PhotoViewModel()
    
    let context = CIContext()
    
    private init() {
        state = PhotoState(currentFilter: CIFilter.sepiaTone())
    }
    
    struct PhotoState {
        var inputImage: UIImage!
        var processedImage: UIImage!
        var contentMode: ContentMode = .fit
        var currentFilter: CIFilter
        var filterIntensity = 1.0
        var isEditingColors = false
        var filterType: FilterType = .saturation
    }
    
    func restoreImageChanges() {
        self.state.processedImage = self.state.inputImage
    }
    
    func setInputPhoto(photo: UIImage) {
        self.state.inputImage = photo
        self.state.processedImage = photo //initial value equal to the input image
    }
    
    func setContentMode(contentMode: ContentMode) {
        self.state.contentMode = contentMode
    }
    
    func setFilterType(filterType: CIFilter) {
        self.state.currentFilter = filterType
    }
    
    var rangeForCurentFilter: ClosedRange<Double> {
        switch state.filterType {
        case .saturation:
            return FilterSaturation.saturationRange
        }
    }
    
    func restoreFilterIntensity() {
        self.state.isEditingColors = false
        self.state.filterIntensity = 0.5
    }
    
    func applyColorProcessing() {
        self.state.currentFilter = CIFilter(name: "CIColorControls")!
        
        let beginImage = CIImage(image: self.state.inputImage) //one sets values relative to the input image
        self.state.currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        let inputKeys = self.state.currentFilter.inputKeys
        
        //To calculate saturation, this filter linearly interpolates between a grayscale image (saturation = 0.0) and the original image (saturation = 1.0). The filter supports extrapolation: For values large than 1.0, it increases saturation
        if inputKeys.contains(kCIInputSaturationKey) { self.state.currentFilter.setValue(self.state.filterIntensity, forKey: kCIInputSaturationKey) }
        
        guard let outputImage = self.state.currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            self.state.processedImage = uiImage
        }
    }

    func applyProcessing() {
        
        let beginImage = CIImage(image: self.state.processedImage)
        self.state.currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        let inputKeys = self.state.currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { self.state.currentFilter.setValue(self.state.filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { self.state.currentFilter.setValue(self.state.filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { self.state.currentFilter.setValue(self.state.filterIntensity * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = self.state.currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            self.state.processedImage = uiImage
        }
    }
}
