//
//  HabitDaysCell.swift
//  Iscra
//
//  Created by mac on 21/10/21.
//

import UIKit

class HabitDaysCell: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblDates: UILabel!
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var imgActive: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure<T>(with content: T) { }
    
    func configure(item: HabitMark, colorTheme: String) {
        let str: String = ""
        self.lblDates.text = str.getDateFromTimeStamp(timeStamp : String(item.habitDay ?? 0), isDayName: false)
        self.lblDays.text = str.getDateFromTimeStamp(timeStamp : String(item.habitDay ?? 0), isDayName: true)
        if item.isCompleted == true {
            self.imgActive.image = #imageLiteral(resourceName: "ic-bluetick")
            self.imgActive.tintColor =  UIColor(hex: colorTheme)
        } else {
            self.imgActive.image = #imageLiteral(resourceName: "ic-Blanktick")
        }
    }
}

