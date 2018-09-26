//
//  MainVC.swift
//  Sticky
//
//  Created by 갓거 on 2018. 9. 22..
//  Copyright © 2018년 갓거. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var dDayView: UIView!
    @IBOutlet var chatView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapChatView = UITapGestureRecognizer(target: self, action: #selector(tapChatViewHandle(sender:)))
        tapChatView.delegate = self
        chatView.addGestureRecognizer(tapChatView)
    }
    
}

extension MainVC {
    @objc func tapChatViewHandle(sender: UITapGestureRecognizer? = nil){
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
