
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
    
//    var habitType : HabitType = .good
    weak var router: NextSceneDismisser?
    let viewModel = AddHabitViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

extension ReminderViewController {
    private func setup()  {
        self.viewModel.view = self
        self.pickerTime.locale = NSLocale(localeIdentifier: "en_US") as Locale
        self.setNavigationView()
        self.addTapGeture()
        self.timePickerValueOnUpdate()
        self.setViewControls()
        self.weekCollection.confirgure(viewModel: viewModel)
    }
    
    private func setViewControls() {
        self.switchReminder.addTarget(self, action:#selector(self.reminderSwitchValueChanged(_:)), for: .valueChanged)
        [btnTime, btnNext].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    private func setNavigationView() {
        self.viewNavigation.navType = .addHabit
        self.viewNavigation.commonInit()
        self.viewNavigation.lblTitle.text = ""
        self.viewNavigation.delegateBarAction = self
    }
    
    private func addTapGeture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.viewBackground.addGestureRecognizer(tap)
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
    
    private func timePickerValueOnUpdate() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "hh:mm a"
//        let dateString = dateFormatter.string(from: pickerTime.date)
//        let fullNameArr = dateString.components(separatedBy: " ")
//        lblReminderTime.text = fullNameArr[0]
//        self.viewModel.reminderTime = dateString
//        if dateString.contains("AM") {
//            btnSegment.selectedSegmentIndex = 0
//        } else {
//            btnSegment.selectedSegmentIndex = 1
//        }
        
        let dateFormatter12 = DateFormatter()
        dateFormatter12.dateFormat = "hh:mm a"
        dateFormatter12.locale = Locale(identifier: "en-US")
        let dateString1 = dateFormatter12.string(from: pickerTime.date)
        self.viewModel.reminderTime = dateString1 // deepak
        print(" dateString1 is \(dateString1.convertTo12Hour)")
        //////////////
        let fullNameArr = dateString1.components(separatedBy: " ")
        print("pickerTime.date is \(pickerTime.date)")
        print("fullNameArr[0] is \(fullNameArr[0])")
        lblReminderTime.text = fullNameArr[0]
        if dateString1.contains("AM") {
            self.btnSegment.selectedSegmentIndex = 0
        } else {
            self.btnSegment.selectedSegmentIndex = 1
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

// MARK: Button Action
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
        self.timePickerValueOnUpdate()
    }
    
    private func timeClick() {
        UIView.animate(withDuration: 3.0, animations: {
            self.viewTimePicker.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    
    func getTimeStampForHabit(strTime: String) -> String {
        let dateFromatter = DateFormatter()
        dateFromatter.locale = Locale(identifier: "en-US")
        dateFromatter.dateFormat = "hh:mm a"
        let daatee = dateFromatter.date(from: strTime)
        dateFromatter.dateFormat = "HH:mm"
        let strDate = dateFromatter.string(from: daatee ?? Date())
        
        let time = strDate.components(separatedBy: ":")
        let hour = Int(time[0]) ?? 00
        let minutes = Int(time[1]) ?? 00
        
        let date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 00, of: Date())
        let timeStamp = date?.millisecondsSince1970
        print("timeStamp is \(timeStamp)")
        return "\(timeStamp)"
        
    }
    
    private func nextClick() {
        let dateFromatter = DateFormatter()
        dateFromatter.locale = Locale(identifier: "en-US")
        dateFromatter.dateFormat = "hh:mm a"
        let daatee = dateFromatter.date(from: self.viewModel.reminderTime)
        dateFromatter.dateFormat = "HH:mm"
        let strDate = dateFromatter.string(from: daatee ?? Date())

        let time = strDate.components(separatedBy: ":")
        let hour = Int(time[0]) ?? 00
        let minutes = Int(time[1]) ?? 00

        let date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 00, of: Date())
        let timeStamp = date?.millisecondsSince1970
        print("timeStamp is \(timeStamp)")
        
        
        if self.viewModel.reminders == true {
            HabitUtils.shared.timer = "\(timeStamp ?? 0)"
            self.viewModel.timer = "\(timeStamp ?? 0)"
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
