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
    
    @IBOutlet weak var lblHabitTitle: UILabel!
    @IBOutlet weak var lblHabitTitleMates: UILabel!
    
    @IBOutlet weak var imgHabit: UIImageView!
    @IBOutlet weak var imgHabitMates: UIImageView!
    
    @IBOutlet weak var constraintWidth:NSLayoutConstraint!
    
    @IBOutlet weak var daysCollectionView: HabitDaysCollectionView!
    @IBOutlet weak var matesCollectionView: HabitMatesCollectionView!
    
    var viewModel: HomeViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure<T>(with content: T) { }
    
    func configure(viewModel: HomeViewModel, item: AllHabits) {
        self.viewModel = viewModel
        self.viewModel.habitMarks = item.habitMarks ?? self.viewModel.habitMarks
        self.viewModel.groupMembers = item.groupMembers ?? self.viewModel.groupMembers
        self.daysCollectionView.configure(colorTheme: viewModel.colorTheme, habitMark: viewModel.habitMarks)
        self.matesCollectionView.configure(groupMember: viewModel.groupMembers)
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
//        if viewModel.habitMarks.isEmpty {
//            self.constraintWidth.constant = 0
//        } else {
//            if viewModel.habitMarks.count <= 3 {
//                self.constraintWidth.constant = CGFloat(( viewModel.habitMarks.count * 60))
//            } else {
//                self.constraintWidth.constant = CGFloat(( viewModel.habitMarks.count * 50))
//            }
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
