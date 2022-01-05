//
//  CommunityMyGroupsCell.swift
//  Iscra
//
//  Created by mac on 25/10/21.
//

import UIKit

class CommunityMyGroupsCell: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var viewMates: UIView!
    @IBOutlet weak var viewNomates: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var btnHabitDetail: UIButton!

    @IBOutlet weak var imgHabit: UIImageView! // imageHabit
    @IBOutlet weak var imgHabitMates: UIImageView! // imageHabitMates
    
    @IBOutlet weak var lblHabitTitle: UILabel!
    @IBOutlet weak var lblHabitTitleMates: UILabel!
    
    @IBOutlet weak var collectionMates: UICollectionView! // matesCollectionView
    @IBOutlet weak var daysCollectionView: HabitDaysCollectionView!
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
    var viewModel: CommunityViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionMates.register(UINib(nibName: "MatesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MatesCollectionCell")
        self.collectionMates.backgroundColor = UIColor.clear.withAlphaComponent(0)
        self.collectionMates.dataSource = self
        self.collectionMates.delegate = self
        self.collectionMates.reloadData()
    }
    
    func configure<T>(with content: T) { }
    
    func configure(viewModel: CommunityViewModel, groupHabit: GroupHabit ) {
        self.viewModel = viewModel
        self.viewModel.colorTheme = groupHabit.colorTheme ?? self.viewModel.colorTheme
        self.viewModel.habitMarks = groupHabit.habitMarks ?? self.viewModel.habitMarks
        self.viewModel.groupMembers = groupHabit.groupMembers ?? self.viewModel.groupMembers
        if groupHabit.habitType != "group_habit" {
            self.populateSingleHabit(groupHabit: groupHabit)
        } else {
            self.populateGroupHabit(groupHabit: groupHabit)
        }
        self.collectionMates.reloadData()
        self.daysCollectionView.configure(colorTheme: viewModel.colorTheme, habitMark: viewModel.habitMarks)
    }
    
    private func populateSingleHabit(groupHabit: GroupHabit) {
        self.viewNomates.isHidden = false
        self.viewMates.isHidden = true
        self.lblHabitTitle.text =  groupHabit.name?.capitalized
        self.imgHabit.image = UIImage(named: groupHabit.icon ?? "sport1")
        self.imgHabit.tintColor = UIColor(hex: groupHabit.colorTheme ?? self.viewModel.colorTheme)
    }
    
    private func populateGroupHabit(groupHabit: GroupHabit) {
        self.viewNomates.isHidden = true
        self.viewMates.isHidden = false
        self.lblHabitTitleMates.text = groupHabit.name?.capitalized
        self.imgHabitMates.image = UIImage(named: groupHabit.icon ?? "sport1")
        self.imgHabitMates.tintColor = UIColor(hex: groupHabit.colorTheme ?? self.viewModel.colorTheme)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource and UICollectionViewDelegateFlowLayout
extension CommunityMyGroupsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.daysCollectionView {
            return viewModel.habitMarks.count
        } else {
            return viewModel.groupMembers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.daysCollectionView {
            let cell = collectionView.dequeueReusable(indexPath) as HabitDaysCell
            cell.configure(item: viewModel.habitMarks[indexPath.item], colorTheme: viewModel.colorTheme)
            return cell
        } else {
            let cell = collectionView.dequeueReusable(indexPath) as MatesCollectionCell
            cell.configure(with: viewModel.groupMembers[indexPath.row].profileImage)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width / 3.0, height: 125.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5.0
    }

    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == self.daysCollectionView {
//            if !(viewModel.habitMarks.isEmpty) {
//                if viewModel.habitMarks.count <= 3 {
//                    return CGSize(width: Int(self.daysCollectionView.bounds.width) / viewModel.habitMarks.count - 10, height: 125)
//                } else {
//                    return CGSize(width: self.daysCollectionView.bounds.width/3.5, height: 125)
//                }
//            } else {
//                return CGSize(width: 45.0, height: 125.0)
//            }
//
//        } else {
//            return CGSize(width: 35, height: 35)
//        }
//    }
    
}
