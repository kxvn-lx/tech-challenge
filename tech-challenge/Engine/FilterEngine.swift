//
//  FilterEngine.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 8/11/20.
//

import Foundation
import CoreImage
import Combine

class FilterEngine {
    var sourceImage: CIImage? // The image that will be processed/edited
    // Hardcoded the value since we assumed that the value will not change in the future.
    var hueValue: CGFloat = 0 {
        didSet {
            process()
            observeEditing()
        }
    }
    var saturationValue: CGFloat = 1 {
        didSet {
            process()
            observeEditing()
        }
    }
    var brightnessValue: CGFloat = 0 {
        didSet {
            process()
            observeEditing()
        }
    }
    
    /// Called when filter engine has finished processing the image, and ready to be render on screen.
    var didFinishRenderImage = PassthroughSubject<CIImage, Never>()
    var isEditing = PassthroughSubject<Bool, Never>()
    
    init() { }
    
    /// Reset all values back to its initial value
    func resetValues() {
        hueValue = 0
        saturationValue = 1
        brightnessValue = 0
    }
    
    /// Observe all values and check if the user is editing or not
    private func observeEditing() {
        if hueValue != 0 || saturationValue != 1 || brightnessValue != 0 {
            isEditing.send(true)
        } else {
            isEditing.send(false)
        }
    }
    
    /// Process the image with any filter's value
    private func process() {
        // Make sure we have an image to process
        guard let sourceImage = sourceImage else { return }
        // Filters declaration
        guard
            let hueRotationFilter = CIFilter(name: "CIHueAdjust"),
            let saturationFilter = CIFilter(name: "CIColorControls"),
            let brightnessFilter = CIFilter(name: "CIColorControls")
        else { return }
        
        // Apply hue filter
        hueRotationFilter.setDefaults()
        hueRotationFilter.setValue(sourceImage, forKey: "inputImage")
        hueRotationFilter.setValue(hueValue, forKey: "inputAngle")
        
        // Apply saturation filter
        saturationFilter.setDefaults()
        saturationFilter.setValue(hueRotationFilter.value(forKey: "outputImage") as? CIImage, forKey: "inputImage")
        saturationFilter.setValue(saturationValue, forKey: "inputSaturation")
        
        // Apply brightness filter
        brightnessFilter.setDefaults()
        brightnessFilter.setValue(saturationFilter.value(forKey: "outputImage") as? CIImage, forKey: "inputImage")
        brightnessFilter.setValue(brightnessValue, forKey: "inputBrightness")
        
        guard let resultImage = brightnessFilter.value(forKey: "outputImage") as? CIImage else { return }
        didFinishRenderImage.send(resultImage)
    }
}
