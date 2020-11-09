//
//  ToolbarButton.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 9/11/20.
//

import UIKit

class ToolbarButton: UIButton {
    private let color: UIColor = .secondarySystemBackground
    
    override public var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.backgroundColor = color
            } else {
                self.backgroundColor = color.withAlphaComponent(0.5)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = color
        setTitleColor(.lightGray, for: .normal)
        setTitleColor(.darkGray, for: .disabled)
        layer.cornerRadius = 7.5
        layer.cornerCurve = .continuous // have that nice squircle rounded corner!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
