//
//  ToolBarViewController.swift
//  tech-challenge
//
//  Created by Kevin Laminto on 9/11/20.
//

import UIKit

protocol ToolbarDelegate: class {
    func didTapReset()
    func didLongPressPreview(_ sender: UILongPressGestureRecognizer)
    func didTapUndo()
    func didTapRedo()
}

class ToolBarViewController: UIViewController {
    private let mStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 1.5
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    weak var delegate: ToolbarDelegate?
    // Global variable to keep track of its reference
    private let previewButtonLabel: PaddingLabel = {
        let previewButtonLabel = PaddingLabel()
        previewButtonLabel.text = "Preview"
        previewButtonLabel.font = .preferredFont(forTextStyle: .callout)
        previewButtonLabel.textAlignment = .center
        previewButtonLabel.textColor = .lightGray
        previewButtonLabel.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 50))
        previewButtonLabel.backgroundColor = .secondarySystemBackground
        previewButtonLabel.layer.cornerRadius = 7.5
        previewButtonLabel.layer.cornerCurve = .continuous
        previewButtonLabel.layer.masksToBounds = true
        previewButtonLabel.isUserInteractionEnabled = true
        previewButtonLabel.numberOfLines = 0
        previewButtonLabel.minimumScaleFactor = 0.2
        previewButtonLabel.adjustsFontSizeToFitWidth = true
        return previewButtonLabel
    }()
    
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
    
    /// Determine the enability of the undo button
    /// - Parameter bool: if can undo, the undo button will simply be enabled. Vice versa
    func canUndo(_ bool: Bool) {
        // Hardcode the index since i assume i won't be addding any button(s) in the future
        guard let undoButton = mStackView.arrangedSubviews[2] as? ToolbarButton else { fatalError("stackView at index 2 should be a button") }
        undoButton.isEnabled = bool
    }
    
    /// Determine the enability of the redo button
    /// - Parameter bool: if can redo, the redo button will simply be enabled. Vice versa
    func canRedo(_ bool: Bool) {
        // Hardcode the index since i assume i won't be addding any button(s) in the future
        guard let redoButton = mStackView.arrangedSubviews[3] as? ToolbarButton else { fatalError("stackView at index 2 should be a button") }
        redoButton.isEnabled = bool
    }
    
    private func setupView() {
        setupButtons()
        view.addSubview(mStackView)
    }
    
    private func setupConstraint() {
        mStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupButtons() {
        // Create each button individually since we want them to act differently
        // At first I create a loop, but it made the code more inefficient and introduce more
        // lines and work.
        
        let resetButton = ToolbarButton(type: .system)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 50))
        resetButton.addTarget(self, action: #selector(toolbarTapped), for: .touchUpInside)
        resetButton.tag = 0
        resetButton.isEnabled = false
        
        // Set a 'fake' button to make long press work flawlessly
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressPreview))
        longPress.minimumPressDuration = 0.125
        previewButtonLabel.addGestureRecognizer(longPress)
        
        let undoButton = ToolbarButton(type: .system)
        undoButton.setTitle("Undo", for: .normal)
        undoButton.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 50))
        undoButton.addTarget(self, action: #selector(toolbarTapped), for: .touchUpInside)
        undoButton.tag = 2
        undoButton.isEnabled = false
        
        let redoButton = ToolbarButton(type: .system)
        redoButton.setTitle("Redo", for: .normal)
        redoButton.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 50))
        redoButton.addTarget(self, action: #selector(toolbarTapped), for: .touchUpInside)
        redoButton.tag = 3
        redoButton.isEnabled = false
        
        mStackView.addArrangedSubview(resetButton)
        mStackView.addArrangedSubview(previewButtonLabel)
        mStackView.addArrangedSubview(undoButton)
        mStackView.addArrangedSubview(redoButton)
    }
    
    @objc private func didLongPressPreview(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            previewButtonLabel.backgroundColor = UIColor.systemBackground
        } else if sender.state == .ended {
            previewButtonLabel.backgroundColor = UIColor.secondarySystemBackground
        }
        delegate?.didLongPressPreview(sender)
    }
    
    @objc private func toolbarTapped(_ sender: ToolbarButton) {
        switch sender.tag {
        case 0: delegate?.didTapReset()
        case 2: delegate?.didTapUndo()
        case 3: delegate?.didTapRedo()
        default: break
        }
    }
}
