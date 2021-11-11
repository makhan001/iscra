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
        navigationController?.navigationBar.isHidden = false
        switchReminder.addTarget(self, action:#selector(self.reminderSwitchValueChanged(_:)), for: .valueChanged)
        weekCollection.configure()
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
        } else {
            viewTime.isHidden = true
        }
    }
    
    func timemanager(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let dateString = dateFormatter.string(from: pickerTime.date)
        let fullNameArr = dateString.components(separatedBy: " ")
        lblReminderTime.text = fullNameArr[0]
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
        let storyboard = UIStoryboard(name: "Habit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InviteFriendViewController") as! InviteFriendViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
