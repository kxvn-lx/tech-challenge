//
//  TopLabelView.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 8/11/20.
//

import UIKit

class TopLabelView: UIView {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Hue, Saturation, Brightness"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        return label
    }()
    private let blurredEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        return blurredEffectView
    }()
    
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
        blurredEffectView.frame = self.bounds
    }
    
    private func setupView() {
        addSubview(blurredEffectView)
        addSubview(label)
    }
    
    private func setupConstraint() {
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
