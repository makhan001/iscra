//
//  ShareHabitViewController.swift
//  Iscra
//
//  Created by mac on 30/12/21.
//

import UIKit

class ShareHabitViewController: UIViewController {
   
    @IBOutlet weak var tableview: ShareHabitTableView!
    @IBOutlet weak var viewNavigation: NavigationBarView!

    weak var router: NextSceneDismisser?
    let viewModel: ShareHabitViewModel = ShareHabitViewModel(provider: HabitServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: Instance Method
extension ShareHabitViewController {
    private func setup() {
        self.viewModel.view = self
        self.setUpNavigationBar()
        self.tableview.configure(viewModel: viewModel)
        self.viewModel.fetchGroupMembers()
    }
    
    private func dismiss(_ message: String) {
        self.showToast(message: message, seconds: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.51) {
            self.dismiss(animated: true) {
                switch self.viewModel.sourceScreen {
                case .invite:
                    self.router?.push(scene: .landing)
                default:
                    break
                }
            }
        }
    }
}

// MARK: NavigationBarView Delegate Callback
extension ShareHabitViewController: NavigationBarViewDelegate {
    private func setUpNavigationBar() {
        self.viewNavigation.navType = .editName
        self.viewNavigation.commonInit()
        self.viewNavigation.delegateBarAction = self
        self.viewNavigation.lblTitle.textColor = UIColor.black
        self.viewNavigation.lblTitle.text = "Share Habit"
    }
    
    func navigationBackAction() {
        self.reloadTable()
        self.dismiss(animated: true, completion: nil)
    }
    
    func navigationRightButtonAction() {
        self.viewModel.shareHabit()
        self.router?.dismiss(controller: .shareHabit)
    }
    
    private func reloadTable() {
        self.viewModel.arrSelectedUsers.removeAll()
        self.tableview.reloadData()
    }
}

// MARK: API Callback
extension ShareHabitViewController: HabitViewRepresentable {
    func onAction(_ action: HabitAction) {
        switch action {
        case  let .errorMessage(message):
            self.showToast(message: message)
        case let .shareHabitSucess(message):
            self.reloadTable()
            self.dismiss(message)
        case .sucessMessage(_):
            self.tableview.reloadData()
        default:
            break
        }
    }
}
