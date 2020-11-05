//
//  UIViewController.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 5/11/20.
//

import UIKit

// marked @nonobjc so it won’t conflict with any of Apple’s own code, now or in the future.
@nonobjc extension UIViewController {
    
    /// Add a child view controller.
    /// - Parameters:
    ///   - child: The child view controller to be added
    ///   - frame: Frame, if any
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    /// Remove a view controller from its parent
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
