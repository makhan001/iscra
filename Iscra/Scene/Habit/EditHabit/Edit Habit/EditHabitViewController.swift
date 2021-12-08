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
    
    var weekdays: [String]? = []
    var days: String = ""
    var timer: String = ""
    var colorTheme: String = ""
    var reminders: Bool = false
    var objHabitDetail: AllHabits?
    //let viewModel = EditHabitViewModel()
    let viewModel: EditHabitViewModel = EditHabitViewModel(provider: HabitServiceProvider())

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("objHabitDetail? is \(String(describing: objHabitDetail))")
        self.colorTheme = self.objHabitDetail?.colorTheme ?? ""
        self.txtMyHabit.text = objHabitDetail?.name
        self.timer = objHabitDetail?.timer ?? ""
        self.reminders = objHabitDetail?.reminders ?? false
        self.weekdays = objHabitDetail?.days
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
}

// MARK: Instance Methods
extension EditHabitViewController {
    private func setup() {
        self.viewModel.view = self
        self.viewNavigation.navType = .editHabit
        txtMyHabit.delegate = self
        self.txtMyHabit.returnKeyType = .done
        self.viewNavigation.commonInit()
        self.viewNavigation.lblTitle.text = ""
        self.viewNavigation.delegateBarAction = self
        navigationController?.setNavigationBarHidden(true, animated: false)
        [btnDeleteHabit].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        tableView.configure()
        tableView.delegateNavigate = self
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
        self.showAlert(habitId: String(objHabitDetail?.id ??  0))
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
        self.txtMyHabit.resignFirstResponder()
        let repeatDaysPopUp: RepeatDaysPopUpViewController = RepeatDaysPopUpViewController.from(from: .landing, with: .repeatDaysPopUp)
//        repeatDaysPopUp.days = self.objHabitDetail?.days
//        repeatDaysPopUp.objHabitDetail = self.objHabitDetail
        repeatDaysPopUp.weekdays = self.weekdays
        repeatDaysPopUp.getRepeatDays = {
              repeatDays in
            print("RepeatDays on edit is \(repeatDays)")
            let letters = repeatDays.components(separatedBy: ",")
            self.weekdays = letters
            self.days = repeatDays
            print("letters array is \(letters)") // ["A", "B", "C"]
        }
        self.navigationController?.present(repeatDaysPopUp, animated: false, completion: nil)
    }
    
    private func reminderAction() {
        self.txtMyHabit.resignFirstResponder()
        let editReminder: EditReminderViewController = EditReminderViewController.from(from: .landing, with: .editReminder)
       // editReminder.objHabitDetail = self.objHabitDetail
        
        editReminder.reminderTime =  self.timer
        editReminder.reminders = self.reminders

        
        editReminder.getReminderTime = {
            isReminderOn , reminderTime in
            if isReminderOn {
                print("updated time on edit when timer is on is \(reminderTime)  and remainder is \(isReminderOn)")
                self.reminders = isReminderOn
                self.timer = reminderTime
            }else{
                print("updated time on edit when timer is off is \(reminderTime)  and remainder is \(isReminderOn)")
                self.reminders = isReminderOn
                self.timer = reminderTime
            }
        }
        self.navigationController?.present(editReminder, animated: false, completion: nil)
    }
    
    private func changeColorThemeAction() {
        self.txtMyHabit.resignFirstResponder()
        let colorPopUp: ColorPopUpViewController = ColorPopUpViewController.from(from: .habit, with: .colorPopUp)
       // colorPopUp.objHabitDetail = self.objHabitDetail
        colorPopUp.colorTheme = self.colorTheme
        colorPopUp.isFormEditHabit = true
        colorPopUp.getUpdetedColorHex = {
            updatedColorHex in
            print("updatedColorHex on edit is \(updatedColorHex)")
            self.colorTheme = updatedColorHex
         //   colorPopUp.colorTheme = updatedColorHex
        }
        self.navigationController?.present(colorPopUp, animated: false, completion: nil)
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
        
        guard let txtName = self.txtMyHabit.text, let name = self.objHabitDetail?.name else { return }
        self.viewModel.habitName =   !txtName.isEmpty ? txtName : name
        self.viewModel.colorTheme = self.colorTheme
        self.viewModel.reminders = self.reminders
        self.viewModel.timer = self.timer
        
//        if self.days == "" {
//            let stringArray = self.objHabitDetail?.days ?? [""]
//            self.days = stringArray.joined(separator: ",")
//        }
        self.viewModel.days = self.days
        print("self.viewModel.reminders is \(self.viewModel.reminders)")
        print("self.viewModel.timer is \(self.viewModel.timer)")
        print("self.viewModel.colorTheme is \(self.viewModel.colorTheme)")
        
        ///////////////////////////
        if self.reminders == true {
            let currentDate = Date().string(format: "yyyy-MM-dd")
            let yourDate = currentDate + "-" + self.timer
             let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd-hh:mm a"
             let dateString = dateFormatter.date(from: yourDate)
             let dateTimeStamp  = dateString!.timeIntervalSince1970
            
            self.viewModel.timer = String(dateTimeStamp)
            self.viewModel.reminders = true
        }else{
            self.viewModel.timer = ""
            self.viewModel.reminders = false
        }
        ///////////////////////////
// need to do vaildation on edit habit
        self.viewModel.objHabitDetail = self.objHabitDetail
        self.viewModel.apiForUpdateHabit()
    }
}

// MARK:- UITextField Delegate
extension EditHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == self.txtMyHabit {
                self.txtMyHabit.resignFirstResponder()
            }
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
        if newLength <= 30 {
            if textField == self.txtMyHabit {
                if let text = txtMyHabit.text, let textRange = Range(range, in: text) {
                    let updatedText = text.replacingCharacters(in: textRange, with: string)
                    viewModel.habitName = updatedText
                }
            }
            return true
        } else {
            return false
        }
    }
}

// MARK: API Callback
extension EditHabitViewController: HabitViewRepresentable {
    func onAction(_ action: HabitAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case let .sucessMessage(msg):
            self.showToast(message: msg, seconds: 0.5)
        default:
            break
        }
    }
}

// MARK: showAlert for delete habit
extension EditHabitViewController {
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
