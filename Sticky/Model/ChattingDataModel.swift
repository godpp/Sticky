//
//  ChattingDataModel.swift
//  Sticky
//
//  Created by 갓거 on 2018. 9. 22..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation

//MARK: 말풍선
struct ChatMessage {
    var fromUserId: String
    var text: String
    var timestamp: NSNumber
}

//MARK: 채팅방
struct ChatRoom {
    var key: String
    var name: String
    var messages: Dictionary<String,Int>
    
    init(key: String, name: String) {
        self.key = key
        self.name = name
        self.messages = [:]
    }
    
    init(key: String, data: Dictionary<String,AnyObject>) {
        self.key = key
        self.name = data["name"] as! String
        if let messages = data["messages"] as? Dictionary<String,Int>{
            self.messages = messages
        } else {
            self.messages = [:]
        }
    }
}

//MARK: 사용자
struct User {
    var uid: String
    var email: String
    var username: String
    var couple: Dictionary<String,String>
    
    init(uid: String, email: String, username: String) {
        self.uid = uid
        self.email = email
        self.username = username
        self.couple = [:]
    }
}
