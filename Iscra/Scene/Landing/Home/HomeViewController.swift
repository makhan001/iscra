//
//  HomeViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK:-Outlets and variables
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var viewFirstHabit:UIView!
    @IBOutlet weak var tableView:HabitTableView!
    
    weak var router: NextSceneDismisser?
    let viewModel: HomeViewModel = HomeViewModel(provider: HabitServiceProvider())
    //  private var viewModel = AddHabitViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("self. router on HomeViewController is \(String(describing: self.router))")
        super.viewWillAppear(animated)
        self.lblUserName.text = "Hi,  " + (UserStore.userName ?? "").capitalized
        self.viewModel.fetchHabitList()
    }
}

// MARK: Instance Methods
extension HomeViewController {
    private func setup() {
        viewModel.view = self
        self.tableView.isHidden = false
        self.viewFirstHabit.isHidden = true
        self.tableView.didSelectedAtIndex = didSelectedAtIndex
        self.lblTitle.text = AppConstant.firstHabitTitle
        self.lblSubTitle.text = AppConstant.firstHabitSubTitle
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "editHabit"), object: nil)

       // self.tableView.delegate1 = self
        self.tableView.isHabitDelete = {
            selected , id in
            if selected {
                print("is is \(id)")
                self.showAlert(habitId: id)
            }
        }
    }
    @objc func refrershUI(){
        print("refrershUI is called")
        self.viewModel.fetchHabitList()
    }
}

// MARK: Callbacks
extension HomeViewController {
    private func didSelectedAtIndex(_ index: Int) {
        self.viewModel.habitId =  self.viewModel.habitList[index].id ?? 0  // viewModel.habitList[index].id ?? 0
      //  print("habit id is in HomeViewController  \(viewModel.habitList[index].id ?? 0)")
     //   print("self.router is HomeViewController  \(String(describing: self.router))")
        if self.viewModel.habitList[index].habitType == "group_habit" {
            self.router?.push(scene: .groupHabitFriends)
        }else{
            self.router?.push(scene: .habitCalender)
        }
        
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
            self.fetchHabitList()
        default:
            break
        }
    }
    
    private func fetchHabitList() {
         print("self.viewModel.habitList is \(self.viewModel.habitList.count)")
        if self.viewModel.habitList.count == 0 {
            self.viewFirstHabit.isHidden = false
            self.tableView.isHidden = true
        }else{
            self.viewFirstHabit.isHidden = true
            self.tableView.isHidden = false
            self.tableView.configure(habits: self.viewModel.habitList)
        }
    }
}

// MARK: showAlert for delete habit
extension HomeViewController {
    func showAlert(habitId: String) {
        let alertController = UIAlertController(title: "Delete Habit", message: AppConstant.deleteHabit, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action: UIAlertAction!) in
            self.viewModel.deleteHabit(habitId: habitId)
        }
        deleteAction.setValue(UIColor.gray, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction!) in
            print("Cancel button tapped");
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
}
