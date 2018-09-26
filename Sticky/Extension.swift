//
//  Extension.swift
//  Sticky
//
//  Created by 갓거 on 2018. 9. 22..
//  Copyright © 2018년 갓거. All rights reserved.
//

import UIKit

//MARK: String, Int 옵셔널 바인딩
extension UIViewController {
    
    func bindingString(_ string: String?) -> String {
        guard let binding = string else {
            return ""
        }
        return binding
    }
    
    func bindingInt(_ int: Int?) -> Int {
        guard let binding = int else {
            return 0
        }
        return binding
    }
}

