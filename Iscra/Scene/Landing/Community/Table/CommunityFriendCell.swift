//
//  CommunityFriendCell.swift
//  Iscra
//
//  Created by mac on 27/10/21.
//

import UIKit

class CommunityFriendCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var imageFriend: UIImageView! //
    @IBOutlet weak var lblFriendname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageFriend.makeCircular()
    }
    
    func configure<T>(with content: T) {
        guard let objFriend = content as? Friend else { return }
        self.lblFriendname.text = objFriend.username?.lowercased()
        self.imageFriend.setImageFromURL(objFriend.profileImage ?? "", with: #imageLiteral(resourceName: "ic_user3"))
    }
    
    func configureMembers<T>(with content: T) {
        guard let objGroupHabitMember = content as? GroupHabitMember else { return }
        self.lblFriendname.text = objGroupHabitMember.username?.lowercased()
        self.imageFriend.setImageFromURL(objGroupHabitMember.profileImage ?? "", with: #imageLiteral(resourceName: "ic_user3"))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
