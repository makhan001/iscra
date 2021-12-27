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

class  GroupHabitFriendsTable: UITableView, UITableViewDataSource, UITableViewDelegate {
    // MARK: Varibles
    private var count: Int = 0
    weak var friendTableNavigationDelegate: FriendTableNavigation?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
        
    func configure(obj: Int) {
        self.register(UINib(nibName: "GroupFriendsCell", bundle: nil), forCellReuseIdentifier: "GroupFriendsCell")
        self.delegate = self
        self.dataSource = self
        self.count = obj
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupFriendsCell") as? GroupFriendsCell else {
            return UITableViewCell()
        }
        cell.configure()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        friendTableNavigationDelegate?.didNavigateToCalender()
    }
}
