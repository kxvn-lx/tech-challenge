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
        // We use unowned because we presumes it wil never be nil during its lifetime. (because always active)
        // Called whenever hue slider changed its value
        editorVC.didUpdateHue
            .handleEvents(receiveOutput: { [unowned self] hueValue in
                let sourceImage = self.previewView.ciBaseImage
                let hueAdjust = CIFilter(name: "CIHueAdjust")
                
                hueAdjust?.setDefaults()
                hueAdjust?.setValue(sourceImage, forKey: "inputImage")
                hueAdjust?.setValue(hueValue, forKey: "inputAngle")
                
                guard let resultImage = hueAdjust?.value(forKey: "outputImage") as? CIImage else { return }
                self.previewView.tempImage = resultImage
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
}
