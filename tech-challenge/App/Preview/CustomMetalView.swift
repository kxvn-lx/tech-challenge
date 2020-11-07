//
//  CustomMetalView.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 7/11/20.
//

import Foundation
import MetalKit

// Note:
// It appears the simulator has a bug that flipped the render image whilst
// when tested on my iphone, it renders normally.
// Source: https://stackoverflow.com/questions/60164536/flipped-picture-after-render-in-metal

class CustomMetalView: MTKView {
    private var context: CIContext?
    private var queue: MTLCommandQueue?
    var image: CIImage? {
        didSet {
            // Rerender on new image
            self.setNeedsDisplay()
        }
    }
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        
        guard let device = MTLCreateSystemDefaultDevice() else { fatalError("No device found.") }
        
        self.device = device
        self.framebufferOnly = false
        // So that we can draw on demand.
        self.isPaused = true
        self.enableSetNeedsDisplay = true
        
        self.context = CIContext(mtlDevice: device)
        self.queue = device.makeCommandQueue()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw() {
        print("draw")
        guard let image = self.image,
              let texture = self.currentDrawable?.texture,
              let buffer = self.queue?.makeCommandBuffer(),
              let context = self.context
        else { return }
        
        let dpi = UIScreen.main.nativeScale
        let width = self.bounds.width * dpi
        let height = self.bounds.height * dpi
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let extent = image.extent
        let xScale = extent.width > 0 ? width  / extent.width  : 1
        let yScale = extent.height > 0 ? height / extent.height : 1
        let scale = max(xScale, yScale)
        let tx = (width - extent.width * scale) / 2
        let ty = (height - extent.height * scale) / 2
        let transform = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: tx, ty: ty)
        let filter = CIFilter(name: "CIAffineTransform",
                              parameters: ["inputImage": image, "inputTransform": transform])!
        let scaledImage = filter.outputImage!
        
        var imageToDraw = scaledImage
        // Since it is a simulator bug, we flipped it for the sake of it.
        #if targetEnvironment(simulator)
        imageToDraw = imageToDraw.oriented(.downMirrored)
        #endif
        
        context.render(imageToDraw,
                             to: texture,
                             commandBuffer: buffer,
                             bounds: rect,
                             colorSpace: CGColorSpaceCreateDeviceRGB())
        guard let drawable = self.currentDrawable else { return }
        buffer.present(drawable)
        buffer.commit()
        
    }
}
