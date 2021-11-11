//
//  IconHeaderCollectionViewCell.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import UIKit

class IconHeaderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewBottomBar:UIView!
    @IBOutlet weak var lblTitle:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(title:String, SelecedIndex:Int, index:Int){
        lblTitle.text = title
        print("SelecedIndex\(SelecedIndex)")
        print("Index\(index)")
        if SelecedIndex == index{
            viewBottomBar.isHidden = false
            lblTitle.textColor = UIColor(named: "BlackAccent")
        }
        else {
            viewBottomBar.isHidden = true
            lblTitle.textColor = UIColor(named: "GrayAccent")
        }
    }
}
