//
//  ReminderViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 27/10/21.
//

import UIKit

class ReminderViewController: UIViewController {
    
    @IBOutlet var btnTime:UIButton!
    @IBOutlet var btnNext:UIButton!
    
    @IBOutlet var viewTime:UIView!
    @IBOutlet var viewTimePicker:UIView!
    @IBOutlet var viewBackground:UIView!
    
    @IBOutlet var switchReminder:UISwitch!
    @IBOutlet var weekCollection:WeekCollection! // colletionView
    @IBOutlet weak var lblReminderTime: UILabel!
    @IBOutlet weak var pickerTime: UIDatePicker!
    @IBOutlet weak var btnSegment: UISegmentedControl!
    @IBOutlet weak var viewNavigation:NavigationBarView!
    
    var habitType : HabitType = .good
    weak var router: NextSceneDismisser?
    private let viewModel = AddHabitViewModel()
    var selectedColorTheme =  HabitThemeColor(id: "1", colorHex: "#ff7B86EB", isSelected: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

extension ReminderViewController {
    private func setup()  {
        self.viewModel.view = self
        self.setNavigationView()
        self.habitType = self.viewModel.habitType
        self.weekCollection.selectedHabitDays = selectedHabitDays
        self.switchReminder.addTarget(self, action:#selector(self.reminderSwitchValueChanged(_:)), for: .valueChanged)
        self.weekCollection.configure(selectedColor: selectedColorTheme)
        [btnTime, btnNext].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.viewBackground.addGestureRecognizer(tap)
        self.timeManager()
    }
    
    private func setNavigationView() {
        self.viewNavigation.navType = .addHabit
        self.viewNavigation.commonInit()
        self.viewNavigation.lblTitle.text = ""
        self.viewNavigation.delegateBarAction = self
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.viewTimePicker.isHidden = true
    }
    
    @objc func reminderSwitchValueChanged(_ sender : UISwitch!){
        if sender.isOn {
            viewTime.isHidden = false
            self.viewModel.reminders = true
        } else {
            viewTime.isHidden = true
            self.viewModel.reminders = false
        }
    }
    
    func timeManager() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let dateString = dateFormatter.string(from: pickerTime.date)
        let fullNameArr = dateString.components(separatedBy: " ")
        lblReminderTime.text = fullNameArr[0]
//        self.viewModel.timer = dateString
//        // print("self.viewModel.timer is \(self.viewModel.timer)")
        self.viewModel.reminderTime = dateString
        if dateString.contains("AM") {
            btnSegment.selectedSegmentIndex = 0
        } else {
            btnSegment.selectedSegmentIndex = 1
        }
    }
    
    private func showHabitCancelAlert() {
        let alertController = UIAlertController(title: "Warning!!", message: "Do you really want exit from adding habit?", preferredStyle: .alert)
        let logoutaction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            HabitUtils.shared.removeAllHabitData()
            self.router?.push(scene: .landing)
        }
        logoutaction.setValue(UIColor.red, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        cancelAction.setValue(UIColor.gray, forKey: "titleTextColor")
        alertController.addAction(logoutaction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
}

// MARK:- Button Action
extension ReminderViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnTime:
            self.timeClick()
        case btnNext:
            self.nextClick()
        default:
            break
        }
    }
    
    @IBAction func timePickerClick(_ sender: Any) {
        self.timeManager()
    }
    
    private func timeClick() {
        UIView.animate(withDuration: 3.0, animations: {
            self.viewTimePicker.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    
    private func nextClick() {
        let currentDate = Date().string(format: "yyyy-MM-dd")
        let yourDate = currentDate + "-" + self.viewModel.reminderTime
         let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh:mm a"
         let dateString = dateFormatter.date(from: yourDate)
         let dateTimeStamp  = dateString!.timeIntervalSince1970

        if self.viewModel.reminders == true {
            HabitUtils.shared.timer = String(dateTimeStamp)
            self.viewModel.timer = String(dateTimeStamp)
            HabitUtils.shared.reminders = true
        } else {
            HabitUtils.shared.timer = ""
            self.viewModel.timer = ""
        }
        viewModel.onAction(action: .setDaySelection(.daysSelection), for: .daysSelection)
    }
}

// MARK: NavigationBarView Delegate
extension ReminderViewController: NavigationBarViewDelegate {
    func navigationBackAction()  {
        self.router?.dismiss(controller: .setTheme)
    }
    
    func navigationRightButtonAction() {
        self.showHabitCancelAlert()
    }
}

// MARK: API Callbacks
extension ReminderViewController: HabitViewRepresentable {
    private func selectedHabitDays(_ days: String) {
        self.viewModel.sortWeekDays(days: days)
    }
    
    func onAction(_ action: HabitAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case let .sucessMessage(msg):
            self.showToast(message: msg, seconds: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.router?.push(scene: .inviteFriend)
            }
        case .navigateToGroupImage(true):
            self.router?.push(scene: .addGroupImage)
            break
        default:
            break
        }
    }
}
