//
//  SignUpVC.swift
//  Sticky
//
//  Created by 갓거 on 2018. 9. 21..
//  Copyright © 2018년 갓거. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpVC: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    @IBOutlet var doneButton: UIButton!
    
    var email: String?
    var password: String?
    var confirmPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
    }
}

extension SignUpVC {
    
    func textFieldDataSetting() {
        email = bindingString(emailTextField.text)
        password = bindingString(passwordTextField.text)
        confirmPassword = bindingString(confirmTextField.text)
    }
    
    @objc func signUpButtonAction(){
        
        textFieldDataSetting()
        
        Auth.auth().createUser(withEmail: bindingString(email), password: bindingString(confirmPassword)) { (authResult, error) in
            
        }
    }
}
