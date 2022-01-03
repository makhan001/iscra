//
//  CommunityGroupHabit.swift
//  Iscra
//
//  Created by mac on 25/10/21.
//

import UIKit
import SDWebImage
class CommunityGroupHabit: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var imgHabit: UIImageView!
    @IBOutlet weak var lblHabitTitle: UILabel!
    @IBOutlet weak var lblHabitSubtitle: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure<T>(with content: T) {
        guard let item = content as? Invitaion else { return }
        self.lblHabitTitle.text = item.name?.capitalized
        self.lblHabitSubtitle.text = item.invitaionDescription
        self.imgHabit.setImageFromURL(item.groupImage ?? "", with: #imageLiteral(resourceName: "ic-Rectangle"))
    }
}
