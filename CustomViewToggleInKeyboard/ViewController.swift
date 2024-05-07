//
//  ViewController.swift
//  CustomViewToggleInKeyboard
//
//  Created by Nitin Bhatia on 06/05/24.
//

import UIKit

class ViewController: UIViewController {
    deinit {
        // Unregister for keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    //variables
    let customTextInputView = CustomTextInputView()
    var keyboardHeight : CGFloat = 0
    let btn = UIButton(type: .system)
    var currentInputViewSet = false
    var txtBottomConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btn.isEnabled = false
        btn.setTitle("Change", for: .normal)
        btn.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        btn.backgroundColor = .green
        // Set constraints for positioning the custom text input view
        customTextInputView.translatesAutoresizingMaskIntoConstraints = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(changeView(_:)), for: .touchUpInside)
        view.addSubview(customTextInputView)
        view.addSubview(btn)
        txtBottomConstraint = customTextInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        
        NSLayoutConstraint.activate([
            txtBottomConstraint,
            customTextInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customTextInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            btn.topAnchor.constraint(equalTo: customTextInputView.bottomAnchor, constant: 30),
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Optionally, you can set height and width constraints here
            // customTextInputView.heightAnchor.constraint(equalToConstant: 40),
            // customTextInputView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func changeView(_ sender: UIButton) {
        if currentInputViewSet {
            customTextInputView.unassingInputView()
            currentInputViewSet = false
            return
        }
        customTextInputView.assignInputView(height: keyboardHeight)
        currentInputViewSet = true
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyboardHeight == 0 {
            // Extract keyboard height
            keyboardHeight = keyboardSize.height
            customTextInputView.ck.frame.size.height = keyboardSize.height
            txtBottomConstraint.constant -= keyboardHeight
            btn.isEnabled = true
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // Reset keyboard height when keyboard hides
        btn.isEnabled = false
        txtBottomConstraint.constant = -100
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        },completion: {_ in
            self.customTextInputView.ck.frame.size.height = 0
            self.keyboardHeight = 0
            self.currentInputViewSet = false
        })
    }
    
    
}

