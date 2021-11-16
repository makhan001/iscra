//
//  GroupFriendsCell.swift
//  Iscra
//
//  Created by mac on 11/11/21.
//

import UIKit

class GroupFriendsCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblFriendName: UILabel!
    @IBOutlet weak var imgFriend: UIImageView!
    @IBOutlet weak var collectiondays: UICollectionView!
    @IBOutlet weak var constraintWidth:NSLayoutConstraint!
    
    private let arr = ["1","1","1","1","1","1","1"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectiondays.register(UINib(nibName: "HabitDaysCell", bundle: nil), forCellWithReuseIdentifier: "HabitDaysCell")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if self.arr.count <= 3 {
            constraintWidth.constant =  CGFloat((self.arr.count * 60))
        }else{
            constraintWidth.constant =  CGFloat((self.arr.count * 50))
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure() {
        self.lblFriendName.text = "Mary"
        self.imgFriend.image = #imageLiteral(resourceName: "ic-MaleCommunity1")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource and UICollectionViewDelegateFlowLayout
extension GroupFriendsCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectiondays.dequeueReusableCell(withReuseIdentifier: "HabitDaysCell", for: indexPath) as? HabitDaysCell else {
            return UICollectionViewCell()
        }
        cell.configure()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(self.collectiondays.bounds.width) / self.arr.count , height: 125)
    }
}