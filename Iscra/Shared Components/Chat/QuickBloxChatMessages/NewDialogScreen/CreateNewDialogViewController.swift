//
//  CreateNewDialogViewController.swift
//  sample-chat-swift
//
//  Created by Injoit on 10/4/19.
//  Copyright © 2019 Quickblox. All rights reserved.
//

import UIKit
import Quickblox
import SVProgressHUD
import UserNotifications

enum DialogAction {
    case create
    case add
    case createPlaceholder
}

struct CreateNewDialogConstant {
    static let perPage:UInt = 100
    static let newChat = "New Chat"
    static let noUsers = "No user with that name"
}
class CreateNewDialogViewController: UIViewController {
    
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet var tblChatListView: UITableView!
    @IBOutlet var tblUserChatListView: UITableView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var chatSegment: UISegmentedControl!
    private var titleView = TitleView()
    
    
    //MARK: - Properties
    private var users : [QBUUser] = []
    private var downloadedUsers : [QBUUser] = []
    private var selectedUsers: Set<QBUUser> = []
    private var foundedUsers : [QBUUser] = []
    private let chatManager = ChatManager.instance
    private var cancel = false
    private var cancelFetch = false
    private var currentFetchPage: UInt = 1
    private var currentSearchPage: UInt = 1
    private var isSearch = false
    private var searchText = ""
    private var isFriendsTab : Bool = false
    private var isMyChatTab : Bool = false
    
    
    //MARK: - UserChatList
    private var dialogs: [QBChatDialog] = []
    private var foundedDialogs : [QBChatDialog] = []
    private var dialogsFilterArray: [QBChatDialog] = []
    private var selectedDialog: Set<QBChatDialog> = []
   
    var tabBar = LandingTabBarController()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userChatSetup()
        self.tblChatListView.isHidden = true
        self.tblUserChatListView.reloadData()
        self.initialChatSetup()
        self.tableChatListSetup()
        self.tableUserChatListSetup()
    }
    func tableChatListSetup() {
        tblChatListView.register(UINib(nibName: UserCellConstant.reuseIdentifier, bundle: nil), forCellReuseIdentifier: UserCellConstant.reuseIdentifier)
        tblChatListView.keyboardDismissMode = .onDrag
        tblChatListView.delegate = self
        tblChatListView.dataSource = self
    }
    func tableUserChatListSetup() {
        tblUserChatListView.register(UINib(nibName: DialogCellConstant.reuseIdentifier, bundle: nil), forCellReuseIdentifier: DialogCellConstant.reuseIdentifier)
        tblUserChatListView.keyboardDismissMode = .onDrag
        tblUserChatListView.delegate = self
        tblUserChatListView.dataSource = self
    }
    func initialChatSetup() {
        navigationItem.titleView = titleView
        setupNavigationTitle()
        checkCreateChatButtonState()
        let createButtonItem = UIBarButtonItem(title: "Create",
                                               style: .plain,
                                               target: self,
                                               action: #selector(createChatButtonPressed(_:)))
        navigationItem.rightBarButtonItem = createButtonItem
        createButtonItem.tintColor = UIColor(red: 0.758, green: 0.639, blue: 0.158, alpha: 1)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "ic_Back_Image"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapBack(_:)))
        navigationItem.leftBarButtonItem = backButtonItem
        backButtonItem.tintColor = #colorLiteral(red: 0.8031229377, green: 0.691909194, blue: 0.2029924691, alpha: 1)
        [chatSegment ].forEach {
            $0?.addTarget(self, action: #selector(segmentPressed(_:)), for: .valueChanged)
        }
    }
    func userChatSetup() {
        reloadContent()
        QBChat.instance.addDelegate(self)
        chatManager.delegate = self
    }
    func hideTabBarSetup() {
        tabBarController?.tabBar.isHidden = true
        tabBarController?.view.backgroundColor = .white
        edgesForExtendedLayout = UIRectEdge.bottom
        extendedLayoutIncludesOpaqueBars = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabBarSetup()
        self.setupViews()
        
        //MARK: - Reachability
        let updateConnectionStatus: ((_ status: NetworkConnectionStatus) -> Void)? = { [weak self] status in
            guard let self = self else {
                return
            }
            let notConnection = status == .notConnection
            if notConnection == true {
                self.showAlertView(LoginConstant.checkInternet, message: LoginConstant.checkInternetMessage)
            }
            if notConnection == false {
                if QBChat.instance.isConnected == false {
                    self.chatManager.connect()
                }
                if self.isSearch == false {
                    self.fetchUsers()
                    
                } else {
                    if self.searchText.count > 2 {
                        self.searchUsers(self.searchText)
                    }
                }
                self.chatManager.updateStorage()
            }
        }//
        Reachability.instance.networkStatusBlock = { status in
            updateConnectionStatus?(status)
        }
        updateConnectionStatus?(Reachability.instance.networkConnectionStatus())
    }
    
    //MARK: - Internal Methods
     private func setupViews() {
           let iconSearch = UIImageView(image: UIImage(named: "search"))
           iconSearch.frame = CGRect(x: 0, y: 0, width: 35.0, height: 35.0)
           iconSearch.contentMode = .center
         //  searchBar.setRoundBorderEdgeColorView(cornerRadius: 0.0, borderWidth: 1.0, borderColor: .white)
           
           if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
               if let systemPlaceholderLabel = searchTextField.value(forKey: "placeholderLabel") as? UILabel {
                   searchBar.placeholder = " "

                   // Create custom placeholder label
                  let placeholderLabel = UILabel(frame: .zero)
                placeholderLabel.frame = CGRect(x: 3, y: -16, width: 300, height: 50)
                   placeholderLabel.text = "Search for a member"
                   placeholderLabel.font = .systemFont(ofSize: 15.0, weight: .regular)
                   placeholderLabel.textColor = #colorLiteral(red: 0.4255777597, green: 0.476770997, blue: 0.5723374486, alpha: 1)

                   systemPlaceholderLabel.addSubview(placeholderLabel)

                   placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
                   placeholderLabel.leadingAnchor.constraint(equalTo: systemPlaceholderLabel.leadingAnchor).isActive = true
                   placeholderLabel.topAnchor.constraint(equalTo: systemPlaceholderLabel.topAnchor).isActive = true
                   placeholderLabel.bottomAnchor.constraint(equalTo: systemPlaceholderLabel.bottomAnchor).isActive = true

                   placeholderLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
               }
               
               searchTextField.leftView = iconSearch
               searchTextField.backgroundColor = .white
               searchTextField.clearButtonMode = .never
           }
           searchBar.layer.borderWidth = 10
            searchBar.layer.borderColor = UIColor.white.cgColor
           searchBar.showsCancelButton = false
           cancelSearchButton.isHidden = true
       }
    @objc func segmentPressed(_ sender: UISegmentedControl) {
        self.searchBar.text = ""
        switch chatSegment.selectedSegmentIndex {
        case 0:
            chatAction()
        case 1:
            friendsAction()
        default:
            break
        }
    }
    private func chatAction() {
        self.isFriendsTab = false
        chatView.isHidden = false
        tblChatListView.isHidden = true
    }
    private func friendsAction() {
        self.isFriendsTab = true
        chatView.isHidden = true
        tblChatListView.isHidden = false
       
    }
    private func setupNavigationTitle() {
        let title = CreateNewDialogConstant.newChat
        var users = "users"
        if selectedUsers.count == 1 {
            users = "user"
        }
        let numberUsers = "\(selectedUsers.count) \(users) selected"
        titleView.setupTitleView(title: title, subTitle: numberUsers)
    }
    
    private func setupUsers(_ users: [QBUUser]) {
        var filteredUsers: [QBUUser] = []
        let currentUser = Profile()
        if currentUser.isFull == true {
            filteredUsers = users.filter({$0.id != currentUser.ID})
        }

        self.users = filteredUsers
        self.users = self.users.sorted(by: { (Obj1, Obj2) -> Bool in
                              let Obj1_Name = Obj1.fullName ?? ""
                              let Obj2_Name = Obj2.fullName ?? ""
                              return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
                           })        

       // self.users = users
        
        if selectedUsers.isEmpty == false {
            var usersSet = Set(users)
            for user in selectedUsers {
                if usersSet.contains(user) == false {
                    self.users.insert(user, at: 0)
                    usersSet.insert(user)
                }
            }
        }
        tblChatListView.reloadData()
        checkCreateChatButtonState()
    }
    
    private func addFoundUsers(_ users: [QBUUser]) {
        foundedUsers = foundedUsers + users
        var filteredUsers: [QBUUser] = []
        let currentUser = Profile()
        if currentUser.isFull == true {
            filteredUsers = foundedUsers.filter({$0.id != currentUser.ID})
        }
        
        self.users = filteredUsers
        tblChatListView.reloadData()
        checkCreateChatButtonState()
    }
  
    private func checkCreateChatButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = selectedUsers.isEmpty == true ? false : true
    }
    
    //MARK: - Actions
    @IBAction func cancelSearchButtonTapped(_ sender: UIButton) {
        if isFriendsTab == true {
            setupUsers(downloadedUsers)
        } else {
            self.dialogs = chatManager.storage.dialogsSortByUpdatedAt()
            self.tblUserChatListView.reloadData()
        }
        cancelSearchButton.isHidden = true
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearch = false
        cancel = false
    }
    
    @objc func didTapBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        
        
    }
    
    @objc func createChatButtonPressed(_ sender: UIBarButtonItem) {
        if Reachability.instance.networkConnectionStatus() == .notConnection {
            showAlertView(LoginConstant.checkInternet, message: LoginConstant.checkInternetMessage)
            SVProgressHUD.dismiss()
            return
        }
        cancelSearchButton.isHidden = true
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearch = false
        
        let selectedUsers = Array(self.selectedUsers)
        
        let isPrivate = selectedUsers.count == 1
        
        if isPrivate {
            // Creating private chat.
            SVProgressHUD.show()
            chatManager.storage.update(users: selectedUsers)
            guard let user = selectedUsers.first else {
                SVProgressHUD.dismiss()
                return
            }
            chatManager.createPrivateDialog(withOpponent: user, completion: { (response, dialog) in
                guard let dialog = dialog else {
                    if let error = response?.error {
                        SVProgressHUD.showError(withStatus: error.error?.localizedDescription)
                    }
                    return
                }
                SVProgressHUD.showSuccess(withStatus: "STR_DIALOG_CREATED".localized)
                self.openNewDialog(dialog)
            })
        } else {
            self.performSegue(withIdentifier: "enterChatName", sender: nil)
        }
    }
    
    private func openNewDialog(_ newDialog: QBChatDialog) {
        guard let navigationController = navigationController else {
            return
        }
        let controllers = navigationController.viewControllers
        var newStack = [UIViewController]()
        
        //change stack by replacing view controllers after ChatVC with ChatVC
        controllers.forEach{
            newStack.append($0)
            if $0 is DialogsViewController {
                let storyboard = UIStoryboard(name: "Chat", bundle: nil)
                guard let chatController = storyboard.instantiateViewController(withIdentifier: "ChatViewController")
                    as? ChatViewController else {
                        return
                }
                chatController.dialogID = newDialog.id
                newStack.append(chatController)
                navigationController.setViewControllers(newStack, animated: true)
                return
            }
        }
        //else perform segue
        self.performSegue(withIdentifier: "SA_STR_SEGUE_GO_TO_CHAT".localized, sender: newDialog.id)
    }
    
    //MARK: - Overrides
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterChatName" {
            if let chatNameVC = segue.destination as? EnterChatNameVC {
                let selectedUsers = Array(self.selectedUsers)
                chatNameVC.selectedUsers = selectedUsers
            }
        }
        if segue.identifier == "SA_STR_SEGUE_GO_TO_CHAT".localized {
            if let chatVC = segue.destination as? ChatViewController {
                chatVC.dialogID = sender as? String
            }
        }
    }
    
}
extension CreateNewDialogViewController {
    // MARK: - Helpers
    private func reloadContent() {
        dialogs = chatManager.storage.dialogsSortByUpdatedAt()
        if dialogs.count > 0 {
          print("Chat list not empty")
        } else {
            
           print("chat is EMPTY")
        }
        tblUserChatListView.reloadData()
    }
    func setupDate(_ dateSent: Date) -> String {
        let formatter = DateFormatter()
        var dateString = ""
        
        if Calendar.current.isDateInToday(dateSent) == true {
            dateString = messageTimeDateFormatter.string(from: dateSent)
        } else if Calendar.current.isDateInYesterday(dateSent) == true {
            dateString = "Yesterday"
        } else if dateSent.hasSame([.year], as: Date()) == true {
            formatter.dateFormat = "d MMM"
            dateString = formatter.string(from: dateSent)
        } else {
            formatter.dateFormat = "d.MM.yy"
            var anotherYearDate = formatter.string(from: dateSent)
            if (anotherYearDate.hasPrefix("0")) {
                anotherYearDate.remove(at: anotherYearDate.startIndex)
            }
            dateString = anotherYearDate
        }
        
        return dateString
    }
    func openChatWithDialogID(_ dialogID: String) {
        performSegue(withIdentifier: "SA_STR_SEGUE_GO_TO_CHAT".localized , sender: dialogID)
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension CreateNewDialogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblChatListView {
            if users.count == 0, isSearch == true {
                tableView.setupEmptyView("No user with that name")
            } else {
                tableView.removeEmptyView()
            }
            return users.count;
        }
//        else if tableView == self.tblUserChatListView {
//            if users.count == 0, isSearch == true {
//                tableView.setupEmptyView("No user with that name")
//            } else {
//                tableView.removeEmptyView()
//            }
//            return users.count;
//        }
        else {
            print("Dialogs count \(dialogs.count)")
            return dialogs.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        if tableView == self.tblUserChatListView {
            return 80.0
        } else {
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblChatListView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCellConstant.reuseIdentifier,for: indexPath) as? UserTableViewCell
            else {
              return UITableViewCell()
            }
            let user = self.users[indexPath.row]
            cell.userColor = user.id.generateColor()
            cell.userNameLabel.text = user.fullName?.capitalized ?? user.login
            
            cell.userAvatarImageView.sd_setImage(with: URL(string: user.customData ?? ""), placeholderImage: UIImage(named: "GroupHabit"))
            cell.tag = indexPath.row
            
            let lastItemNumber = users.count - 1
            if indexPath.row == lastItemNumber {
                if isSearch == true, cancel == false {
                    if let searchText = searchBar.text {
                        searchUsers(searchText)
                    }
                } else if isSearch == false, cancelFetch == false {
                    fetchUsers()
                }
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DialogCellConstant.reuseIdentifier,
                                                           for: indexPath) as? DialogCell else {
                return UITableViewCell()
            }
            
            cell.isExclusiveTouch = true
            cell.contentView.isExclusiveTouch = true
            cell.tag = indexPath.row
            
            let chatDialog = dialogs[indexPath.row]
            let cellModel = DialogTableViewCellModel(dialog: chatDialog)
            
            tableView.allowsMultipleSelection = false
            cell.checkBoxImageView.isHidden = true
            cell.checkBoxView.isHidden = true
            cell.unreadMessageCounterLabel.isHidden = false
            cell.unreadMessageCounterHolder.isHidden = false
            cell.lastMessageDateLabel.isHidden = false
            cell.contentView.backgroundColor = .clear
            
            if let dateSend = chatDialog.lastMessageDate {
                cell.lastMessageDateLabel.text = setupDate(dateSend)
            } else if let dateUpdate = chatDialog.updatedAt {
                cell.lastMessageDateLabel.text = setupDate(dateUpdate)
            }
            
            cell.unreadMessageCounterLabel.text = cellModel.unreadMessagesCounterLabelText
            cell.unreadMessageCounterHolder.isHidden = cellModel.unreadMessagesCounterHiden
            
            cell.dialogLastMessage.text = chatDialog.lastMessageText
            if chatDialog.lastMessageText == nil && chatDialog.lastMessageID != nil {
                cell.dialogLastMessage.text = "[Attachment]"
            }
            if let dateSend = chatDialog.lastMessageDate {
                cell.lastMessageDateLabel.text = setupDate(dateSend)
            } else if let dateUpdate = chatDialog.updatedAt {
                cell.lastMessageDateLabel.text = setupDate(dateUpdate)
            }
            
            cell.dialogName.text = cellModel.textLabelText.capitalized

            print("cell for row ---> \(Date().timeIntervalSince1970)")
            print("cellModel.customData\(String(describing: cellModel.customData))")
            cell.imgTitle.sd_setImage(with: URL(string: cellModel.customData ?? ""), placeholderImage: UIImage(named: "GroupHabit"))
            let lastItemNumber = users.count - 1
            if indexPath.row == lastItemNumber {
                if isSearch == true, cancel == false {
                    if let searchText = searchBar.text {
                        searchUsers(searchText)
                    }
                } else if isSearch == false, cancelFetch == false {
                    fetchUsers()
                }
            }
            return cell
        }
    }//
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblChatListView {
            let user = self.users[indexPath.row]
            selectedUsers.insert(user)
            checkCreateChatButtonState()
            setupNavigationTitle()
        } else {
            tblUserChatListView.deselectRow(at: indexPath, animated: true)
            let dialog = dialogs[indexPath.row]
        
            if let dialogID = dialog.id {
                openChatWithDialogID(dialogID)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        if selectedUsers.contains(user) {
            selectedUsers.remove(user)
        }
        
        checkCreateChatButtonState()
        setupNavigationTitle()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.users.count > 0 {
            let user = self.users[indexPath.row]
            if selectedUsers.contains(user) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            else {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
       
    }
}

// MARK: - UISearchBarDelegate
extension CreateNewDialogViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)  {
        if self.isFriendsTab == true {
            print("FriendsTab === > \(Friend.self)")
            self.searchText = searchText
            if searchText.count > 2 {
                isSearch = true
                currentSearchPage = 1
                cancel = false
                searchUsers(searchText)
            }
            if searchText.count == 0 {
                isSearch = false
                cancel = false
                setupUsers(downloadedUsers)
            }
           
        }
       
       else {
            if searchText.count > 0 {
                self.dialogsFilterArray = chatManager.storage.dialogsSortByUpdatedAt()
                var filteredUsers: [QBChatDialog] = []
//                filteredUsers = dialogsFilterArray.filter { ($0.name?.contains(searchText.description)) as! Bool
//                }
                let searchText = self.searchBar.text!.lowercased()
                filteredUsers = dialogsFilterArray.filter { $0.name?.lowercased().range(of: searchText) != nil
                }
               
                self.dialogs = filteredUsers
                
            }
             
            else {
                self.dialogs = chatManager.storage.dialogsSortByUpdatedAt()
            }
            self.tblUserChatListView.reloadData()
        
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        cancelSearchButton.isHidden = false
    }
    
    private func searchUsers(_ name: String) {
        SVProgressHUD.show()
        chatManager.searchUsers(name, currentPage: currentSearchPage, perPage: CreateNewDialogConstant.perPage) { [weak self] response, users, cancel in
            SVProgressHUD.dismiss()
            self?.cancel = cancel
            if self?.currentSearchPage == 1 {
                self?.foundedUsers = []
            }
            if cancel == false {
                self?.currentSearchPage += 1
            }
            if users.isEmpty == false {
                self?.tblChatListView.removeEmptyView()
                self?.tblUserChatListView.removeEmptyView()
                self?.addFoundUsers(users)
            } else {
                self?.addFoundUsers(users)
                self?.tblChatListView.setupEmptyView(CreateNewDialogConstant.noUsers)
                self?.tblUserChatListView.setupEmptyView(CreateNewDialogConstant.noUsers)
            }
        }
    }
    
    private func fetchUsers() {
        SVProgressHUD.show()
        chatManager.fetchUsers(currentPage: currentFetchPage, perPage: CreateNewDialogConstant.perPage) { [weak self] response, users, cancel in
            SVProgressHUD.dismiss()
            self?.cancelFetch = cancel
            if cancel == false {
                self?.currentFetchPage += 1
            }
            self?.downloadedUsers.append(contentsOf: users)
            self?.setupUsers(self?.downloadedUsers ?? [QBUUser]())
            if users.isEmpty == false {
                self?.tblChatListView.removeEmptyView()
                self?.tblChatListView.reloadData()
                self?.tblUserChatListView.reloadData()
            } else {
                self?.tblChatListView.setupEmptyView(CreateNewDialogConstant.noUsers)
            }
        }
    }
}

// MARK: - QBChatDelegate
extension CreateNewDialogViewController: QBChatDelegate {
    func chatRoomDidReceive(_ message: QBChatMessage, fromDialogID dialogID: String) {
        chatManager.updateDialog(with: dialogID, with: message)
    }
    
    func chatDidReceive(_ message: QBChatMessage) {
        guard let dialogID = message.dialogID else {
            return
        }
        chatManager.updateDialog(with: dialogID, with: message)
    }
    
    func chatDidReceiveSystemMessage(_ message: QBChatMessage) {
        guard let dialogID = message.dialogID else {
            return
        }
        if let _ = chatManager.storage.dialog(withID: dialogID) {
            return
        }
        chatManager.updateDialog(with: dialogID, with: message)
    }
    
    func chatServiceChatDidFail(withStreamError error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }

    func chatDidConnect() {
        chatManager.updateStorage()
        SVProgressHUD.showSuccess(withStatus: "SA_STR_CONNECTED".localized)
    }

    func chatDidReconnect() {
        chatManager.updateStorage()
        SVProgressHUD.showSuccess(withStatus: "SA_STR_CONNECTED".localized)
    }
}
// MARK: - ChatManagerDelegate
extension CreateNewDialogViewController: ChatManagerDelegate {
    func chatManager(_ chatManager: ChatManager, didUpdateChatDialog chatDialog: QBChatDialog) {
        reloadContent()
        SVProgressHUD.dismiss()
    }
    
    func chatManager(_ chatManager: ChatManager, didFailUpdateStorage message: String) {
        SVProgressHUD.showError(withStatus: message)
    }
    
    func chatManager(_ chatManager: ChatManager, didUpdateStorage message: String) {
        reloadContent()
        SVProgressHUD.dismiss()
        QBChat.instance.addDelegate(self)
    }
    
    func chatManagerWillUpdateStorage(_ chatManager: ChatManager) {
        if navigationController?.topViewController == self {
            SVProgressHUD.show()
        }
    }
}

