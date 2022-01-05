//
//  IconHeaderCollectionViewCell.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import UIKit

class IconHeaderCollectionViewCell: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var viewBottomBar:UIView!
    @IBOutlet weak var lblTitle:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure<T>(with content: T) { }
    
    func configure(title:String, isSelected: Bool) {
        self.lblTitle.text = title
        if isSelected {
            self.viewBottomBar.isHidden = false
            self.lblTitle.textColor = UIColor(named: "BlackAccent")
        } else {
            self.viewBottomBar.isHidden = true
            self.lblTitle.textColor = UIColor(named: "GrayAccent")
        }
    }
}
