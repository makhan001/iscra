//
//  MatesCollectionCell.swift
//  Iscra
//
//  Created by mac on 21/10/21.
//

import UIKit

class MatesCollectionCell: UICollectionViewCell {
  
    // MARK: - Outlets
    @IBOutlet weak var imgMatesMember: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure() {
        self.imgMatesMember.image = #imageLiteral(resourceName: "ic_user1")
    }
}
