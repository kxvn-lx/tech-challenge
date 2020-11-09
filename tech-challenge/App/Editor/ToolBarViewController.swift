//
//  ToolBarViewController.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 9/11/20.
//

import UIKit

protocol ToolbarDelegate: class {
    func didTapReset()
    func didTapPreview()
    func didTapUndo()
    func didTapRedo()
}

class ToolBarViewController: UIViewController {
    private var mStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 1.5
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let toolbarNames = ["Reset", "Preview", "Undo", "Redo"]
    weak var delegate: ToolbarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
    }
    
    /// Determining whether user is editing the image or not
    func isUserEditing(_ isEditing: Bool) {
        // Harcoded index 0 since we know that at that index, it will be a reset button.
        guard let resetButton = mStackView.arrangedSubviews[0] as? UIButton else { fatalError("Not a button!") }
        resetButton.isEnabled = isEditing
    }
    
    private func setupView() {
        var toolbarButtonTag = 0
        toolbarNames.forEach({
            let button = createToolbarButton(withTitle: $0)
            button.tag = toolbarButtonTag
            button.isEnabled = toolbarButtonTag != 0
            
            mStackView.addArrangedSubview(button)
            
            toolbarButtonTag += 1
        })
        
        view.addSubview(mStackView)
    }
    
    private func setupConstraint() {
        mStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func createToolbarButton(withTitle title: String) -> ToolbarButton {
        let button = ToolbarButton(type: .system)
        button.setTitle(title, for: .normal)
        button.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 50))
        
        button.addTarget(self, action: #selector(toolbarTapped), for: .touchUpInside)
        
        return button
    }
    
    @objc private func toolbarTapped(_ sender: ToolbarButton) {
        switch sender.tag {
        case 0: delegate?.didTapReset()
        case 1: delegate?.didTapPreview()
        case 2: delegate?.didTapUndo()
        case 3: delegate?.didTapRedo()
        default: break
        }
    }
}
