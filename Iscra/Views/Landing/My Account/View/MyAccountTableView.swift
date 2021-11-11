//
//  MyAccountTableView.swift
//  Iscra
//
//  Created by Dr.Mac on 21/10/21.
//

import UIKit
protocol clickManagerDelegate{
    func tableViewCellNavigation(performAction: clickManager)
}
enum clickManager {
    case changeProfilePhoto
    case addYourOwnMemoji
    case changePassword
    case shareWithFriends
    case rateUs
    case contactDeveloper
    case everyDay
    case reminder
    case changeColorTheme
}
struct MyAccount {
    let titleImage: String
    let titleName: String
    var clickManager : clickManager
}
class MyAccountTableView: UITableView {
    // MARK:-Outlets and variables
    let items = [
        MyAccount(titleImage: "ic-changeProfilePhoto-image", titleName: "Change Profile Photo", clickManager: .changeProfilePhoto),
        MyAccount(titleImage: "ic-addYourOwnMemoji-image", titleName: "Add your own memoji", clickManager: .addYourOwnMemoji),
        MyAccount(titleImage: "ic-changePassword-image", titleName: "Change password", clickManager: .changePassword),
        MyAccount(titleImage: "ic-shareWithFriends-image", titleName: "Share with friends", clickManager: .shareWithFriends),
        MyAccount(titleImage: "ic-rateus-image", titleName: "Rate us", clickManager: .rateUs),
        MyAccount(titleImage: "ic-connectDeveloper-image", titleName: "Contact developer", clickManager: .contactDeveloper)]
    var delegateNavigate: clickManagerDelegate?
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure() {
        self.tableFooterView = UIView(frame: .zero)
        self.separatorStyle = .none
        self.register(UINib(nibName: "MyAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAccountTableViewCell")
        self.delegate = self
        self.dataSource = self
        reloadData()
    }
}
// MARK:- TableView Method
extension MyAccountTableView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountTableViewCell") as? MyAccountTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(item: items[indexPath.row])
        
        return cell
    }
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegateNavigate?.tableViewCellNavigation(performAction: items[indexPath.row].clickManager)
      }
}



