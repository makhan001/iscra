//
//  RepeatDaysTableViewCell.swift
//  Iscra
//
//  Created by mac on 03/11/21.
//

import UIKit

class RepeatDaysTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDayName: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(day: WeekDays) {
        lblDayName.text = day.dayname.capitalized
        if day.isSelected == false {
            imgSelect.image = .none
        } else {
            imgSelect.image =  #imageLiteral(resourceName: "ic-checkmark")
        }

    }
    
}

