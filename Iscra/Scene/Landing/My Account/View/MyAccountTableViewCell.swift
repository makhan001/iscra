//
//  MyAccountTableViewCell.swift
//  Iscra
//
//  Created by Dr.Mac on 21/10/21.
//

import UIKit

class MyAccountTableViewCell: UITableViewCell {

    // MARK:-Outlets and variables
    
    @IBOutlet weak var imageMyAccountIcon: UIImageView!
    @IBOutlet weak var lblMyAccountTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(item: MyAccount) {
        lblMyAccountTitle.text = item.titleName
        imageMyAccountIcon.image = UIImage(named:item.titleImage)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
