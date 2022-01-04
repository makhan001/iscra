//
//  GroupHabitTableView.swift
//  Iscra
//
//  Created by mac on 26/10/21.
//

import UIKit

class GroupHabitTableView: UITableView {
    var count: Int = 0
    var arrGroupList = [AllGroupHabit]()
    var didSelectTableAtIndex:((Int) -> Void)?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(arrGroupList: [AllGroupHabit]) {
        self.register(UINib(nibName: "GroupHabitCell", bundle: nil), forCellReuseIdentifier: "GroupHabitCell")
        self.arrGroupList = arrGroupList
        self.setup()
    }
    
    private func setup() {
        dataSource = self
        delegate = self
        estimatedRowHeight = 70.0
        rowHeight = UITableView.automaticDimension
        tableFooterView = UIView(frame: .zero)
        separatorStyle = .none
        reloadData()
    }
}

extension GroupHabitTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGroupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupHabitCell") as? GroupHabitCell else {
            return UITableViewCell()
        }
        if self.arrGroupList.count > 0 {
        let objGroup = self.arrGroupList[indexPath.row]
        cell.configure(obj: objGroup)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectTableAtIndex?(indexPath.row)
    }
}
