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
    func configure(day:weekStruct){
        lblTitle.text = day.shortDayname
        if day.isSelect == false{
            lblTitle.textColor = .black
            view.backgroundColor = .white
        }
        else{
            lblTitle.textColor = .white
            view.backgroundColor = UIColor.init(named: "BlueAccent")
        }
    }

}
