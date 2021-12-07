//
//  HabitTableView.swift
//  Iscra
//
//  Created by mac on 21/10/21.
//

import UIKit

class  HabitTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var didSelectedAtIndex: ((Int) -> Void)?
    var habitList = [AllHabits]()
    var isHabitDelete:((_ isSelect:Bool, _ habitId: String)   ->())?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(habits: [AllHabits]) {
        self.register(UINib(nibName: "HabitCell", bundle: nil), forCellReuseIdentifier: "HabitCell")
        self.delegate = self
        self.dataSource = self
        self.habitList = habits
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.habitList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell") as? HabitCell else {
            return UITableViewCell()
        }
        let objHabitList = self.habitList[indexPath.row]
        cell.configure(obj: objHabitList)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("navigate")
        didSelectedAtIndex?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let objHabitList = self.habitList[indexPath.row]
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.isHabitDelete!(true, String(objHabitList.id!))
        })
        deleteAction.image = #imageLiteral(resourceName: "ic_deleteShadow")
        deleteAction.backgroundColor = UIColor(white: 1, alpha: 0.001)
        let swipeAction = UISwipeActionsConfiguration(actions:[deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
}
