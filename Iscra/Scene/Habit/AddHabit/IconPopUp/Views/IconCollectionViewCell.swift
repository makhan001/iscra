//
//  IconCollectionViewCell.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var view:UIView!
    @IBOutlet weak var img:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(iconArr: IconModel, theme: String) {
        img.image = UIImage(named: iconArr.iconName ?? "")
        if iconArr.value! == 1 {
            view.backgroundColor = UIColor(hex: theme)
            img.tintColor = .white
        }
        else {
            view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            img.tintColor = .black
        }
    }
    
}
extension UIImageView {
    override public func awakeFromNib() {
        super.awakeFromNib()
        tintColorDidChange()
    }
}
