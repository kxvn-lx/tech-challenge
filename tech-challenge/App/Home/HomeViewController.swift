//
//  HomeViewController.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 5/11/20.
//

import UIKit

class HomeViewController: UIViewController {
    private let previewView = PreviewView()
    private let editorVC = EditorViewController()
    
    /// Hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        view.addSubview(previewView)
        self.add(editorVC)
    }
    
    private func setupConstraint() {
        previewView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        editorVC.view.snp.makeConstraints { (make) in
            make.width.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
    }
}
