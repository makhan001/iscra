//
//  HabitDaysCell.swift
//  Iscra
//
//  Created by mac on 21/10/21.
//

import UIKit

class HabitDaysCell: UICollectionViewCell,UIGestureRecognizerDelegate, Reusable {
    
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblDates: UILabel!
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var imgActive: UIImageView!
    var didMarkAsComplete:((Int) ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imgActive.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    func configure<T>(with content: T) { }
    
    func configure(item: HabitMark, colorTheme: String, tag: Int) {
        let str: String = ""
        self.imgActive.tag = item.habitID ?? 0
        self.lblDates.text = str.getDateFromTimeStamp(timeStamp : String(item.habitDay ?? 0), isDayName: false)
        self.lblDays.text = str.getDateFromTimeStamp(timeStamp : String(item.habitDay ?? 0), isDayName: true)
        if item.isCompleted == true {
            self.imgActive.image = #imageLiteral(resourceName: "ic-bluetick")
            self.imgActive.tintColor =  UIColor(hex: colorTheme)
        } else {
            self.imgActive.image = #imageLiteral(resourceName: "ic-Blanktick")
        }
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.didMarkAsComplete?(self.imgActive.tag)
    }
}

