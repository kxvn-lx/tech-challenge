//
//  HomeViewController.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 5/11/20.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    private let previewView = PreviewViewViewController()
    private let editorVC = EditorViewController()
    private var filterEngine = FilterEngine()
    private let topLabelView = TopLabelView()
    
    private var subscriptions = Set<AnyCancellable>()
    
    /// Hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark // Dark mode only
        
        filterEngine.sourceImage = self.previewView.ciBaseImage
        
        filterEngine.didFinishRenderImage
            .handleEvents(receiveOutput: { [unowned self] processedImage in
                self.previewView.renderingImage = processedImage
            })
            .sink { _ in }
            .store(in: &subscriptions)
        filterEngine.isEditing
            .handleEvents(receiveOutput: { [unowned self] isEditing in
                self.editorVC.toolBarVC.isUserEditing(isEditing)
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        setupView()
        setupConstraint()
        
        observeEditorSliders()
    }
    
    private func setupView() {
        self.add(previewView)
        view.addSubview(topLabelView)
        self.add(editorVC)
        
        editorVC.toolBarVC.delegate = self
    }
    
    private func setupConstraint() {
        previewView.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        editorVC.view.snp.makeConstraints { (make) in
            make.width.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
        topLabelView.snp.makeConstraints { (make) in
            make.top.width.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    /// Observe the editor's sliders value change
    private func observeEditorSliders() {
        // We use unowned because we presumes it wil never be nil during its lifetime. (because always active)
        // Called whenever hue slider changed its value
        editorVC.didUpdateHue
            .handleEvents(receiveOutput: { [unowned self] hueValue in
                self.filterEngine.hueValue = hueValue
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        editorVC.didUpdateSaturation
            .handleEvents(receiveOutput: { [unowned self] saturationValue in
                self.filterEngine.saturationValue = saturationValue
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        editorVC.didUpdateBrightness
            .handleEvents(receiveOutput: { [unowned self] brightnessValue in
                self.filterEngine.brightnessValue = brightnessValue
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
}

extension HomeViewController: ToolbarDelegate {
    func didTapReset() {
        editorVC.resetSlider()
        filterEngine.resetValues()
    }
    
    func didLongPressPreview(_ sender: UILongPressGestureRecognizer) {
        previewView.didLongPress(sender)
    }
    
    func didTapUndo() {
        print(3)
    }
    
    func didTapRedo() {
        print(4)
    }
}
