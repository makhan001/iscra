//
//  HabitTableView.swift
//  Iscra
//
//  Created by mac on 21/10/21.
//

import UIKit

class  HabitTableView: UITableView {
    
    var viewModel: HomeViewModel!
    var didSelectedAtIndex: ((Int) -> Void)?
    var didDeleteHabitAtIndex: ((Int) -> Void)?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.setup()
    }
    
    private func setup() {
        delegate = self
        dataSource = self
        reloadData()
    }
}

extension HabitTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.habitList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(indexPath) as HabitCell
        cell.configure(viewModel: viewModel, item: viewModel.habitList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectedAtIndex?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.didDeleteHabitAtIndex?(indexPath.row)
        })
        deleteAction.image = #imageLiteral(resourceName: "ic_deleteShadow")
        deleteAction.backgroundColor = UIColor(white: 1, alpha: 0.001)
        let swipeAction = UISwipeActionsConfiguration(actions:[deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
}
