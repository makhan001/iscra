//
//  ColorCollectionViewCell.swift
//  Iscra
//
//  Created by Lokesh Patil on 25/10/21.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(color:ColorStruct){
        colorView.backgroundColor = UIColor(hex: color.colorHex)
        if color.isSelect == true {
            colorView.layer.borderWidth = 4
            colorView.layer.borderColor = #colorLiteral(red: 0.7450980392, green: 0.7647058824, blue: 0.9568627451, alpha: 1)
        }else {
            colorView.layer.borderWidth = 0
            colorView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
}
