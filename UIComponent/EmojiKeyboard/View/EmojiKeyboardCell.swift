//
//  ChatRoomEmojiCell.swift
//  Bobo
//
//  Created by ddkj007 on 2019/9/19.
//  Copyright © 2019 duiud. All rights reserved.
//

import UIKit

class EmojiKeyboardCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.image = UIImage(named: "chat_room_deleted_normal")
    }
    
    func refreshWithData(_ data: EmojeData) {
        switch data {
        case .delete:
            label.isHidden = true
            imageView.isHidden = false
            label.text = ""
        case .empty:
            label.isHidden = true
            imageView.isHidden = true
            label.text = ""
        case .string(let string):
            label.isHidden = false
            imageView.isHidden = true
            label.text = string
        }
    }
}
