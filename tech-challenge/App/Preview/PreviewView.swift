//
//  PreviewView.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 5/11/20.
//

import UIKit

class PreviewView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let baseImage = UIImage(named: "Neon-Source")
    // TempImage will store the edited image so that we can preview them easily
    private var tempImage: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Setup the view and layout
    private func setupView() {
        imageView.image = baseImage
        addSubview(imageView)
    }
    
    /// Setup the constraint of the view
    private func setupConstraint() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
