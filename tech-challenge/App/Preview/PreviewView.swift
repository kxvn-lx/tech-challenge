//
//  PreviewView.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 5/11/20.
//

import UIKit
import MetalKit

class PreviewView: UIView {
    let ciBaseImage = CIImage(cgImage: UIImage(named: "Neon-Source")!.cgImage!)
    var tempImage: CIImage? { // TempImage will store the edited image so that we can preview them easily
        didSet {
            mtkView.draw()
        }
    }
    
    private let mtkView = MTKView()
    private var metalDevice: MTLDevice!
    private var metalCommandQueue: MTLCommandQueue!
    private var ciContext: CIContext!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tempImage = ciBaseImage
    }
    
    /// Setup the view and layout
    private func setupView() {
        addSubview(mtkView)
        
        //fetch the default gpu of the device
        metalDevice = MTLCreateSystemDefaultDevice()
        
        //tell our MTKView which gpu to use
        mtkView.device = metalDevice
        
        //tell our MTKView to use explicit drawing meaning we have to call .draw() on it
        mtkView.isPaused = true
        mtkView.enableSetNeedsDisplay = false
        
        //create a command queue to be able to send down instructions to the GPU
        metalCommandQueue = metalDevice.makeCommandQueue()
        
        //conform to MTKView's delegate
        mtkView.delegate = self
        
        ciContext = CIContext(mtlDevice: metalDevice)
        
        //let it's drawable texture be writen to
        mtkView.framebufferOnly = false
    }
    
    /// Setup the constraint of the view
    private func setupConstraint() {
        mtkView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension PreviewView: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    func draw(in view: MTKView) {
        guard let image = self.tempImage,
              let texture = self.mtkView.currentDrawable?.texture,
              let buffer = self.metalCommandQueue.makeCommandBuffer(),
              let context = self.ciContext
        else { return }
        
        // Apply appropriate scaling to fit the native device screen
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
        guard let drawable = self.mtkView.currentDrawable else { return }
        buffer.present(drawable)
        buffer.commit()
    }
}