//
//  LoginVC.swift
//  Sticky
//
//  Created by 갓거 on 2018. 9. 21..
//  Copyright © 2018년 갓거. All rights reserved.
//

import UIKit
import FirebaseAuth
import TextFieldEffects

class LoginVC: UIViewController {
    
    @IBOutlet var emailTextField: HoshiTextField!
    @IBOutlet var passwordTextField: HoshiTextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stateVerification()
        signInButton.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}

extension LoginVC {
    
    //MARK: 로그인 상태 검증
    func stateVerification(){
        if Auth.auth().currentUser != nil {
            let main = UIStoryboard(name: "Main", bundle: nil)
            let tabVC = main.instantiateViewController(withIdentifier: "TabVC") as! TabVC
            UIApplication.shared.keyWindow?.rootViewController = tabVC
        } else{
            
        }
    }
    
    @objc func signInButtonAction(){
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if user != nil{
                let main = UIStoryboard(name: "Main", bundle: nil)
                let tabVC = main.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                UIApplication.shared.keyWindow?.rootViewController = tabVC
            } else {
                print("login fail")
            }
        }
    }
    
    @objc func signUpButtonAction(){
        let signup = UIStoryboard(name: "SignUp", bundle: nil)
        let signupVC = signup.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        signupVC.modalTransitionStyle = .coverVertical
        self.present(signupVC, animated: true, completion: nil)
        
    }
    
}
