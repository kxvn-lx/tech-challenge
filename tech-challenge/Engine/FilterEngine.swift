//
//  FilterEngine.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 8/11/20.
//

import Foundation
import CoreImage
import Combine

struct FilterEngine {
    var sourceImage: CIImage?
    var hueValue: CGFloat! {
        didSet {
            process()
        }
    }
    var saturationValue: CGFloat! {
        didSet {
            process()
        }
    }
    var brightnessValue: CGFloat! {
        didSet {
            process()
        }
    }
    
    var didFinishRenderImage = PassthroughSubject<CIImage, Never>()
    
    init() {
    }
    
    /// Process the image with any filter's value
    private func process() {
        // Make sure we have an image to process
        guard let sourceImage = sourceImage else { return }
        // Filters declaration
        guard
            let hueRotationFilter = CIFilter(name: "CIHueAdjust"),
            let brightnessFilter = CIFilter(name: "CIColorControls")
        else { return }
        
        // Apply hue filter
        hueRotationFilter.setDefaults()
        hueRotationFilter.setValue(sourceImage, forKey: "inputImage")
        hueRotationFilter.setValue(hueValue, forKey: "inputAngle")
        
        // Apply brightness filter
        brightnessFilter.setDefaults()
        brightnessFilter.setValue(hueRotationFilter.value(forKey: "outputImage") as? CIImage, forKey: "inputImage")
        brightnessFilter.setValue(brightnessValue, forKey: "inputBrightness")
        
        guard let resultImage = brightnessFilter.value(forKey: "outputImage") as? CIImage else { return }
        didFinishRenderImage.send(resultImage)
    }
}
