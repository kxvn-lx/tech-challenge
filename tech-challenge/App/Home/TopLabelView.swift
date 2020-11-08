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
        // Setup blur
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        
        insertSubview(blurredEffectView, at: 0)
    }
    
    private func setupView() {
        addSubview(label)
    }
    
    private func setupConstraint() {
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
