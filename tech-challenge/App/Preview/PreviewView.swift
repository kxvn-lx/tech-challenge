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
        }
    }
    
    private let metalView = CustomMetalView(frame: .zero, device: MTLCreateSystemDefaultDevice())
    
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
        addSubview(metalView)
        
        metalView.image = ciBaseImage
    }
    
    /// Setup the constraint of the view
    private func setupConstraint() {
        metalView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
