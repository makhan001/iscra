//
//  HabitTableView.swift
//  Iscra
//
//  Created by mac on 21/10/21.
//

import UIKit

protocol HabitTableNavigation: class {
    func navigate()
}

class  HabitTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var count: Int = 0
    weak var delegate1 : HabitTableNavigation?
    var didSelectedAtIndex: ((Int) -> Void)?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(obj: Int) {
        self.register(UINib(nibName: "HabitCell", bundle: nil), forCellReuseIdentifier: "HabitCell")
        self.delegate = self
        self.dataSource = self
        self.count = obj
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell") as? HabitCell else {
            return UITableViewCell()
        }
        cell.configure()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("navigate")
//        delegate1?.navigate()
        didSelectedAtIndex?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
        })
        deleteAction.image = #imageLiteral(resourceName: "ic_deleteShadow")
        deleteAction.backgroundColor = UIColor(white: 1, alpha: 0.001)
        let swipeAction = UISwipeActionsConfiguration(actions:[deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
}
