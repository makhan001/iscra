//
//  GroupMembersViewController.swift
//  Iscra
//
//  Created by mac on 29/12/21.
//

import UIKit

class GroupMembersViewController: UIViewController {
    
    @IBOutlet weak var tableview: GroupMembersTableView!
    @IBOutlet weak var viewNavigation: NavigationBarView!
    
    weak var router: NextSceneDismisser?
    let viewModel: GroupMembersViewModel = GroupMembersViewModel(provider: HabitServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        self.viewModel.view = self
        self.setUpNavigationBar()
        self.tableview.configure(viewModel: viewModel)
        self.viewModel.fetchGroupMembers()
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

// MARK: API Callback
extension GroupMembersViewController: HabitViewRepresentable {
    func onAction(_ action: HabitAction) {
        switch action {
        case  let .errorMessage(msg):
            self.showToast(message: msg)
        case .sucessMessage(_):
            self.tableview.reloadData()
        default:
            break
        }
    }
}
