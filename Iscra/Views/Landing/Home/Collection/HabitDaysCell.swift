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
    
    func configure() {
       // self.btnActive.setImage( #imageLiteral(resourceName: "google"), for: .normal)
        self.imgActive.image = #imageLiteral(resourceName: "ic-bluetick")
        self.lblDays.text = "Sun"
        self.lblDates.text = "4"
    }
}
