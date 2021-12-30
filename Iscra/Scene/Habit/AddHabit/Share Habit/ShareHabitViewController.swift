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
        self.viewModel.callApiFriendList()
    }
    
    private func dismiss(_ messgae: String) {
        self.showToast(message: messgae, seconds: 0.5)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func navigationRightButtonAction() {
        self.viewModel.shareHabit()
        self.router?.dismiss(controller: .shareHabit)
    }
}

// MARK: API Callback
extension ShareHabitViewController: HabitViewRepresentable {
    func onAction(_ action: HabitAction) {
        switch action {
        case  let .errorMessage(messgae):
            self.showToast(message: messgae)
        case let .shareHabitSucess(messgae):
            self.dismiss(messgae)
        case .sucessMessage(_):
            self.tableview.reloadData()
        default:
            break
        }
    }
}
