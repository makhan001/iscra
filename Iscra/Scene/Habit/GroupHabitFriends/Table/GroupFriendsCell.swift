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
    @IBOutlet weak var collectiondays: UICollectionView!
    @IBOutlet weak var constraintWidth:NSLayoutConstraint!
    
    private let arr = ["1","1","1","1","1","1","1"]
    var colorTheme: String = ""
    var arrHabitMarks: [HabitMark]?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectiondays.register(UINib(nibName: "HabitDaysCell", bundle: nil), forCellWithReuseIdentifier: "HabitDaysCell")
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
        guard let objMember = content as? Member else { return }
        self.lblFriendName.text = objMember.username?.lowercased()
        self.imgFriend.setImageFromURL(objMember.profileImage ?? "", with: #imageLiteral(resourceName: "ic_user3"))
        self.arrHabitMarks = objMember.habitMark
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource and UICollectionViewDelegateFlowLayout
extension GroupFriendsCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrHabitMarks?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectiondays.dequeueReusableCell(withReuseIdentifier: "HabitDaysCell", for: indexPath) as? HabitDaysCell else {
            return UICollectionViewCell()
        }
        
        guard let objHabitMarks = self.arrHabitMarks?[indexPath.row] else {  return UICollectionViewCell()  }
//        cell.configureHabitDays(obj: objHabitMarks, colorTheme: self.colorTheme )
        return cell

    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: Int(self.collectiondays.bounds.width) / self.arr.count , height: 125)   // deepak
    }
}
