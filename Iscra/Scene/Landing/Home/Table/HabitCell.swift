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
    
    @IBOutlet weak var btnHabitDetail: UIButton!
    @IBOutlet weak var constraintWidth:NSLayoutConstraint!
    
    @IBOutlet weak var daysCollectionView: HabitDaysCollectionView!
    @IBOutlet weak var matesCollectionView: HabitMatesCollectionView!
    
    var viewModel: HomeViewModel!
    var showHabitDetail:((Int) ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {
        btnHabitDetail.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    func configure<T>(with content: T) { }
    
    func configure(viewModel: HomeViewModel, item: AllHabits, tag:Int) {
        self.viewModel = viewModel
        self.viewModel.habitMarks = item.habitMarks ?? self.viewModel.habitMarks
        self.viewModel.groupMembers = item.groupMembers ?? self.viewModel.groupMembers
        self.daysCollectionView.configure(colorTheme: item.colorTheme ?? viewModel.colorTheme, habitMark: viewModel.habitMarks)
        self.matesCollectionView.configure(groupMember: viewModel.groupMembers)
        self.btnHabitDetail.tag = tag
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
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        self.showHabitDetail?(sender.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
