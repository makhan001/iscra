//
//  UsersInfoTableViewController.swift
//  sample-chat-swift
//
//  Created by Injoit on 1/28/19.
//  Copyright © 2019 Quickblox. All rights reserved.
//

import Foundation
import UIKit
import Quickblox
import SVProgressHUD


struct UsersInfoConstant {
    static let perPage:UInt = 10
    static let delivered = "Message delivered to"
    static let viewed = "Message viewed by"
}

class UsersInfoTableViewController: UITableViewController {
    
    //MARK: - Properties
    /**
     *  This property is required when creating a ChatViewController.
     */
    var dialogID: String! {
        didSet {
            self.dialog = chatManager.storage.dialog(withID: dialogID)
        }
    }
    var dataSource: ChatDataSource?
    var currentUser = Profile()
    var message: QBChatMessage?
    var action: ChatAction?
    private var titleView = TitleView()
    private var dialog: QBChatDialog!
    var users : [QBUUser] = []
    let chatManager = ChatManager.instance
    private lazy var addUsersItem = UIBarButtonItem(image: UIImage(named: "add_user"),
                                                    style: .plain,
                                                    target: self,
                                                    action:#selector(didTapAddUsers(_:)))
    //MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // online/offline for group and public chats
        dialog.onJoinOccupant = { [weak self] userID in
            guard let self = self else {
                return
            }
            if let onlineUser = self.users.filter({ $0.id == userID }).first, let index = self.users.index(of: onlineUser) {
                self.users.remove(at: index)
                self.users.insert(onlineUser, at: 0)
                let indexPath = IndexPath(item: index, section: 0)
                let indexPathFirst = IndexPath(item: 0, section: 0)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .left)
                self.tableView.insertRows(at: [indexPathFirst], with: .left)
                self.tableView.endUpdates()
            }
        }
        
        navigationItem.titleView = titleView
        
        tableView.register(UINib(nibName: UserCellConstant.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: UserCellConstant.reuseIdentifier)
        
        chatManager.delegate = self
        QBChat.instance.addDelegate(self)

        setupUsers(dialogID)
        
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "ic_Back_Image"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapBack(_:)))
        navigationItem.leftBarButtonItem = backButtonItem
        backButtonItem.tintColor = #colorLiteral(red: 0.8031229377, green: 0.691909194, blue: 0.2029924691, alpha: 1)
        
        navigationItem.rightBarButtonItem = addUsersItem
        if action == ChatAction.ChatInfo {
            addUsersItem.tintColor = .white
            addUsersItem.isEnabled = true
        } else {
            addUsersItem.tintColor = .clear
            addUsersItem.isEnabled = false
        }
    }
    
    //MARK: - Internal Methods
    private func setupNavigationTitleByAction() {
        var title = dialog.name ?? ""
        if action == .ViewedBy {
            title = UsersInfoConstant.viewed
        } else if action == .DeliveredTo {
            title = UsersInfoConstant.delivered
        }
        
        let numberUsers = "\(self.users.count) members"
        titleView.setupTitleView(title: title, subTitle: numberUsers)
    }
    
    //MARK: - Actions
    @objc func didTapBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapAddUsers(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "SA_STR_SEGUE_GO_TO_ADD_OPPONENTS".localized, sender: nil)
    }
    
    //MARK: - Internal Methods
    private func updateUsers() {
        guard let occupantIDs = dialog.occupantIDs else {
            return
        }
        if occupantIDs.isEmpty == false {
            setupUsers(dialogID)
        }
    }
    
    private func setupUsers(_ dialogID: String) {
        guard currentUser.isFull == true else {
            return
        }
        self.users = chatManager.storage.users(with: dialogID)
        
        if let message = message, let action = action {
            if action == .ViewedBy {
                var readUsers: [QBUUser] = []
                //check and add users who read the message
                if let readIDs = message.readIDs,
                    readIDs.isEmpty == false {
                    for readID in readIDs {
                        if readID.uintValue == currentUser.ID {
                            continue
                        }
                        if let user = chatManager.storage.user(withID: readID.uintValue) {
                            readUsers.append(user)
                        }
                    }
                }
                self.users = readUsers
            } else if action == .DeliveredTo {
                var deliveredUsers: [QBUUser] = []
                //check and add users who read the message
                if let deliveredIDs = message.deliveredIDs,
                    deliveredIDs.isEmpty == false {
                    for deliveredID in deliveredIDs {
                        if deliveredID.uintValue == currentUser.ID {
                            continue
                        }
                        if let user = chatManager.storage.user(withID: deliveredID.uintValue) {
                            deliveredUsers.append(user)
                        }
                    }
                }
                self.users = deliveredUsers
            }
        }
        setupNavigationTitleByAction()
        tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    //MARK: - Overrides
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SA_STR_SEGUE_GO_TO_ADD_OPPONENTS".localized {
            guard let addOccupantsVC = segue.destination as? AddOccupantsVC else {
                return
            }
            addOccupantsVC.dialogID = dialogID
        }
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCellConstant.reuseIdentifier,
                                                       for: indexPath) as? UserTableViewCell else {
                                                        return UITableViewCell()
        }
        let user = self.users[indexPath.row]
        cell.userColor = user.id.generateColor()
        let userName = user.fullName ?? user.login ?? "QB user"
        if currentUser.ID == user.id {

            cell.userNameLabel.text = userName + " (You)"
        } else {
            cell.userNameLabel.text = userName
        }
        
        cell.userAvatarLabel.text = String(user.fullName?.capitalized.first ?? Character("U"))
        cell.tag = indexPath.row
        cell.checkBoxView.isHidden = true
        cell.checkBoxImageView.isHidden = true
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}

// MARK: - ChatManagerDelegate
extension UsersInfoTableViewController: ChatManagerDelegate {
    func chatManagerWillUpdateStorage(_ chatManager: ChatManager) {
        SVProgressHUD.show(withStatus: "SA_STR_LOADING_USERS".localized)
    }
    
    func chatManager(_ chatManager: ChatManager, didFailUpdateStorage message: String) {
        SVProgressHUD.showError(withStatus: message)
    }
    
    func chatManager(_ chatManager: ChatManager, didUpdateChatDialog chatDialog: QBChatDialog) {
        if chatDialog.id == dialogID {
            updateUsers()
        }
        SVProgressHUD.dismiss()
    }
    
    func chatManager(_ chatManager: ChatManager, didUpdateStorage message: String) {
        SVProgressHUD.showSuccess(withStatus: message)
        
        guard let dialogID = dialogID else {
            return
        }
        setupUsers(dialogID)
    }
}

//MARK: - QBChatDelegate
extension UsersInfoTableViewController: QBChatDelegate {
    func chatDidReadMessage(withID messageID: String, dialogID: String, readerID: UInt) {
        if Profile().ID == readerID
            || dialogID != self.dialogID
            || action != ChatAction.ViewedBy
            || messageID != self.message?.id {
            return
        }
        guard let dataSource = dataSource,let message = dataSource.messageWithID(messageID),
            message.readIDs?.contains(NSNumber(value: readerID)) == false else {
            return
        }
        message.readIDs?.append(NSNumber(value: readerID))
        dataSource.updateMessage(message)
        self.message = message
        updateUsers()
    }
    
    func chatDidDeliverMessage(withID messageID: String, dialogID: String, toUserID userID: UInt) {
        if Profile().ID == userID
            || dialogID != self.dialogID
            || action != ChatAction.DeliveredTo
            || messageID != self.message?.id {
            return
        }
        
        guard let message = self.message, message.deliveredIDs?.contains(NSNumber(value: userID)) == false else {
            return
        }
        message.deliveredIDs?.append(NSNumber(value: userID))
        self.message = message
        updateUsers()
    }
}
