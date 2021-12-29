//
//  GroupHabitFriendsTable.swift
//  Iscra
//
//  Created by mac on 11/11/21.
//

import UIKit
protocol FriendTableNavigation: class {
    func didNavigateToCalender()
}

class  GroupHabitFriendsTable: UITableView {
    
    // MARK: Varibles
    var viewModel: HabitCalenderViewModel!
    weak var friendTableNavigationDelegate: FriendTableNavigation?

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(viewModel: HabitCalenderViewModel) {
        self.viewModel = viewModel
        self.setup()
    }
    
    private func setup() {
        dataSource = self
        delegate = self
        estimatedRowHeight = 70.0
        rowHeight = UITableView.automaticDimension
        tableFooterView = UIView(frame: .zero)
        separatorStyle = .none
    }
}

extension GroupHabitFriendsTable: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.objHabitDetail?.members?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusable(indexPath) as GroupFriendsCell
        cell.configure(with: self.viewModel.objHabitDetail?.members?[indexPath.row])
       // cell.configure(with: self.viewModel.objHabitDetail?.members?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        friendTableNavigationDelegate?.didNavigateToCalender()
    }
}
