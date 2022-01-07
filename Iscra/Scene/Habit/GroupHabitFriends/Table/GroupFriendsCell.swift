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
    var showHabitDetail:((Int) ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgFriend.makeCircular()
        self.setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        btnHabitDetail.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    
    func configure<T>(with content: T) {
    }
    
    func configure(viewModel: HabitCalenderViewModel, index: Int) {
        self.viewModel = viewModel
        self.viewModel.groupIndex = index
        self.btnHabitDetail.tag = index
        self.lblFriendName.text = viewModel.objHabitDetail?.members?[index].username?.lowercased()
        self.imgFriend.setImageFromURL(viewModel.objHabitDetail?.members?[index].profileImage ?? "", with: AppConstant.UserPlaceHolderImage)
        self.daysCollectionView.configure(colorTheme: self.viewModel.objHabitDetail?.colorTheme ?? "#7B86EB", habitMark: viewModel.objHabitDetail?.members?[index].habitMark ?? [], sourceScreen: .friend)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        self.showHabitDetail?(sender.tag)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource and UICollectionViewDelegateFlowLayout
extension GroupFriendsCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.objHabitDetail?.members?[viewModel.groupIndex].habitMark?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(indexPath) as HabitDaysCell
        cell.configure(with: viewModel.objHabitDetail?.members?[viewModel.groupIndex].habitMark?[indexPath.row])
        return cell
    }
}
