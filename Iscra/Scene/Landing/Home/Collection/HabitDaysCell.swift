//
//  HabitDaysCell.swift
//  Iscra
//
//  Created by mac on 21/10/21.
//

import UIKit

class HabitDaysCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblDates: UILabel!
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var imgActive: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureHabitDays(obj: HabitMark ,colorTheme: String ) {
        let str: String = ""
        self.lblDates.text = str.getDateFromTimeStamp(timeStamp : String(obj.habitDay!), isDayName: false)
        self.lblDays.text = str.getDateFromTimeStamp(timeStamp : String(obj.habitDay!) , isDayName: true)
        if obj.isCompleted == true{
            self.imgActive.image = #imageLiteral(resourceName: "ic-bluetick")
            self.imgActive.tintColor =  UIColor(hex: colorTheme)
        } else {
            self.imgActive.image = #imageLiteral(resourceName: "ic-Blanktick")
        }
    }
    
    func configure() {
        self.imgActive.image = #imageLiteral(resourceName: "ic-bluetick")
        self.imgActive.tintColor = UIColor(hex:"#ffEB7B7B")
        self.lblDays.text = "Sun"
        self.lblDates.text = "4"
    }
    
}
