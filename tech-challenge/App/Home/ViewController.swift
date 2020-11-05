//
//  ViewController.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 5/11/20.
//

import UIKit

class ViewController: UIViewController {
    private let previewView = PreviewView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        view.addSubview(previewView)
    }
    
    private func setupConstraint() {
        previewView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
