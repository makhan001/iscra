//
//  GroupHabitTableView.swift
//  Iscra
//
//  Created by mac on 26/10/21.
//

import UIKit

class GroupHabitTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var count: Int = 0
    var arrGroupList = [AllGroupHabit]() //[GroupHabit]()
    var navigateToDetail:((_ isSelect:Bool)   ->())?
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(arrGroupList: [AllGroupHabit]) {
        self.register(UINib(nibName: "GroupHabitCell", bundle: nil), forCellReuseIdentifier: "GroupHabitCell")
        self.delegate = self
        self.dataSource = self
        self.arrGroupList = arrGroupList
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGroupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupHabitCell") as? GroupHabitCell else {
            return UITableViewCell()
        }
        let objGroup = self.arrGroupList[indexPath.row]
        cell.configure(obj: objGroup)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetail!(true)
    }
        
}
