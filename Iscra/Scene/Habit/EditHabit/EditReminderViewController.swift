//
//  EditReminderViewController.swift
//  Iscra
//
//  Created by mac on 08/11/21.
//

import UIKit

class EditReminderViewController: UIViewController {
    
    @IBOutlet var viewTime:UIView!
    @IBOutlet var btnTime:UIButton!
    @IBOutlet var viewTimePicker:UIView!
    @IBOutlet var viewBackground:UIView!
    @IBOutlet var switchReminder:UISwitch!
    @IBOutlet weak var lblReminderTime: UILabel!
    @IBOutlet weak var pickerTime: UIDatePicker!
    @IBOutlet weak var btnSegment: UISegmentedControl!
    var reminderTime = ""
    var reminders:Bool = false
    var getReminderTime:((_ isReminderOn:Bool, _ reminderTime: String)   ->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    @IBAction func TimePickerClick(_ sender: Any) {
        self.timemanager()
    }
}

extension EditReminderViewController {
    func setup()  {
        self.pickerTime.locale = NSLocale(localeIdentifier: "en_US") as Locale
        self.viewTime.isHidden = true
        self.viewTimePicker.isHidden = true
        navigationController?.navigationBar.isHidden = false
        self.switchReminder.addTarget(self, action:#selector(self.reminderSwitchValueChanged(_:)), for: .valueChanged)
        [btnTime].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.viewBackground.addGestureRecognizer(tap)
        
        self.switchReminder.setOn(self.reminders, animated: true)

        if self.switchReminder.isOn {
            self.viewTime.isHidden = false
        } else {
            self.viewTime.isHidden = true
            self.viewTimePicker.isHidden = true
        }
        self.setDefalutTime()
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.getReminderTime!(self.reminders, String(self.reminderTime))
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func reminderSwitchValueChanged(_ sender : UISwitch!){
        if sender.isOn {
            self.viewTime.isHidden = false
            self.reminders = true
            self.timemanager()
        } else {
            self.viewTime.isHidden = true
            self.viewTimePicker.isHidden = true
            self.reminders = false
            self.reminderTime = ""
        }
    }
    
    func timemanager() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let dateString = dateFormatter.string(from: pickerTime.date)
        let fullNameArr = dateString.components(separatedBy: " ")
        lblReminderTime.text = fullNameArr[0]
        self.reminderTime = dateString
        self.reminders = true
        if dateString.contains("AM") {
            self.btnSegment.selectedSegmentIndex = 0
        } else {
            self.btnSegment.selectedSegmentIndex = 1
        }
    }
        
    func setDefalutTime() {
        var dateString = ""
        if self.reminderTime == "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateString = dateFormatter.string(from: pickerTime.date)
        } else {
            if self.reminderTime.contains(":"){
                let strDate : String = self.reminderTime
                dateString = strDate
               // self.setPickerTime(dateString: dateString)
                self.pickerTime.setDate(from: dateString, format: "hh:mm a")
            } else {
                        let date = Date(timeIntervalSince1970: Double(self.reminderTime) ?? 0.0 / 1000)
                            let dayTimePeriodFormatter = DateFormatter()
                            dayTimePeriodFormatter.locale = Locale(identifier: "en_US_POSIX")
                            dayTimePeriodFormatter.dateFormat = "hh:mm a" // "dd MMM YY, hh:mm a, EEEE"
                             dateString = dayTimePeriodFormatter.string(from: date as Date)
               // self.setPickerTime(dateString: dateString)
                self.pickerTime.setDate(from: dateString, format: "hh:mm a")
            }
        }
        let fullNameArr = dateString.components(separatedBy: " ")
        lblReminderTime.text = fullNameArr[0]
        
            if self.reminders == true {
            self.reminderTime = dateString
            self.reminders = true
        } else {
            self.reminderTime = ""
            self.reminders = false
        }
        
        if dateString.contains("AM"){
            self.btnSegment.selectedSegmentIndex = 0
        } else {
            self.btnSegment.selectedSegmentIndex = 1
        }
    }
    
    func setPickerTime(dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: dateString)
        self.pickerTime.datePickerMode = .time
     //   print("strDate is on setting on picker  \(dateString)")
     //  print("date is on setting on picker  \(String(describing: date))")
        self.pickerTime.setDate(date ?? Date(), animated: false)
    }
}

// MARK: Button Action
extension EditReminderViewController {
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnTime:
            self.timeClick()
        default:
            break
        }
    }
    
    private func timeClick() {
        UIView.animate(withDuration: 2.0, animations: {
            self.viewTimePicker.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
}
