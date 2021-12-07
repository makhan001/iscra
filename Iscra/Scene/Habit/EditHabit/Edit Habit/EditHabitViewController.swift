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
    @IBOutlet weak var viewNavigation:NavigationBarView!
    var objHabitDetail: AllHabits?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        self.txtMyHabit.text = objHabitDetail?.name
    }
}
// MARK: Instance Methods
extension EditHabitViewController {
    private func setup() {
        self.viewNavigation.navType = .editHabit
        self.viewNavigation.commonInit()
        self.viewNavigation.lblTitle.text = ""
        self.viewNavigation.delegateBarAction = self
        navigationController?.setNavigationBarHidden(true, animated: false)
        [btnDeleteHabit].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        tableView.configure()
        tableView.delegateNavigate = self
        txtMyHabit.delegate = self
//        self.navigationItem.title = "Edit habit"
//        // self.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: nil), animated: true)
//
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
//                                                                 style: .plain,
//                                                                 target: self,
//                                                                 action: #selector(rightHandAction))
//        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: 24, weight: .bold), .foregroundColor : UIColor.black], for: .normal)

    }
  
}
// MARK:- Button Action
extension EditHabitViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnDeleteHabit:
            self.deleteHabitAction()
        default:
            break
        }
    }
    
    private func deleteHabitAction() {
        print("DeleteHabitAction")
        self.showAlert()
    }
}

extension EditHabitViewController: clickManagerDelegate{
    func tableViewCellNavigation(performAction: clickManager) {
        switch performAction {
        case .everyDay:
            everyDayAction()
        case .reminder:
            reminderAction()
        case .changeColorTheme:
            changeColorThemeAction()
        default:
            print("default")
        }
    }
    
    private func everyDayAction() {
        let repeatDaysPopUp: RepeatDaysPopUpViewController = RepeatDaysPopUpViewController.from(from: .landing, with: .repeatDaysPopUp)
        repeatDaysPopUp.days = self.objHabitDetail?.days
        repeatDaysPopUp.objHabitDetail = self.objHabitDetail
        repeatDaysPopUp.getRepeatDays = {
            repeatDays in
            print("RepeatDays on edit is \(repeatDays)")
        }
        self.navigationController?.present(repeatDaysPopUp, animated: false, completion: nil)
    }
    
    private func reminderAction() {
        let editReminder: EditReminderViewController = EditReminderViewController.from(from: .landing, with: .editReminder)
        editReminder.objHabitDetail = self.objHabitDetail
        editReminder.getReminderTime = {
            isReminderOn , reminderTime in
            if isReminderOn {
                print("updated time is \(reminderTime)  and remainder is \(isReminderOn)")
            }else{
                print("updated time is \(reminderTime)  and remainder is \(isReminderOn)")
            }
        }
        self.navigationController?.present(editReminder, animated: false, completion: nil)
    }
    
    private func changeColorThemeAction() {
        let colorPopUp: ColorPopUpViewController = ColorPopUpViewController.from(from: .habit, with: .colorPopUp)
        colorPopUp.objHabitDetail = self.objHabitDetail
        colorPopUp.isFormEditHabit = true
        colorPopUp.getUpdetedColorHex = {
            updatedColorHex in
            print("updatedColorHex is \(updatedColorHex)")
        }
        self.navigationController?.present(colorPopUp, animated: false, completion: nil)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Delete Habit", message: AppConstant.deleteHabit, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action: UIAlertAction!) in
            print("Delete button tapped");
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
// MARK: navigationBarAction Callback
extension EditHabitViewController  : navigationBarAction {
    
    func ActionType()  {
      //  router?.dismiss(controller: .addHabit)
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func RightButtonAction() {
        print("Save")
    }
}
