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
       // self.pickerTime.locale = .current
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
        let dateFormatter12 = DateFormatter()
        dateFormatter12.dateFormat = "hh:mm a"
        dateFormatter12.locale = Locale(identifier: "en-US")
        let dateString1 = dateFormatter12.string(from: pickerTime.date)
        print(" dateString1 is \(dateString1.convertTo12Hour)")
        //////////////
        let fullNameArr = dateString1.components(separatedBy: " ")
        print("pickerTime.date is \(pickerTime.date)")
        print("fullNameArr[0] is \(fullNameArr[0])")
        lblReminderTime.text = fullNameArr[0]
        self.reminderTime = dateString1
        self.reminders = true
        if dateString1.contains("AM") {
            self.btnSegment.selectedSegmentIndex = 0
        } else {
            self.btnSegment.selectedSegmentIndex = 1
        }
    }
    
//    func timemanager() {
//        let dateAsString = "13:15"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//
//        let date = dateFormatter.date(from: dateAsString)
//        dateFormatter.dateFormat = "h:mm a"
//        let Date12 = dateFormatter.string(from: date!)
//        print("12 hour formatted Date:",Date12)
//    }
//    func timemanager() {
//
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss Z"
//
//        print("proper date is \(formatter.string(from: pickerTime.date))")
//
//        let formatingDate = getFormattedDate(date: pickerTime.date, format: "yyyy-MM-dd HH:mm:ss Z")
//                print("formatingDate is \(formatingDate)")
//
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        let date = dateFormatter.date(from: formatingDate)
//        print("Converte date is \(date)")
////        dateFormatter.locale = .current
//        let dateString = dateFormatter.string(from: pickerTime.date)
//        dateFormatter.dateFormat = "HH:mm a"
//       //        dateFormatter.locale = .current
//        let dateStringss = dateFormatter.string(from: pickerTime.date)
//        print(dateStringss)
//        let fullNameArr = dateString.components(separatedBy: " ")
//
//        print("fullNameArr[0] is \(fullNameArr[0])")
//        print("pickerTime.date is \(pickerTime.date)")
//
//        print("dateString is \(dateString)")
//
//        lblReminderTime.text = fullNameArr[0]
//        self.reminderTime = dateString
//        self.reminders = true
//        if dateString.contains("AM") {
//            self.btnSegment.selectedSegmentIndex = 0
//        } else {
//            self.btnSegment.selectedSegmentIndex = 1
//        }
//    }
    
    func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        dateformat.timeZone = .current
        return dateformat.string(from: date)
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
                
                print("dateString on if \(dateString)")
                self.pickerTime.setDate(from: dateString, format: "hh:mm a")
            } else {
                        let date = Date(timeIntervalSince1970: Double(self.reminderTime) ?? 0.0 / 1000)
                            let dayTimePeriodFormatter = DateFormatter()
                            dayTimePeriodFormatter.locale = Locale(identifier: "en_US_POSIX")
                            dayTimePeriodFormatter.dateFormat = "hh:mm a" // "dd MMM YY, hh:mm a, EEEE"
                             dateString = dayTimePeriodFormatter.string(from: date as Date)
               // self.setPickerTime(dateString: dateString)
                print("dateString on else \(dateString)")
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
