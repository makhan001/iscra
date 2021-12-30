//
//  CommunityFriendCell.swift
//  Iscra
//
//  Created by mac on 27/10/21.
//

import UIKit

class CommunityFriendCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var lblFriendname: UILabel!
    @IBOutlet weak var imageFriend: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageFriend.makeCircular()
    }
    
    func configure<T>(with content: T) {
        if let objFriend = content as? Friend {
            self.lblFriendname.text = objFriend.username?.lowercased()
            self.imageFriend.setImageFromURL(objFriend.profileImage ?? "", with: AppConstant.UserPlaceHolderImage)
        }
        
        if let objGroupHabitMember = content as? GroupHabitMember {
            self.lblFriendname.text = objGroupHabitMember.username?.lowercased()
            self.imageFriend.setImageFromURL(objGroupHabitMember.profileImage ?? "", with: AppConstant.UserPlaceHolderImage)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
