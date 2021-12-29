//
//  GroupMembersTableView.swift
//  Iscra
//
//  Created by mac on 29/12/21.
//

import UIKit

class GroupMembersTableView: UITableView {

        var viewModel: GroupMembersViewModel!

        override class func awakeFromNib() {
            super.awakeFromNib()
        }
        
        func configure(viewModel: GroupMembersViewModel) {
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

    extension GroupMembersTableView: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.arrGroupHabitMembers.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = self.dequeueReusable(indexPath) as CommunityFriendCell
          //  cell.configure(with: viewModel.arrGroupHabitMembers[indexPath.row])
            cell.configureMembers(with: viewModel.arrGroupHabitMembers[indexPath.row])
            return cell
        }
    }
