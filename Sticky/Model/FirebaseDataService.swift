//
//  FirebaseDataService.swift
//  Sticky
//
//  Created by 갓거 on 2018. 9. 22..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import Firebase

fileprivate let baseRef = Database.database().reference()

//MARK: Firebase 싱글톤 클래스
class FirebaseDataService {
    static let instance = FirebaseDataService()
    
    //MARK: 사용자
    let userRef = baseRef.child("user")
    //MARK: 채팅방
    let roomRef = baseRef.child("room")
    //MARK: 말풍성
    let messageRef = baseRef.child("message")
    
    //MARK: 접속중인 유저의 uid
    var currentUserUid: String? {
        get {
            guard let uid = Auth.auth().currentUser?.uid else {
                return nil
            }
            return uid
        }
    }
}
