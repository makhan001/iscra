//
//  ChatNotificationPopUpViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 23/11/21.
//

import UIKit
import Quickblox



class ChatNotificationPopUpViewController: UIViewController, UIPopoverPresentationControllerDelegate, QBChatDelegate {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tableView: ChatNotificationTableView!
    var delegateNavigate: notificationPopUpClickManagerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
}

// MARK: Instance Methods
extension ChatNotificationPopUpViewController {
    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewBackground.addGestureRecognizer(tap)
        self.tableView.configure()
        tableView.delegateNavigate = self
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension ChatNotificationPopUpViewController: notificationPopUpClickManagerDelegate{
    func tableViewCellNavigation(performAction: notificationPopUpClickManager) {
//        switch performAction {
//        case .muteFor1Hour:
//           print("muteFor1Hour")
//        case .muteFor8Hour:
//            print("muteFor8Hour")
//        case .muteFor2days:
//            print("muteFor2Days")
//        case .muteForever:
//            print("muteForever")
//        case .leaveChat:
//            print("leaveChat")
//            self.LeaveChatAction()
//        }
        self.dismiss(animated: true, completion: nil)
        delegateNavigate?.tableViewCellNavigation(performAction: performAction)
        
    }

     
    
}
