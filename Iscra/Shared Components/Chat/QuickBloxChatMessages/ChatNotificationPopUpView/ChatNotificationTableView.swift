//
//  ChatNotificationTableView.swift
//  Iscra
//
//  Created by Dr.Mac on 23/11/21.
//

import UIKit
protocol notificationPopUpClickManagerDelegate{
    func tableViewCellNavigation(performAction: notificationPopUpClickManager)
}
enum notificationPopUpClickManager {
    case muteFor1Hour
    case muteFor8Hour
    case muteFor2days
    case muteForever
    case leaveChat
}
struct ChatNotification {
    let titleNotifictaion: String
    var notificationPopUpClickManager : notificationPopUpClickManager
}

class ChatNotificationTableView: UITableView {

    // MARK:-Outlets and variables
    let itemsChatNotification = [
        ChatNotification(titleNotifictaion: "Mute for 1 hour", notificationPopUpClickManager: .muteFor1Hour),
        ChatNotification(titleNotifictaion: "Mute for 8 hour", notificationPopUpClickManager: .muteFor8Hour),
        ChatNotification(titleNotifictaion: "Mute for 2 days", notificationPopUpClickManager: .muteFor2days),
        ChatNotification(titleNotifictaion: "Mute forever", notificationPopUpClickManager: .muteForever),
        ChatNotification(titleNotifictaion: "Leave the chat", notificationPopUpClickManager: .leaveChat)]
    var delegateNavigate: notificationPopUpClickManagerDelegate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure() {
        self.tableFooterView = UIView(frame: .zero)
        self.separatorStyle = .none
        self.register(UINib(nibName: "ChatNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatNotificationTableViewCell")
        self.delegate = self
        self.dataSource = self
        reloadData()
    }

}
// MARK:- TableView Method
extension ChatNotificationTableView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsChatNotification.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatNotificationTableViewCell") as? ChatNotificationTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(itemsChatNotification: itemsChatNotification[indexPath.row], index: indexPath.row)
       
        
        return cell
    }
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegateNavigate?.tableViewCellNavigation(performAction: itemsChatNotification[indexPath.row].notificationPopUpClickManager)
      }
}

