//
//  CommunityFriendTableView.swift
//  Iscra
//
//  Created by mac on 27/10/21.
//

import UIKit

class CommunityFriendTableView: UITableView {

    var viewModel: CommunitySearchViewModel!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(viewModel: CommunitySearchViewModel) {
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

extension CommunityFriendTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrFriend.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusable(indexPath) as CommunityFriendCell
        cell.configure(with: viewModel.arrFriend[indexPath.row])
        return cell
    }
}
