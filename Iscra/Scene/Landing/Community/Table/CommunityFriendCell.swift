//
//  CommunityFriendCell.swift
//  Iscra
//
//  Created by mac on 27/10/21.
//

import UIKit

class CommunityFriendCell: UITableViewCell {
    
    @IBOutlet weak var imgFriend: UIImageView!
    @IBOutlet weak var lblFriendname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(objFriend: Friend) {
        self.lblFriendname.text = objFriend.username?.capitalized
        self.imgFriend.image = #imageLiteral(resourceName: "ic_user3")
    }
    
}
