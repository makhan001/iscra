//
//  ReminderViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 27/10/21.
//

import UIKit

class ReminderViewController: UIViewController {
    
    @IBOutlet var viewTime:UIView!
    @IBOutlet var btnTime:UIButton!
    @IBOutlet var btnNext:UIButton!
    @IBOutlet var viewTimePicker:UIView!
    @IBOutlet var viewBackground:UIView!
    @IBOutlet var switchReminder:UISwitch!
    @IBOutlet var weekCollection:WeekCollection!
    @IBOutlet weak var lblReminderTime: UILabel!
    @IBOutlet weak var pickerTime: UIDatePicker!
    @IBOutlet weak var btnSegment: UISegmentedControl!
    @IBOutlet weak var viewNavigation:NavigationBarView!
    
    var reminderTime = ""
    var habitType : HabitType = .good
    private let viewModel = AddHabitViewModel()
    var selectedColorTheme =  ColorStruct(id: "1", colorHex: "#ff7B86EB", isSelect: true)
    weak var router: NextSceneDismisser?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func TimePickerClick(_ sender: Any) {
        timemanager()
    }
}

extension ReminderViewController {
    func setup()  {
        viewModel.view = self
        self.viewNavigation.lblTitle.text = ""
        self.viewNavigation.delegateBarAction = self
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.weekCollection.didSelectedDayAtIndex = didSelectedAtIndex
        navigationController?.navigationBar.isHidden = false
        switchReminder.addTarget(self, action:#selector(self.reminderSwitchValueChanged(_:)), for: .valueChanged)
        weekCollection.configure(selectedColor: selectedColorTheme)
        [btnTime, btnNext].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewBackground.addGestureRecognizer(tap)
        timemanager()
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
    
    func timemanager(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let dateString = dateFormatter.string(from: pickerTime.date)
        let fullNameArr = dateString.components(separatedBy: " ")
        lblReminderTime.text = fullNameArr[0]
//        self.viewModel.timer = dateString
//        print("self.viewModel.timer is \(self.viewModel.timer)")
        self.reminderTime = dateString
        if dateString.contains("AM")
        {
            btnSegment.selectedSegmentIndex = 0
        }
        else{
            btnSegment.selectedSegmentIndex = 1
        }
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
    
    private func timeClick() {
        UIView.animate(withDuration: 3.0, animations: {
            self.viewTimePicker.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    
    private func nextClick() {
        
        let currentDate = Date().string(format: "yyyy-MM-dd")
        let yourDate = currentDate + "-" + self.reminderTime
         let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh:mm a"
         let dateString = dateFormatter.date(from: yourDate)
         let dateTimeStamp  = dateString!.timeIntervalSince1970

        if self.viewModel.reminders == true {
            HabitUtils.shared.timer = String(dateTimeStamp)
            self.viewModel.timer = String(dateTimeStamp)
            HabitUtils.shared.reminders = true
        }else{
            HabitUtils.shared.timer = ""
            self.viewModel.timer = ""
        }
        viewModel.onAction(action: .setDaySelection(.daysSelection), for: .daysSelection)
    }
}

extension ReminderViewController : InviteNavigation {
    func navigate(inviteType: inviteType) {
        if inviteType == .mayBeLatter{
            guard let viewControllers = navigationController?.viewControllers else { return }
            for vc in viewControllers {
                if vc is LandingTabBarController {
                    navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
        }
        else{
            
        }
    }
}

// MARK: Callbacks
extension ReminderViewController: HabitViewRepresentable {
    private func didSelectedAtIndex(_ index: String) {
        print("strDays is \(index)")
        viewModel.days = index
    }
    
    func onAction(_ action: HabitAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case let .sucessMessage(msg):
            self.showToast(message: msg, seconds: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let inviteFriend: InviteFriendViewController = InviteFriendViewController.from(from: .habit, with: .inviteFriend)
                inviteFriend.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                inviteFriend.habitType = self.habitType
                inviteFriend.delegateInvite = self
                inviteFriend.router = self.router
                self.present(inviteFriend, animated: true, completion: nil)
            }
        case .navigateToGroupImage(true):
            let addGroupImage: AddGroupImageViewController = AddGroupImageViewController.from(from: .habit, with: .addGroupImage)
            addGroupImage.habitType = habitType
            addGroupImage.router = self.router
            self.navigationController?.pushViewController(addGroupImage, animated: true)
            break
        default:
            break
        }
    }
    
}
// MARK: navigationBarAction Callback
extension ReminderViewController  : navigationBarAction {
    
    func ActionType()  {
      //  router?.dismiss(controller: .addHabit)
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
