//
//  CustomTextInput.swift
//  CustomViewToggleInKeyboard
//
//  Created by Nitin Bhatia on 07/05/24.
//

import UIKit

class CustomTextInputView: UIView, CustomKeyboardDelegate, UITextFieldDelegate  {
   
    
    var ck = CustomKeyboard()
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter text"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // Height and width properties
    var height: CGFloat = 40 {
        didSet {
            updateConstraints()
        }
    }
    
    var width: CGFloat = 200 {
        didSet {
            updateConstraints()
        }
    }
    
    private func setupUI() {
        addSubview(textField)
        // Create custom keyboard
        
        ck.delegate = self
        
        textField.delegate = self
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // You can customize textField's appearance or behavior here
    }
    
    func assignInputView(height: CGFloat) {
        ck.frame.size = CGSize(width: UIScreen.main.bounds.width, height: height)
        textField.inputView = ck
        textField.reloadInputViews()
    }
    
    func unassingInputView() {
        textField.inputView = nil
        textField.reloadInputViews()
    }
    
    // You may want to expose some properties and methods to interact with the textField
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    func keyPressed(key: String) {
        if key == "x" {
           let _ = textFieldShouldReturn(textField)
            return
        }
        textField.text! += key
    }
    
    func backspacePressed() {
        if !(textField.text ?? "").isEmpty {
            textField.text! = String(text!.dropLast())
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        unassingInputView()
        return false
    }
    
}

