//
//  SliderValue.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 9/11/20.
//

import Foundation
import CoreGraphics

struct SliderValue {
    let id = UUID()
    var value: CGFloat
    var type: SliderType
    
    enum SliderType {
        case hue, saturation, brightness
    }
}
