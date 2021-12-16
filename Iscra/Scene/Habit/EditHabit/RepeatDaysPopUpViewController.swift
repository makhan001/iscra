//
//  RepeatDaysPopUpViewController.swift
//  Iscra
//
//  Created by mac on 03/11/21.
//

import UIKit

class RepeatDaysPopUpViewController: UIViewController {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tableView: RepeatDaysTableView!
  //  var days: [String]? = nil
    var weekdays: [String]? = []
   // var objHabitDetail: AllHabits?
    var isFormEditHabit: Bool = false
    var getRepeatDays:((_ repeatDays: String)  ->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: Instance Methods
extension RepeatDaysPopUpViewController {
    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewBackground.addGestureRecognizer(tap)
        self.tableView.didSelectedDayAtIndex = didSelectedAtIndex
        self.tableViewConfigure()
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.tableView.didSelectedDayAtIndex = didSelectedAtIndex
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: Instance Methods
extension RepeatDaysPopUpViewController {
    
    func tableViewConfigure() {
            var updatedArray:[weekStruct] = []
     //   print("objHabitDetail?.days is \(String(describing: objHabitDetail?.days))")
        print("objHabitDetail?.days is \(String(describing: self.weekdays))")

            for i in self.tableView.weakDays {
             //   if let days = objHabitDetail?.days , days.contains(i.dayname) {
                    if let days = self.weekdays , days.contains(i.dayname) {

                    updatedArray.append(weekStruct(id: i.id, shortDayname: i.shortDayname, dayname: i.dayname, isSelect: true))
                }else{
                    updatedArray.append(weekStruct(id: i.id, shortDayname: i.shortDayname, dayname: i.dayname, isSelect: false))
                }
            }
            self.tableView.weakDays = updatedArray
            print("days RepeatDaysTableView is \(updatedArray)")
        self.tableView.configure()
    }
    
    private func didSelectedAtIndex(_ index: String) {
        print("strDays is \(index)")
        self.getRepeatDays!(index)
    }
}
