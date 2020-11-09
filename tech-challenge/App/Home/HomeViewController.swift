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
    
    private var undoMngr = UndoManager()
    
    /// Hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark // Dark mode only
        
        filterEngine.sourceImage = self.previewView.ciBaseImage
        
        setupView()
        setupConstraint()
        
        observeEditor()
        observeFilterEngine()
        
        editorVC.toolBarVC.delegate = self
    }
    
    private func setupView() {
        self.add(previewView)
        view.addSubview(topLabelView)
        self.add(editorVC)
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
    private func observeEditor() {
        // We use unowned because we presumes it wil never be nil during its lifetime. (because always active)
        // Called whenever hue slider changed its value
        editorVC.didUpdateHue
            .handleEvents(receiveOutput: { [unowned self] hueValue in
                // Before we update the value, store the old one for undoManager
                self.filterEngine.hueValue = hueValue
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        editorVC.didUpdateSaturation
            .handleEvents(receiveOutput: { [unowned self] saturationValue in
                // Before we update the value, store the old one for undoManager
                self.filterEngine.saturationValue = saturationValue
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        editorVC.didUpdateBrightness
            .handleEvents(receiveOutput: { [unowned self] brightnessValue in
                // Before we update the value, store the old one for undoManager
                self.filterEngine.brightnessValue = brightnessValue
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        editorVC.didReceiveOldValue
            .handleEvents(receiveOutput: { [unowned self] oldSliderValue in
                self.registerUndoAction(sliderValue: oldSliderValue)
//                editorVC.toolBarVC.canUndo(undoMngr.canUndo)
//                editorVC.toolBarVC.canRedo(undoMngr.canRedo)
            })
            .sink { _ in}
            .store(in: &subscriptions)
    }
    
    private func observeFilterEngine() {
        // Update the new rendering image
        filterEngine.didFinishRenderImage
            .handleEvents(receiveOutput: { [unowned self] processedImage in
                self.previewView.renderingImage = processedImage
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        // So that 'reset' toolbar button can react accordingly
        filterEngine.isEditing
            .handleEvents(receiveOutput: { [unowned self] isEditing in
                self.editorVC.toolBarVC.isUserEditing(isEditing)
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
}

// Undo and redo implementations
extension HomeViewController {
    func registerUndoAction(sliderValue: SliderValue) {
//        print(sliderValue.value, sliderValue.type)
        self.undoMngr.registerUndo(withTarget: self) { (selfTarget) in
            // undo the value
            switch sliderValue.type {
            case .brightness: selfTarget.filterEngine.brightnessValue = sliderValue.value
            case .hue: selfTarget.filterEngine.hueValue = sliderValue.value
            case .saturation: selfTarget.filterEngine.saturationValue = sliderValue.value
            }
            // undo the slider
            selfTarget.editorVC.undoRedoSlider(sliderValue: sliderValue)
            
            selfTarget.removeRegisterUndoAction(sliderValue: sliderValue)
        }
    }
    
    func removeRegisterUndoAction(sliderValue: SliderValue) {
        self.undoMngr.registerUndo(withTarget: self) { (selfTarget) in
            // Redo the value
            switch sliderValue.type {
            case .brightness: selfTarget.filterEngine.brightnessValue = sliderValue.value
            case .hue: selfTarget.filterEngine.hueValue = sliderValue.value
            case .saturation: selfTarget.filterEngine.saturationValue = sliderValue.value
            }
            // Redo the slider
            selfTarget.editorVC.undoRedoSlider(sliderValue: sliderValue)
            
            selfTarget.registerUndoAction(sliderValue: sliderValue)
        }
    }
}

extension HomeViewController: ToolbarDelegate {
    func didTapReset() {
        editorVC.resetSlider()
        editorVC.toolBarVC.canRedo(false)
        editorVC.toolBarVC.canUndo(false)
        filterEngine.resetValues()
        
        undoMngr = UndoManager()
    }
    
    func didLongPressPreview(_ sender: UILongPressGestureRecognizer) {
        previewView.didLongPress(sender)
    }
    
    func didTapUndo() {
        undoMngr.undo()
    }
    
    func didTapRedo() {
        undoMngr.redo()
    }
}
