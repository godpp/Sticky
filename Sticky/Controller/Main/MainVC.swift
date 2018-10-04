//
//  MainVC.swift
//  Sticky
//
//  Created by 갓거 on 2018. 9. 22..
//  Copyright © 2018년 갓거. All rights reserved.
//

import UIKit
import Lottie

class MainVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var dDayView: UIView!
    @IBOutlet var chatView: UIView!
    
    @IBOutlet var heartView: UIView!

    let animationHeartView = LOTAnimationView(name: "heart")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heartViewAnimation()
        chatViewTabGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationHeartView.play()
    }
    
}

extension MainVC {
    
    func heartViewAnimation(){
        animationHeartView.contentMode = .scaleToFill
        animationHeartView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.heartView.addSubview(animationHeartView)
    }
    
    func chatViewTabGesture(){
        let tapChatView = UITapGestureRecognizer(target: self, action: #selector(tapChatViewHandle(sender:)))
        tapChatView.delegate = self
        chatView.addGestureRecognizer(tapChatView)
    }
    
    
    @objc func tapChatViewHandle(sender: UITapGestureRecognizer? = nil){

    }
}
