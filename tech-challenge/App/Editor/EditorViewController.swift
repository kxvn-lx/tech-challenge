//
//  EditorViewController.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 5/11/20.
//

import UIKit
import Combine

class EditorViewController: UIViewController {
    private let hueSlider: GradientSlider = {
        let slider = GradientSlider()
        slider.maximumValue = CGFloat.pi
        slider.minimumValue = -CGFloat.pi
        slider.value = 0
        slider.thumbColor = UIColor(hue: slider.value, saturation: 1, brightness: 1, alpha: 1)
        slider.hasRainbow = true
        return slider
    }()
    private let satSlider: GradientSlider = {
        let slider = GradientSlider()
        slider.minColor = .gray
        slider.maxColor = UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 1)
//        slider.maximumValue = 1
//        slider.minimumValue = -1
//        slider.value = 0
//        slider.setGradientVaryingSaturation(hue: 0, brightness: 0)
        return slider
    }()
    private let brightSlider: GradientSlider = {
        let slider = GradientSlider()
        slider.minColor = .black
        slider.maxColor = .white
//        slider.maximumValue = 1
//        slider.minimumValue = -1
//        slider.value = 0
//        slider.setGradientVaryingBrightness(hue: 0, saturation: 0)
        return slider
    }()
    
    private var mStackView: UIStackView!
    private let bigThumbSize: CGFloat = 1.5
    
    var didUpdateHue = PassthroughSubject<CGFloat, Never>()
    var didUpdateSaturation = PassthroughSubject<CGFloat, Never>()
    var didUpdateBrightness = PassthroughSubject<CGFloat, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraint()
        observeSlider()
    }
    
    private func setupView() {
        // Setup blur
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.view.bounds
        view.addSubview(blurredEffectView)
        
        // Setup master stackviews
        let hueSV = createSliderStack(withSlider: hueSlider, withTitle: "Hue")
        let satSV = createSliderStack(withSlider: satSlider, withTitle: "Saturation")
        let brightSV = createSliderStack(withSlider: brightSlider, withTitle: "Brightness")
        
        mStackView = UIStackView(arrangedSubviews: [hueSV, satSV, brightSV])
        mStackView.axis = .vertical
        mStackView.spacing = 20
        mStackView.distribution = .fillEqually
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mStackView)
    }
    
    private func setupConstraint() {
        mStackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.75)
        }
    }
    
    /// Observe all three slider changes
    private func observeSlider() {
        hueSlider.actionBlock = { [weak self] slider, value, finished in
            guard let self = self else { return }
            // We convert the value to 0 and 1, to match the slider's colour.
            let convertedHueValue = self.convert(value, fromOldRange: [-CGFloat.pi, CGFloat.pi], toNewRange: [0, 1])
            
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            
            //Reflect the new hue in the saturation slider
            self.satSlider.maxColor = UIColor(hue: convertedHueValue, saturation: 1, brightness: 1, alpha: 1)
            
            // Update the thumb color to match the value
            slider.thumbColor = UIColor(hue: convertedHueValue, saturation: 1, brightness: 1, alpha: 1)
            
            slider.thumbSize = finished ? GradientSlider.defaultThumbSize : GradientSlider.defaultThumbSize * self.bigThumbSize
         
            self.didUpdateHue.send(value)
            
            CATransaction.commit()
        }
        
        satSlider.actionBlock = { [weak self] slider, value, finished in
            guard let self = self else { return }
            
            slider.thumbSize = finished ? GradientSlider.defaultThumbSize : GradientSlider.defaultThumbSize * self.bigThumbSize
            
            self.didUpdateSaturation.send(value)
        }
        
        brightSlider.actionBlock = { [weak self] slider, value, finished in
            guard let self = self else { return }
            
            slider.thumbSize = finished ? GradientSlider.defaultThumbSize : GradientSlider.defaultThumbSize * self.bigThumbSize
            
            self.didUpdateBrightness.send(value)
        }
    }
    
    /// Helper method to create a horizontal stack view with Slider and a title label as its subview.
    /// - Parameters:
    ///   - slider: The slider that will be added to the stackview
    ///   - title: The title of the slider (or label)
    /// - Returns: StackView from the given parameters
    private func createSliderStack(withSlider slider: GradientSlider, withTitle title: String) -> UIStackView {
        // Setup wrapper view so that the label can be left aligned
        let viewWrapper = UIView()
        viewWrapper.snp.makeConstraints { (make) in
            make.width.equalTo(100)
        }
        
        // Setup label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .lightGray
        
        viewWrapper.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let stackView = UIStackView(arrangedSubviews: [slider, viewWrapper])
        stackView.spacing = 10
        
        return stackView
    }
    
    /// Linear conversion in Swift. Converting a value from the old range to the new range.
    /// Example: get the value from an old range of 0 - 10 to a new range of 0 - 1
    /// - Parameters:
    ///   - oldValue: The old value. This value will then be converted to the enw range value.
    ///   - oldRange: The old range array. MUST be only consisting of 2 value. [oldMin, oldMax]
    ///   - newRange: The new range arary. MUSt be only consisting of 2 value. [newMin, newMax]
    /// - Returns: The converted value
    private func convert(_ oldValue: CGFloat, fromOldRange oldRange: [CGFloat], toNewRange newRange: [CGFloat]) -> CGFloat {
        guard oldRange.count == 2, newRange.count == 2 else { fatalError("The ranges must only consist of 2 value.") }
        guard oldRange[1] > oldRange[0], newRange[1] > newRange[0] else { fatalError("The last index must be bigger!") }
        
        let oldRangeDiff = oldRange[1] - oldRange[0]
        let newRangeDiff = newRange[1] - newRange[0]
        
        let a = (oldValue - oldRange[0]) * newRangeDiff
        return (a / oldRangeDiff) + newRange[0]
    }
}
