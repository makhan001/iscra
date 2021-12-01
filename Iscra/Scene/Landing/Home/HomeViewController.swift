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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // print("self.router is \(self.router)")
        self.lblUserName.text = UserStore.userName
    }
}

// MARK: Instance Methods
extension HomeViewController {
    private func setup() {
        self.viewFirstHabit.isHidden = true
        self.tableView.didSelectedAtIndex = didSelectedAtIndex
        self.tableView.isHidden = false
        self.lblTitle.text = "Are you ready to create \nyour first habit?"
        self.lblSubTitle.text = "I am excited to help you to become \na better version of yourself. Let's \nstart our journey. Click plus button \nto create your first habit."
        self.tableView.configure(obj: 5)
        self.tableView.delegate1 = self
    }
}

// MARK: Callbacks
extension HomeViewController {
    private func didSelectedAtIndex(_ index: Int) {
//        self.router?.push(scene: .habitCalender)
//        print("self.router is \(self.router)")
        self.router?.push(scene: .habitCalender)
//        let habitCalender: HabitCalenderViewController = HabitCalenderViewController.from(from: .landing, with: .habitCalender)
//        self.navigationController?.pushViewController(habitCalender, animated: true)
    }
}


// MARK: - Navigation
extension HomeViewController: HabitTableNavigation{
    func navigate() {
//        let habitCalender: HabitCalenderViewController = HabitCalenderViewController.from(from: .landing, with: .habitCalender)
//        self.navigationController?.pushViewController(habitCalender, animated: true)
//
        self.router?.push(scene: .habitCalender)

    }
}
