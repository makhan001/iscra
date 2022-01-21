//
//  MatesCollectionCell.swift
//  Iscra
//
//  Created by mac on 21/10/21.
//

import UIKit

class MatesCollectionCell: UICollectionViewCell, Reusable {
  
    // MARK: - Outlets
    @IBOutlet weak var imageMember: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure<T>(with content: T) {
        self.imageMember.setImageFromURL(content as? String ?? "", with: AppConstant.UserPlaceHolderImage)
    }
}
