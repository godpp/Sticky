//
//  ChatVC.swift
//  Sticky
//
//  Created by 갓거 on 2018. 9. 23..
//  Copyright © 2018년 갓거. All rights reserved.
//

import UIKit
import SnapKit

class ChatVC: UIViewController {
    
    @IBOutlet var chatMessageCollectionView: UICollectionView!
    @IBOutlet var sendMessageTextField: UITextField!
    @IBOutlet var sendMessageButton: UIButton!
    
    var messages: [ChatMessage] = [ChatMessage(fromUserId: "", text: "", timestamp: 0)]
    var keyboardHeight: CGFloat = 0.0
    var participantId: String?
    
    var coupleKey: String? {
        didSet{
            if let key = coupleKey {
                getOriginalMessages()
                FirebaseDataService.instance.roomRef.child(key).observeSingleEvent(of: .value, with:  { (snapshot) in
                    if let data = snapshot.value as? Dictionary<String, AnyObject> {
                        if let title = data["name"] as? String {
                            self.navigationController?.title = title
                        }
                        if let toId = data["to"] as? String {
                            self.participantId = toId
                        }
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatMessageCollectionView.delegate = self
        chatMessageCollectionView.dataSource = self
        sendMessageTextField.delegate = self
        sendMessageButton.addTarget(self, action: #selector(sendMessageButtonAction), for: .touchUpInside)
        settingUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerToKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterToKeyboardNotification()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        chatMessageCollectionView.collectionViewLayout.invalidateLayout()
    }
    
}

extension ChatVC {
    
    func settingUI(){
        let layout = chatMessageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize.width = view.frame.width
        chatMessageCollectionView.alwaysBounceVertical = true
        sendMessageButton.isEnabled = false
    }
    
    func getOriginalMessages(){
        if let coupleId = self.coupleKey {
            let coupleMessageRef = FirebaseDataService.instance.roomRef.child(coupleId).child("messages")
            coupleMessageRef.observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let messageRef = FirebaseDataService.instance.messageRef.child(messageId)
                messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let getMessages = snapshot.value as? Dictionary<String, AnyObject> else { return }
                    let message = ChatMessage(
                        fromUserId: getMessages["fromUserId"] as! String,
                        text: getMessages["text"] as! String,
                        timestamp: getMessages["timestamp"] as! NSNumber
                    )
                    self.messages.insert(message, at: self.messages.count-1)
                    self.chatMessageCollectionView.reloadData()
                    
                    //MARK: 가장 최신 메시지로 포커싱
                    if self.messages.count >= 1 {
                        let indexPath = IndexPath(item: self.messages.count-1, section: 0)
                        self.chatMessageCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
                    }
                    self.chatMessageCollectionView.frame.origin.y = self.keyboardHeight
                })
            })
        }
    }
    
    @objc func sendMessageButtonAction(){
        guard let fromUserId = FirebaseDataService.instance.currentUserUid else { return }
        let messagesData: Dictionary<String, AnyObject> = [
            "fromUserId": fromUserId as AnyObject,
            "text": bindingString(sendMessageTextField.text) as AnyObject,
            "timestamp": NSNumber(value: Date().timeIntervalSince1970)
        ]
        FirebaseDataService.instance.messageRef.childByAutoId().updateChildValues(messagesData) { (error, ref) in
            guard error == nil else {
                print(error as Any)
                return
            }
            self.sendMessageTextField.text = nil
            
            if let coupleId = self.coupleKey, let toId = self.participantId {
                FirebaseDataService.instance.roomRef.child(coupleId).child("messages").updateChildValues([FirebaseDataService.instance.messageRef.childByAutoId().key : 1])
                FirebaseDataService.instance.userRef.child(fromUserId).child("couples").updateChildValues([FirebaseDataService.instance.messageRef.childByAutoId().key : 1])
                FirebaseDataService.instance.userRef.child(toId).child("couples").updateChildValues([FirebaseDataService.instance.messageRef.childByAutoId().key : 1])
            }
        }
    }
    
    func getFrameHeightForEachMessage(message: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)], context: nil
        )
    }
    
    func registerToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unregisterToKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if sendMessageTextField.isFirstResponder {
            keyboardHeight = getKeyboardHeight(notification)
            chatMessageCollectionView.frame.origin.y = keyboardHeight
            view.frame.origin.y = -keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if sendMessageTextField.isFirstResponder {
            chatMessageCollectionView.frame.origin.y = 0
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
}

extension ChatVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessageTextField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText: NSString = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        if newText.length < 1 {
            sendMessageButton.isEnabled = false
        } else{
            sendMessageButton.isEnabled = true
        }
        return true
    }
    
}

extension ChatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chatMessageCollectionView.dequeueReusableCell(withReuseIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.messageTextLabel.text = message.text
        
        settingChatMessageCell(cell, message)
        
        //MARK: 0번째 셀 빈공간 (흰색)
        if indexPath.row == messages.count - 1{
            cell.messageView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        //MARK: 메시지 길에 따른 메시지뷰 크기 동적 조절
        if message.text.count > 0 {
            cell.messageViewWidthConstraint?.update(offset: getFrameHeightForEachMessage(message: message.text).width + 32)
        }
        
        return cell
    }
    
    func settingChatMessageCell(_ cell: ChatMessageCell, _ message: ChatMessage){
        if message.fromUserId == FirebaseDataService.instance.currentUserUid {
            cell.messageView.backgroundColor = UIColor.magenta
            cell.messageTextLabel.textColor = UIColor.white
            cell.messageViewRightConstraint?.activate()
            cell.messageViewLeftConstraint?.deactivate()
        } else {
            cell.messageView.backgroundColor = UIColor.lightGray
            cell.messageTextLabel.textColor = UIColor.black
            cell.messageViewRightConstraint?.deactivate()
            cell.messageViewLeftConstraint?.activate()
        }
    }
    
}
