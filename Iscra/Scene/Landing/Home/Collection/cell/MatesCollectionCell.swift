//
//  MatesCollectionCell.swift
//  Iscra
//
//  Created by mac on 21/10/21.
//

import UIKit

class MatesCollectionCell: UICollectionViewCell, Reusable {
  
    // MARK: - Outlets
    @IBOutlet weak var imgMatesMember: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure<T>(with content: T) {
        
    }
    
    
    func configure() {
        self.imgMatesMember.image = #imageLiteral(resourceName: "ic_user1")
    }
    
    func configureGroupHabitMembers(obj: UsersProfileImageURL) {
        self.imgMatesMember.setImageFromURL(obj.profileImage ?? "", with: #imageLiteral(resourceName: "ic_user1"))
    }
    
    func configureGroupMembers(obj: GroupMember) {
        self.imgMatesMember.setImageFromURL(obj.profileImage ?? "", with: AppConstant.UserPlaceHolderImage)
    }
}