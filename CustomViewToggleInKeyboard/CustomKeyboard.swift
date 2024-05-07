//
//  CustomKeyboard.swift
//  CustomViewToggleInKeyboard
//
//  Created by Nitin Bhatia on 07/05/24.
//

import UIKit

protocol CustomKeyboardDelegate: AnyObject {
    func keyPressed(key: String)
    func backspacePressed()
}

class CustomKeyboard: UIView {
    
    weak var delegate: CustomKeyboardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupKeyboard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupKeyboard()
    }
    
    private func setupKeyboard() {
        // Create buttons
        let buttonTitles = [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            ["", "0", "x"]
        ]
        
        for (rowIndex, row) in buttonTitles.enumerated() {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)
            
            for (columnIndex, title) in row.enumerated() {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
               
                
                if rowIndex == buttonTitles.count - 1 && columnIndex == 0 {
                    let button = UIButton(type: .system)
                    button.setTitle("", for: .normal)
                    let backspaceImage = UIImage(systemName: "delete.left")
                    button.setImage(backspaceImage, for: .normal)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    stackView.addArrangedSubview(button)
                    button.addTarget(self, action: #selector(backspacePressed(_:)), for: .touchUpInside)
                    button.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0/CGFloat(row.count)).isActive = true

                } else {
                    stackView.addArrangedSubview(button)
                    button.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0/CGFloat(row.count)).isActive = true
                }
            }
            
            // Add stack view constraints
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0/CGFloat(buttonTitles.count)).isActive = true
            
            if rowIndex == 0 {
                stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            } else {
                let previousStackView = subviews[rowIndex - 1]
                stackView.topAnchor.constraint(equalTo: previousStackView.bottomAnchor).isActive = true
            }
        }
    }
    
    @objc private func keyPressed(_ sender: UIButton) {
        guard let key = sender.title(for: .normal) else { return }
        delegate?.keyPressed(key: key)
    }
    
    @objc private func backspacePressed(_ sender: UIButton) {
        delegate?.backspacePressed()
    }
}

