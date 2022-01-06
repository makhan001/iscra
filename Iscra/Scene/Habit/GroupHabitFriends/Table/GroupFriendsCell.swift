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
    
    var viewModel: HabitCalenderViewModel!
    var member: Member!
    var showHabitDetail:((Int) ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgFriend.makeCircular()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure<T>(with content: T) {
    }
    
    func configure(viewModel: HabitCalenderViewModel, item: Member) {
        self.viewModel = viewModel
        self.member = item
        self.lblFriendName.text = item.username?.lowercased()
        self.imgFriend.setImageFromURL(item.profileImage ?? "", with: AppConstant.UserPlaceHolderImage)
        self.daysCollectionView.configure(colorTheme: self.viewModel.objHabitDetail?.colorTheme ?? "#7B86EB", habitMark: item.habitMark ?? [], sourceScreen: .friend)
    }
    
    private func setup() {
        btnHabitDetail.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        self.showHabitDetail?(sender.tag)
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
}
