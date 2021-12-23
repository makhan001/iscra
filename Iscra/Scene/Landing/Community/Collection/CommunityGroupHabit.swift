//
//  CommunityGroupHabit.swift
//  Iscra
//
//  Created by mac on 25/10/21.
//

import UIKit

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
        self.imgHabit.image = #imageLiteral(resourceName: "ic-Rectangle")
    }
    
}
