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
        self.imgFriend.layer.cornerRadius = imgFriend.frame.size.width / 2
        self.imgFriend.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(objFriend: Friend) {
        self.lblFriendname.text = objFriend.username?.capitalized
        let profilePic = objFriend.profileImage
            if profilePic != nil && profilePic != "<null>" {
              let url = URL(string: profilePic!)
                self.imgFriend.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "ic_user3"))
            }else{
                self.imgFriend.image = #imageLiteral(resourceName: "ic_user3")
            }
    }
}
