//
//  HomeViewController.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 5/11/20.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    private let previewView = PreviewView()
    private let editorVC = EditorViewController()
    
    private var subscriptions = Set<AnyCancellable>()
    
    /// Hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraint()
        
        observeEditorSliders()
    }
    
    private func setupView() {
        view.addSubview(previewView)
        self.add(editorVC)
    }
    
    private func setupConstraint() {
        previewView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        editorVC.view.snp.makeConstraints { (make) in
            make.width.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
    }
    
    /// Observe the editor's sliders value change
    private func observeEditorSliders() {
        editorVC.didUpdateHue
            .handleEvents(receiveOutput: { [unowned self] hueValue in
//                let source = self.previewView.baseImage!
//
//                let imageSize = source.size
//                let imageExtent = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
//
//                // Create a context containing the image.
//                UIGraphicsBeginImageContext(imageSize)
//                let context = UIGraphicsGetCurrentContext()
//                source.draw(at: CGPoint(x: 0, y: 0))
//
//                // Draw the hue on top of the image.
//                context?.setBlendMode(.hue)
//                UIColor(hue: hueValue, saturation: 1.0, brightness: 1, alpha: 1).set()
//                let imagePath = UIBezierPath(rect: imageExtent)
//                imagePath.fill()
//
//                // Retrieve the new image.
//                let result = UIGraphicsGetImageFromCurrentImageContext()
//                UIGraphicsEndImageContext()
//
//                self.previewView.tempImage = result
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        let context = CIContext()
        
        let brightnessFilter = CIFilter(name: "CIColorControls")!
//        brightnessFilter.setValue(CIImage(cgImage: self.previewView.baseImage!.cgImage!), forKey: "inputImage")
        
        editorVC.didUpdateBrightness
            .handleEvents(receiveOutput: { [unowned self] brightnessValue in
//                brightnessFilter.setValue(Float(brightnessValue), forKey: "inputBrightness")
//                let outputImage = brightnessFilter.outputImage
//
//                let imageRef = context.createCGImage(outputImage!, from: outputImage!.extent)
//                self.previewView.tempImage = UIImage(cgImage: imageRef!)
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
}
