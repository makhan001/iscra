//
//  EditHabitViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 03/11/21.
//

import UIKit

class EditHabitViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: EditHabitTableView!
    
    @IBOutlet weak var btnDeleteHabit: UIButton!
    
    @IBOutlet weak var txtMyHabit: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
}
// MARK: Instance Methods
extension EditHabitViewController {
    private func setup() {
        [btnDeleteHabit].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        tableView.configure()
        tableView.delegateNavigate = self
        txtMyHabit.delegate = self
        self.navigationItem.title = "Edit habit"
        // self.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: nil), animated: true)
     
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(rightHandAction))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: 24, weight: .bold), .foregroundColor : UIColor.black], for: .normal)

    }
    @objc func rightHandAction(){
        print("save")
    }
}
// MARK:- Button Action
extension EditHabitViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnDeleteHabit:
            self.DeleteHabitAction()
        default:
            break
        }
    }
    private func DeleteHabitAction() {
        print("DeleteHabitAction")
    }
    
}
extension EditHabitViewController: clickManagerDelegate{
    func tableViewCellNavigation(performAction: clickManager) {
        switch performAction {
        case .everyDay:
            EveryDayAction()
        case .reminder:
            ReminderAction()
        case .changeColorTheme:
            ChangeColorThemeAction()
        default:
            print("default")
        }
    }
    private func EveryDayAction() {
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RepeatDaysPopUpViewController") as! RepeatDaysPopUpViewController
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    private func ReminderAction() {
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditReminderViewController") as! EditReminderViewController
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    private func ChangeColorThemeAction() {
        let storyboard = UIStoryboard(name: "Habit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ColorPopUpViewController") as! ColorPopUpViewController
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
}

// MARK:- UITextFieldDelegate
extension EditHabitViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
        if newLength <= 30 {
            return true
        } else {
            return false
        }
    }
    
}
