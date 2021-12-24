//
//  CommunityFriendTableView.swift
//  Iscra
//
//  Created by mac on 27/10/21.
//

import UIKit

class CommunityFriendTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var count: Int = 0
    var arrFriend = [Friend]()

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(arrFriend: [Friend]) {
        self.register(UINib(nibName: "CommunityFriendCell", bundle: nil), forCellReuseIdentifier: "CommunityFriendCell")
        self.delegate = self
        self.dataSource = self
        self.arrFriend = arrFriend
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFriend.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityFriendCell") as? CommunityFriendCell else {
            return UITableViewCell()
        }
        let objFriend = self.arrFriend[indexPath.row]
        cell.configure(objFriend: objFriend)
        return cell
    }
    
}
