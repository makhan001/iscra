//
//  CommunityGroupHabit.swift
//  Iscra
//
//  Created by mac on 25/10/21.
//

import UIKit
import SDWebImage
class CommunityGroupHabit: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imgHabit: UIImageView!
    @IBOutlet weak var lblHabitTitle: UILabel!
    @IBOutlet weak var lblHabitSubtitle: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
    func configure(obj: Invitaion) {
        self.lblHabitTitle.text = obj.name?.capitalized
        self.lblHabitSubtitle.text = obj.invitaionDescription

        let profilePic = obj.groupImage
        if profilePic != nil && profilePic != "<null>"  {
            let url = URL(string: profilePic!)
            self.imgHabit.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "ic-Rectangle"))
        } else {
            self.imgHabit.image = #imageLiteral(resourceName: "ic-Rectangle")
        }
    }
}
