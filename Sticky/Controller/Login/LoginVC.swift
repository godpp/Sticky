//
//  LoginVC.swift
//  Sticky
//
//  Created by 갓거 on 2018. 9. 21..
//  Copyright © 2018년 갓거. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}

extension LoginVC {
    
    @objc func signInButtonAction(){
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if user != nil{
                let main = UIStoryboard(name: "Main", bundle: nil)
                let tabVC = main.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                self.view.window?.rootViewController = tabVC
            } else {
                print("login fail")
            }
        }
    }
    
    @objc func signUpButtonAction(){
        
    }
    
}
