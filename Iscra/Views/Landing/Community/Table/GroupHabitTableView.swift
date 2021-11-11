//
//  GroupHabitTableView.swift
//  Iscra
//
//  Created by mac on 26/10/21.
//

import UIKit

class GroupHabitTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var count: Int = 0
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(obj: Int) {
        self.register(UINib(nibName: "GroupHabitCell", bundle: nil), forCellReuseIdentifier: "GroupHabitCell")
        self.delegate = self
        self.dataSource = self
        self.count = obj
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupHabitCell") as? GroupHabitCell else {
            return UITableViewCell()
        }
        cell.lblHabitTitle.text = "Learn English"
        cell.lblHabitSubtitle.text = "I created this group to build new habit to learn foreign language."
        cell.imgHabit.image = #imageLiteral(resourceName: "ic-Rectangle")
        
        if indexPath.row == 1 || indexPath.row == 3 {
        cell.imgHabit.isHidden = true
        }else{
            cell.imgHabit.isHidden = false
        }
        return cell
    }
        
}
