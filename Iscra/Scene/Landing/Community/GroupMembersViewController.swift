//
//  GroupMembersViewController.swift
//  Iscra
//
//  Created by mac on 29/12/21.
//

import UIKit

class GroupMembersViewController: UIViewController {

    @IBOutlet weak var viewNavigation: NavigationBarView!
    @IBOutlet weak var tableFriends: CommunityFriendTableView!
    
    weak var router: NextSceneDismisser?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        self.setUpNavigationBar()
    }
}

// MARK: NavigationBarView Delegate Callback
extension GroupMembersViewController: NavigationBarViewDelegate {
    private func setUpNavigationBar() {
        self.viewNavigation.delegateBarAction = self
        self.viewNavigation.lblTitle.textColor = UIColor.black
        self.viewNavigation.lblTitle.text = "Group Members"
    }
    
    func navigationBackAction() {
        self.router?.dismiss(controller: .groupMembers)
    }
}
