//
//  ShareHabitTableView.swift
//  Iscra
//
//  Created by mac on 30/12/21.
//

import UIKit

class ShareHabitTableView: UITableView {
    
    var viewModel: ShareHabitViewModel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(viewModel: ShareHabitViewModel) {
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

extension ShareHabitTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrFriend.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusable(indexPath) as CommunityFriendCell
        cell.configure(with: viewModel.arrFriend[indexPath.row])
        let id = viewModel.arrFriend[indexPath.row].id ?? 0
        if self.viewModel.arrSelectedUsers.contains(id) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let obj = viewModel.arrFriend[indexPath.row]
        guard let id = obj.id else { return }
        if viewModel.arrSelectedUsers.contains(id) {
            if let index = viewModel.arrSelectedUsers.firstIndex(where: { $0 == id }) {
                viewModel.arrSelectedUsers.remove(at: index)
            }
        } else {
            self.viewModel.arrSelectedUsers.append(id)
            print("viewModel.arrSelectedUsers is \(viewModel.arrSelectedUsers)")
        }
       reloadData()
    }
}
