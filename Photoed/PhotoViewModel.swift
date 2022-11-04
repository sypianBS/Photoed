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
        var referenceProcessedImage: UIImage!
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
    
    func setInitialCorrectionParameters(filterType: FilterType) {
        self.state.referenceProcessedImage = self.state.processedImage
        self.state.isEditingColors = true
        self.state.filterType = filterType
        self.state.filterIntensity = initialFilterIntensityValue
    }
    
    var rangeForCurrentFilter: ClosedRange<Double> {
        switch state.filterType {
        case .saturation:
            return FilterRange.saturationRange
        case .contrast:
            return FilterRange.contrastRange //todoben contrast is not quite right
        case .brightness:
            return FilterRange.brightnessRange
        }
    }
    
    var initialFilterIntensityValue: Double {
        switch state.filterType {
        case .saturation:
            return getMiddleValueForClosedRange(closedRange: FilterRange.saturationRange)
        case .contrast:
            return getMiddleValueForClosedRange(closedRange: FilterRange.contrastRange)
        case .brightness:
            return getMiddleValueForClosedRange(closedRange: FilterRange.brightnessRange)
        }
    }
    
    private func getMiddleValueForClosedRange(closedRange: ClosedRange<Double>) -> Double {
        return (closedRange.lowerBound + closedRange.upperBound) / 2
    }
    
    func restoreFilterIntensity() {
        self.state.isEditingColors = false
        self.state.filterIntensity = initialFilterIntensityValue
    }
    
    func applyColorProcessing() {
        self.state.currentFilter = CIFilter(name: "CIColorControls")!
        
        let beginImage = CIImage(image: self.state.referenceProcessedImage)
        self.state.currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        let inputKeys = self.state.currentFilter.inputKeys
        
        switch state.filterType {
        case .saturation:
            //To calculate saturation, this filter linearly interpolates between a grayscale image (saturation = 0.0) and the original image (saturation = 1.0). The filter supports extrapolation: For values large than 1.0, it increases saturation
            if inputKeys.contains(kCIInputSaturationKey) {
                self.state.currentFilter.setValue(self.state.filterIntensity, forKey: kCIInputSaturationKey)
            }
        case .contrast:
            if inputKeys.contains(kCIInputContrastKey) {
                self.state.currentFilter.setValue(self.state.filterIntensity, forKey: kCIInputContrastKey)
            }
        case .brightness:
            if inputKeys.contains(kCIInputBrightnessKey) {
                self.state.currentFilter.setValue(self.state.filterIntensity, forKey: kCIInputBrightnessKey)
            }
        }
        
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
