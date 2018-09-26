//
//  ChatMessageCell.swift
//  Sticky
//
//  Created by 갓거 on 2018. 9. 23..
//  Copyright © 2018년 갓거. All rights reserved.
//

import UIKit
import SnapKit

class ChatMessageCell: UICollectionViewCell {
    
    @IBOutlet var messageView: UIView!
    @IBOutlet var messageTextLabel: UILabel!
    
    //MARK: SnapKit
    var messageViewWidthConstraint: Constraint?
    var messageViewHeightConstraint: Constraint?
    var messageViewLeftConstraint: Constraint?
    var messageViewRightConstraint: Constraint?
    var messageTextLabelHeightConstraint: Constraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setMessageUI()
        setSnapKitConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: 메시지 내용에 따른 셀 크기 동적 변경
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        let height = getFrameHeightForEachMessage(message: messageTextLabel.text!).height + 20
        var newFrame = layoutAttributes.frame
        newFrame.size.width = CGFloat(ceil(Float(size.width)))
        newFrame.size.height = height
        messageViewHeightConstraint?.update(offset: height)
        messageTextLabelHeightConstraint?.update(offset: height)
        layoutAttributes.frame = newFrame
        
        return layoutAttributes
    }
}

extension ChatMessageCell {
    
    func setMessageUI(){
        messageView.layer.masksToBounds = true
        messageView.layer.cornerRadius = 8
        messageTextLabel.numberOfLines = 0
        messageTextLabel.lineBreakMode = .byWordWrapping
    }
    
    func setSnapKitConstraints(){
        messageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            messageViewLeftConstraint = make.left.equalTo(contentView.snp.left).offset(4).constraint
            messageViewRightConstraint = make.right.equalTo(contentView.snp.right).offset(-4).constraint
            messageViewWidthConstraint = make.width.equalTo(200).constraint
            messageViewHeightConstraint = make.height.equalTo(frame.height).constraint
        }
        messageViewWidthConstraint?.activate()
        messageViewHeightConstraint?.activate()
        
        messageTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.left.equalTo(messageView.snp.left).offset(4)
            make.right.equalTo(messageView.snp.right).offset(-4)
            messageTextLabelHeightConstraint = make.height.equalTo(frame.height).constraint
        }
    }
    
    func getFrameHeightForEachMessage(message: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)], context: nil
        )
    }
    
}
