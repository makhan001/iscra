//
//  GroupFriendsCell.swift
//  Iscra
//
//  Created by mac on 11/11/21.
//

import UIKit

class GroupFriendsCell: UITableViewCell , Reusable {
    
    // MARK: - Outlets
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblFriendName: UILabel!
    @IBOutlet weak var imgFriend: UIImageView!
    @IBOutlet weak var btnHabitDetail: UIButton!
    @IBOutlet weak var collectiondays: UICollectionView!
    @IBOutlet weak var daysCollectionView: HabitDaysCollectionView!
    @IBOutlet weak var constraintWidth:NSLayoutConstraint!
    
    private let arr = ["1","1","1","1","1","1","1"]
    var member: Member!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgFriend.makeCircular()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if self.arr.count <= 3 {
            constraintWidth.constant =  CGFloat((self.arr.count * 60))
        } else {
            constraintWidth.constant =  CGFloat((self.arr.count * 50))
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure<T>(with content: T) {
        guard let item = content as? Member else { return }
        self.member = item
        self.lblFriendName.text = item.username?.lowercased()
        self.imgFriend.setImageFromURL(item.profileImage ?? "", with: AppConstant.UserPlaceHolderImage)
        self.daysCollectionView.configure(colorTheme: "", habitMark: item.habitMark ?? [], sourceScreen: .friend)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource and UICollectionViewDelegateFlowLayout
extension GroupFriendsCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return member.habitMark?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(indexPath) as HabitDaysCell
        cell.configure(with: member.habitMark?[indexPath.row])
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: Int(self.daysCollectionView.bounds.width) / self.arr.count , height: 125)
    }
}
