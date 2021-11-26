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
    @IBOutlet weak var tblHabit:HabitTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: Instance Methods
extension HomeViewController {
    private func setup() {
        self.viewFirstHabit.isHidden = true
        self.tblHabit.isHidden = false
        self.lblUserName.text = "Hi \(UserStore.userName?.capitalized ?? "")"
        self.lblTitle.text = "Are you ready to create \nyour first habit?"
        self.lblSubTitle.text = "I am excited to help you to become \na better version of yourself. Let's \nstart our journey. Click plus button \nto create your first habit."
        self.tblHabit.configure(obj: 5)
        self.tblHabit.delegate1 = self
    }
}

// MARK: - Navigation
extension HomeViewController: HabitTableNavigation{
    func navigate() {
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HabitCalenderViewController") as! HabitCalenderViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
