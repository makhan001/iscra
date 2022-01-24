//
//  HomeViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK:Outlets and variables
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var viewFirstHabit:UIView!
    @IBOutlet weak var tableView:HabitTableView!
    
    weak var router: NextSceneDismisser?
    let viewModel: HomeViewModel = HomeViewModel(provider: HabitServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reload()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: Instance Methods
extension HomeViewController {
    private func setup() {
        self.viewModel.view = self
        self.setTableView()
        self.viewFirstHabit.isHidden = true
        self.lblTitle.text = AppConstant.firstHabitTitle
        self.lblSubTitle.text = AppConstant.firstHabitSubTitle
        self.viewModel.getSubscription()
        self.addNotificationObserver()
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: .EditHabit, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: .MarkAsComplete, object: nil)
    }
    
    private func reload() {
        self.lblUserName.text = "Hi, " + (UserStore.userName ?? "").capitalized
        self.viewModel.fetchHabitList()
    }
    
    private func setTableView() {
        self.tableView.isHidden = false
        self.tableView.configure(viewModel: viewModel)
        self.tableView.didDeleteHabitAtIndex = didDeleteHabitAtIndex
        self.tableView.showHabitDetail = didSelectedAtIndex
        self.tableView.didMarkAsComplete = didMarkAsComplete
        self.setPullToRefresh()
    }
    
    @objc func refrershUI() {
        self.viewModel.fetchHabitList()
    }
    
    private func handleSuccessResponse() {
        if self.viewModel.habitList.count == 0 {
            self.viewFirstHabit.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.viewFirstHabit.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    private func deleteAlert(id: String) {
        let alertController = UIAlertController(title: "Delete Habit", message: AppConstant.deleteHabit, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action: UIAlertAction!) in
            self.viewModel.deleteHabit(id: id)
        }
        deleteAction.setValue(UIColor.gray, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction!) in
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
}

// MARK: Closures Callbacks
extension HomeViewController {
    private func didSelectedAtIndex(_ index: Int) {
        self.viewModel.habitId =  self.viewModel.habitList[index].id ?? 0
        if self.viewModel.habitList[index].habitType == "group_habit" {
            self.router?.push(scene: .groupHabitFriends)
        } else {
            self.router?.push(scene: .habitCalender)
        }
    }
    
    private func didDeleteHabitAtIndex(_ index: Int) {
        guard let id = viewModel.habitList[index].id else { return }
        self.deleteAlert(id: String(id))
    }

    private func didMarkAsComplete(_ objHabitMark: HabitMark) {
        self.viewModel.apiMarkAsComplete(objHabitMark: objHabitMark)
    }
}

//MARK: - Pull to refresh list
extension HomeViewController{
    func setPullToRefresh() {
        self.viewModel.pullToRefreshCtrl = UIRefreshControl()
        self.viewModel.pullToRefreshCtrl.addTarget(self, action: #selector(self.pullToRefreshClick(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl =  self.viewModel.pullToRefreshCtrl
        } else {
            self.tableView.addSubview( self.viewModel.pullToRefreshCtrl)
        }
    }
    
    @objc func pullToRefreshClick(sender:UIRefreshControl) {
        self.viewModel.isRefreshing = true
        self.viewModel.fetchHabitList()
    }
}


// MARK: API Callback
extension HomeViewController: HabitViewRepresentable {
    func onAction(_ action: HabitAction) {
        switch action {
        case  let .errorMessage(msg):
            self.showToast(message: msg)
        case let .isHabitDelete(true, msg):
            self.showToast(message: msg)
            self.viewModel.habitList.removeAll()
            self.viewModel.fetchHabitList()
        case  .sucessMessage(_):
            self.handleSuccessResponse()
        case .markAsCompleteSucess(_):
            self.viewModel.habitList.removeAll()
            self.viewModel.fetchHabitList()
        default:
            break
        }
    }
}
