//
//  SignUpVC.swift
//  Sticky
//
//  Created by 갓거 on 2018. 9. 21..
//  Copyright © 2018년 갓거. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpVC: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var doneButton: UIButton!
    
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
    }
}

extension SignUpVC {
    
    func textFieldDataSetting() {
        email = bindingString(emailTextField.text)
        password = bindingString(passwordTextField.text)
    }
    
    @objc func signUpButtonAction(){
        
        textFieldDataSetting()
        
        Auth.auth().createUser(withEmail: bindingString(email), password: bindingString(password)) { (user, error) in
            let uid = self.bindingString(user?.user.uid)
            let nickname = self.bindingString(self.nicknameTextField.text)
            Database.database().reference().child("users").child(uid).setValue(["name": nickname], withCompletionBlock: { (error, ref) in
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as! AuthVC
                self.present(authVC, animated: false, completion: nil)
            })
        }
    }
}
