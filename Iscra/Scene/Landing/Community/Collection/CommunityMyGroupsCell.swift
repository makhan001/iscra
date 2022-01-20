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
    
    @IBOutlet weak var imageHabit: UIImageView!
    @IBOutlet weak var imageHabitMates: UIImageView!
    
    @IBOutlet weak var lblHabitTitle: UILabel!
    @IBOutlet weak var lblHabitTitleMates: UILabel!
    
    @IBOutlet weak var matesCollectionView: UICollectionView!
    @IBOutlet weak var daysCollectionView: HabitDaysCollectionView!
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
    var viewModel: CommunityViewModel!
    var showHabitDetail:((Int) ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
        self.matesCollectionView.register(UINib(nibName: "MatesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MatesCollectionCell")
        self.matesCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        self.matesCollectionView.dataSource = self
        self.matesCollectionView.delegate = self
        self.matesCollectionView.reloadData()
    }
    
    private func setup() {
        btnHabitDetail.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    func configure<T>(with content: T) { }
    
    func configure(viewModel: CommunityViewModel, groupHabit: GroupHabit , tag:Int ) {
        self.btnHabitDetail.tag = tag
        self.viewModel = viewModel
        self.viewModel.colorTheme = groupHabit.colorTheme ?? self.viewModel.colorTheme
        self.viewModel.habitMarks = groupHabit.habitMarks ?? self.viewModel.habitMarks
        self.viewModel.groupMembers = groupHabit.groupMembers ?? self.viewModel.groupMembers
        if groupHabit.habitType != "group_habit" {
            self.populateSingleHabit(groupHabit: groupHabit)
        } else {
            self.populateGroupHabit(groupHabit: groupHabit)
        }
        self.matesCollectionView.reloadData()
        self.daysCollectionView.configure(colorTheme: viewModel.colorTheme, habitMark: viewModel.habitMarks)
    }
    
    private func populateSingleHabit(groupHabit: GroupHabit) {
        self.viewNomates.isHidden = false
        self.viewMates.isHidden = true
        self.lblHabitTitle.text =  groupHabit.name?.capitalized
        self.imageHabit.image = UIImage(named: groupHabit.icon ?? "sport1")
        self.imageHabit.tintColor = UIColor(hex: groupHabit.colorTheme ?? self.viewModel.colorTheme)
    }
    
    private func populateGroupHabit(groupHabit: GroupHabit) {
        self.viewNomates.isHidden = true
        self.viewMates.isHidden = false
        self.lblHabitTitleMates.text = groupHabit.name?.capitalized
        self.imageHabitMates.image = UIImage(named: groupHabit.icon ?? "sport1")
        self.imageHabitMates.tintColor = UIColor(hex: groupHabit.colorTheme ?? self.viewModel.colorTheme)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        self.showHabitDetail?(sender.tag)
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
            cell.configure(item: viewModel.habitMarks[indexPath.item], colorTheme: viewModel.colorTheme, tag: indexPath.row)
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
    
}
