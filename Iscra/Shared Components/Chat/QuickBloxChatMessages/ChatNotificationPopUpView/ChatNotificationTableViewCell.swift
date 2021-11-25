//
//  ChatNotificationTableViewCell.swift
//  Iscra
//
//  Created by Dr.Mac on 23/11/21.
//

import UIKit

class ChatNotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(itemsChatNotification: ChatNotification, index: Int) {
        lblTitle.text = itemsChatNotification.titleNotifictaion
        if index == 4{
            lblTitle.textColor = UIColor.gray
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

