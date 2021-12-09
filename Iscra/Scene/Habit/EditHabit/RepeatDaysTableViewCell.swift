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
    
    func configure(day: weekStruct) {
        lblDayName.text = day.dayname.capitalized
        if day.isSelect == false {
            imgSelect.image = .none
        }else{
            imgSelect.image =  #imageLiteral(resourceName: "ic-checkmark")
        }

    }
    
}

