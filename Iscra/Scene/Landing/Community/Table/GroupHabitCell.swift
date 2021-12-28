//
//  GroupHabitCell.swift
//  Iscra
//
//  Created by mac on 26/10/21.
//

import UIKit

class GroupHabitCell: UITableViewCell {

    @IBOutlet weak var imgHabit: UIImageView!
    @IBOutlet weak var lblHabitTitle: UILabel!
    @IBOutlet weak var lblHabitSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(obj: AllGroupHabit) {
        self.lblHabitTitle.text = obj.name?.capitalized
        self.lblHabitSubtitle.text = obj.allGroupHabitDescription
        let profilePic = obj.groupImage
        self.imgHabit.isHidden = true
        if profilePic != nil && profilePic != "<null>"  {
            self.imgHabit.isHidden = false
            let url = URL(string: profilePic!)
            self.imgHabit.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "ic-Rectangle"))
        } else {
            self.imgHabit.isHidden = true
        }
        
//        if indexPath.row == 1 || indexPath.row == 3 {
//        cell.imgHabit.isHidden = true
//        } else {
//            cell.imgHabit.isHidden = false
//        }
    }
}
