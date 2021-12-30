//
//  HabitCell.swift
//  Iscra
//
//  Created by mac on 21/10/21.
//

import UIKit

class HabitCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var viewMates: UIView!
    @IBOutlet weak var viewNomates: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgHabit: UIImageView!
    @IBOutlet weak var lblHabitTitle: UILabel!
    @IBOutlet weak var imgHabitMates: UIImageView!
    @IBOutlet weak var lblHabitTitleMates: UILabel!
    @IBOutlet weak var collectionMates: UICollectionView! //HabitMatesCollectionView
    @IBOutlet weak var collectionDays: HabitDaysCollectionView!
    @IBOutlet weak var constraintWidth:NSLayoutConstraint!
    
    var viewModel: HomeViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionMates.register(UINib(nibName: "MatesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MatesCollectionCell")
        self.collectionMates.backgroundColor = UIColor.clear.withAlphaComponent(0)
        self.collectionMates.reloadData()
    }
    
    func configure<T>(with content: T) { }
    
    func configure(viewModel: HomeViewModel, item: AllHabits) {
        self.viewModel = viewModel
        self.viewModel.habitMarks = item.habitMarks ?? self.viewModel.habitMarks
        self.viewModel.groupMembers = item.groupMembers ?? self.viewModel.groupMembers
        self.collectionDays.configure(viewModel)
        self.populateData(item: item)
    }
    
    private func populateData(item: AllHabits) {
        if item.habitType != "group_habit" {
            self.viewNomates.isHidden = false
            self.viewMates.isHidden = true
            self.lblHabitTitle.text =  item.name?.capitalized
            self.imgHabit.image = UIImage(named: item.icon ?? "sport1")
            self.imgHabit.tintColor = UIColor(hex: item.colorTheme ?? viewModel.colorTheme)
        } else {
            self.viewNomates.isHidden = true
            self.viewMates.isHidden = false
            self.lblHabitTitleMates.text = item.name?.capitalized
            self.imgHabitMates.image = UIImage(named: item.icon ?? "sport1")
            self.imgHabitMates.tintColor = UIColor(hex: item.colorTheme ?? viewModel.colorTheme)
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if viewModel.habitMarks.isEmpty {
            self.constraintWidth.constant = 0
        } else {
            if viewModel.habitMarks.count <= 3 {
                self.constraintWidth.constant = CGFloat(( viewModel.habitMarks.count * 60))
            } else {
                self.constraintWidth.constant = CGFloat(( viewModel.habitMarks.count * 50))
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//extension HabitCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , CustomCollectionViewLayoutDelegate{
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return (collectionView == self.collectionDays) ? viewModel.habitMarks.count : viewModel.groupMembers.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == self.collectionDays {
//            let cell = collectionView.dequeueReusable(indexPath) as HabitDaysCell
//            cell.configure(viewModel: viewModel, item: viewModel.habitMarks[indexPath.row])
//            return cell
//        } else {
//            let cell = collectionView.dequeueReusable(indexPath) as MatesCollectionCell
////            guard let objGroupMembers = self.viewModel.groupMembers[indexPath.row] else {  return UICollectionViewCell()  }
////            cell.configureGroupMembers(obj: objGroupMembers)
//            return cell
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == self.collectionDays{
//            if viewModel.habitMarks.count <= 3 {
//                let width = Int(self.collectionDays.bounds.width) / viewModel.habitMarks.count
//                return CGSize(width: width, height: 125)
//            } else {
//                return CGSize(width: self.collectionDays.bounds.width/3.5, height: 125)
//            }
//        } else {
//            return CGSize(width: 35, height: 35)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, getSizeAtIndexPath indexPath: IndexPath) -> CGSize {
//        if collectionView == self.collectionDays{
//            return CGSize(width: 50, height: 125)
//        } else {
//            return CGSize(width: 35, height: 35)
//        }
//    }
//}
