//
//  EditorViewController.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 5/11/20.
//

import UIKit

class EditorViewController: UIViewController {
    private let hueSlider: GradientSlider = {
        let slider = GradientSlider()
        slider.hasRainbow = true
        return slider
    }()
    private let satSlider: GradientSlider = {
        let slider = GradientSlider()
        return slider
    }()
    private let brightSlider: GradientSlider = {
        let slider = GradientSlider()
        return slider
    }()
    private var mStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraint()
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
}
