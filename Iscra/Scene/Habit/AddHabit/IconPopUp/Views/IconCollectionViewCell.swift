//
//  IconCollectionViewCell.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var view:UIView!
    @IBOutlet weak var img:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure<T>(with content: T) { }
    
    func configure(item: IconModel, theme: String) {
        img.image = UIImage(named: item.iconName )
        if item.isSelected {
            self.view.backgroundColor = UIColor(hex: theme)
            self.img.tintColor = .white
        } else {
            self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.img.tintColor = .black
        }
    }
    
}
extension UIImageView {
    override public func awakeFromNib() {
        super.awakeFromNib()
        tintColorDidChange()
    }
}
