//
//  PaddingLabel.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 9/11/20.
//

import UIKit

// modified from https://stackoverflow.com/a/32368958/10245574
class PaddingLabel: UILabel {
    var padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
    
    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (padding.left + padding.right)
        }
    }
}
