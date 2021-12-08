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
  //  var objHabitDetail: AllHabits?
    var reminderTime = ""
    var reminders:Bool = false
    var getReminderTime:((_ isReminderOn:Bool, _ reminderTime: String)   ->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("self.reminderTime viewDidLoad is \(self.reminderTime)")
      //  self.getReadableDate(timeStamp: Double((self.reminderTime)) ?? 0.0)
        
//        if self.reminderTime != "" {
//            var dateString = ""
//            let date = NSDate(timeIntervalSince1970: Double((self.reminderTime)) ?? 0.0 / 1000)
//            let dayTimePeriodFormatter = DateFormatter()
//            dayTimePeriodFormatter.dateFormat = "hh:mm a" //"dd MMM YY, hh:mm a, EEEE"
//            dayTimePeriodFormatter.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
//            dateString = dayTimePeriodFormatter.string(from: date as Date)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "hh:mm a" // "yyyy-MM-dd"
//            let selectedDate = dateFormatter.date(from: dateString ) ?? Date()
//            self.pickerTime.setDate(selectedDate, animated: false)
//
//            print("selectedDate is \(selectedDate)")
//        }
        
        self.setup()
    }
    
    @IBAction func TimePickerClick(_ sender: Any) {
        self.timemanager()
    }
}

extension EditReminderViewController {
    func setup()  {
        self.viewTime.isHidden = true
        self.viewTimePicker.isHidden = true
        navigationController?.navigationBar.isHidden = false
        self.switchReminder.addTarget(self, action:#selector(self.reminderSwitchValueChanged(_:)), for: .valueChanged)
        [btnTime].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.viewBackground.addGestureRecognizer(tap)
        
     //   self.switchReminder.setOn(self.objHabitDetail?.reminders ?? false, animated: true)
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
        //  self.viewTimePicker.isHidden = true
        self.getReminderTime!(self.reminders, String(self.reminderTime))
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func reminderSwitchValueChanged(_ sender : UISwitch!){
        if sender.isOn {
            self.viewTime.isHidden = false
            self.reminders = true // deepak new
            self.timemanager() // deepak new
        } else {
            self.viewTime.isHidden = true
            self.viewTimePicker.isHidden = true
            self.reminders = false
            self.reminderTime = ""
            print("self.reminders reminderSwitchValueChanged is \(self.reminders)")
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
        print("self.reminders timemanager is \(self.reminders)")
        print("self.reminderTime is timemanager \(self.reminderTime)")
        if dateString.contains("AM") {
            self.btnSegment.selectedSegmentIndex = 0
        }else{
            self.btnSegment.selectedSegmentIndex = 1
        }
    }
        
    func setDefalutTime() {
        var dateString = ""
        if self.reminderTime == "" {
       // if self.objHabitDetail?.timer == "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateString = dateFormatter.string(from: pickerTime.date)
        }else{
            let date = NSDate(timeIntervalSince1970: Double((self.reminderTime)) ?? 0.0 / 1000)
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "hh:mm a" //"dd MMM YY, hh:mm a, EEEE"
          //  dayTimePeriodFormatter.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
            dateString = dayTimePeriodFormatter.string(from: date as Date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a" // "yyyy-MM-dd"
            let selectedDate = dateFormatter.date(from: dateString ) ?? Date()
            self.pickerTime.setDate(selectedDate, animated: false)
            
            
//            self.getReadableDate(timeStamp: Double((self.reminderTime)) ?? 0.0)
//            dateString = self.getReadableDate(timeStamp: Double((self.reminderTime)) ?? 0.0) ?? ""
        }
        let fullNameArr = dateString.components(separatedBy: " ")
        lblReminderTime.text = fullNameArr[0]
       // if self.objHabitDetail?.reminders == true {
            if self.reminders == true {
            self.reminderTime = dateString
            self.reminders = true
        }else{
            self.reminderTime = ""
            self.reminders = false
        }
        
        print("self.reminderTime is setDefalutTime \(self.reminderTime)")
        print("self.reminders setDefalutTime is \(self.reminders)")
        if dateString.contains("AM"){
            self.btnSegment.selectedSegmentIndex = 0
        }else{
            self.btnSegment.selectedSegmentIndex = 1
        }
    }
}

// MARK:- Button Action
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
    
    /////////////////////
    
//    func getReadableDate(timeStamp: TimeInterval) -> String? {
//        let date = Date(timeIntervalSince1970: timeStamp)
//        let dateFormatter = DateFormatter()
//
//     //   if dateFallsInCurrentWeek(date: date) {
//            if Calendar.current.isDateInToday(date) {
//                dateFormatter.dateFormat = "h:mm a"
//                print("dateFormatter.string(from: date) is \(dateFormatter.string(from: date))")
//                self.pickerTime.setDate(date, animated: false)
//                let fullNameArr = dateFormatter.string(from: date).components(separatedBy: " ")
//                    lblReminderTime.text = fullNameArr[0]
//
//
//                return dateFormatter.string(from: date)
//            } else {
//                dateFormatter.dateFormat = "h:mm a"
//                print("dateFormatter.string(from: date) is \(dateFormatter.string(from: date))")
//                self.pickerTime.setDate(date, animated: false)
//                let fullNameArr = dateFormatter.string(from: date).components(separatedBy: " ")
//                    lblReminderTime.text = fullNameArr[0]
//                return dateFormatter.string(from: date)
//            }
//      //  }
//
////        let fullNameArr = dateString.components(separatedBy: " ")
////        lblReminderTime.text = fullNameArr[0]
//
//    }
//
//    func dateFallsInCurrentWeek(date: Date) -> Bool {
//        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
//        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
//        return (currentWeek == datesWeek)
//    }
    ///////////////////
}



