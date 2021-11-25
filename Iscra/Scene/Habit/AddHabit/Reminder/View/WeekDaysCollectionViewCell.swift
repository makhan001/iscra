//
//  WeekDaysCollectionViewCell.swift
//  Iscra
//
//  Created by Lokesh Patil on 27/10/21.
//

import UIKit

class WeekDaysCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var view:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(day:weekStruct, selectedColor:ColorStruct){
        lblTitle.text = day.shortDayname
        view.layer.borderColor = UIColor(hex: selectedColor.colorHex)?.cgColor
        if day.isSelect == false{
            lblTitle.textColor = .black
            view.backgroundColor = .white
        }
        else{
            lblTitle.textColor = .white
            view.backgroundColor = UIColor(hex: selectedColor.colorHex)
        }
    }

}
