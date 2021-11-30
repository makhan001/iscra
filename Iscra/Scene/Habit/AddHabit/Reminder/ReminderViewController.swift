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
    
    var habitType : habitType = .good
    private let viewModel = AddHabitViewModel()
    var selectedColorTheme =  ColorStruct(id: "1", colorHex: "#ff7B86EB", isSelect: true)

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
        self.viewModel.timer = dateString
        print("self.viewModel.timer is \(self.viewModel.timer)")
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
        HabitUtils.shared.reminders = self.viewModel.reminders
        HabitUtils.shared.timer = self.viewModel.timer
        viewModel.onAction(action: .setDaySelection(.daysSelection), for: .daysSelection)
        
//        if habitType == .group{
////            let storyboard = UIStoryboard(name: "Habit", bundle: nil)
////            let vc = storyboard.instantiateViewController(withIdentifier: "AddGroupImageViewController") as! AddGroupImageViewController
////            vc.habitType = habitType
////           navigationController?.pushViewController(vc, animated: true)
//
//            let addGroupImage: AddGroupImageViewController = AddGroupImageViewController.from(from: .habit, with: .addGroupImage)
//            addGroupImage.habitType = habitType
//            self.navigationController?.pushViewController(addGroupImage, animated: true)
//
//        }else {
////            let storyboard = UIStoryboard(name: "Habit", bundle: nil)
////            let vc = storyboard.instantiateViewController(withIdentifier: "InviteFriendViewController") as! InviteFriendViewController
////            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
////            vc.habitType = habitType
////            vc.delegateInvite = self
////            self.present(vc, animated: true, completion: nil)
//
//            let inviteFriend: InviteFriendViewController = InviteFriendViewController.from(from: .habit, with: .inviteFriend)
//            inviteFriend.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            inviteFriend.habitType = habitType
//            inviteFriend.delegateInvite = self
//            self.present(inviteFriend, animated: true, completion: nil)
//        }
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
        case .navigateToGroupImage(true):
            let addGroupImage: AddGroupImageViewController = AddGroupImageViewController.from(from: .habit, with: .addGroupImage)
                        addGroupImage.habitType = habitType
                        self.navigationController?.pushViewController(addGroupImage, animated: true)
            break
        default:
            break
        }
    }
    
}
