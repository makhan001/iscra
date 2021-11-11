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
        self.viewTime.isHidden = true
        self.viewTimePicker.isHidden = true
        navigationController?.navigationBar.isHidden = false
        self.switchReminder.addTarget(self, action:#selector(self.reminderSwitchValueChanged(_:)), for: .valueChanged)
        [btnTime].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.viewBackground.addGestureRecognizer(tap)
        self.timemanager()
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        //  self.viewTimePicker.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func reminderSwitchValueChanged(_ sender : UISwitch!){
        if sender.isOn {
            self.viewTime.isHidden = false
        } else {
            self.viewTime.isHidden = true
            self.viewTimePicker.isHidden = true
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
            self.btnSegment.selectedSegmentIndex = 0
        }
        else{
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
}
