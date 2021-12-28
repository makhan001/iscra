//
//  RepeatDaysTableView.swift
//  Iscra
//
//  Created by mac on 03/11/21.
//

import UIKit

class  RepeatDaysTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var didSelectedDayAtIndex: ((String) -> Void)?
    var weakDays = [WeekDays(id: 7, shortDayname: "S", dayname: "sunday", isSelected: false),
                    WeekDays(id: 1, shortDayname: "M", dayname: "monday", isSelected: false),
                    WeekDays(id: 2, shortDayname: "T", dayname: "tuesday", isSelected: false),
                    WeekDays(id: 3, shortDayname: "W", dayname: "wednesday", isSelected: false),
                    WeekDays(id: 4, shortDayname: "T", dayname: "thursday", isSelected: false),
                    WeekDays(id: 5, shortDayname: "F", dayname: "friday", isSelected: false),
                    WeekDays(id: 6, shortDayname: "S", dayname: "saturday", isSelected: false)]
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
        func configure() {
        self.register(UINib(nibName: "RepeatDaysTableViewCell", bundle: nil), forCellReuseIdentifier: "RepeatDaysTableViewCell")
        self.delegate = self
        self.dataSource = self
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weakDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatDaysTableViewCell") as? RepeatDaysTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(day: weakDays[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var temp = weakDays
        if temp[indexPath.row].isSelected == true {
            temp[indexPath.row].isSelected = false
        } else {
            temp[indexPath.row].isSelected = true
        }
        weakDays = temp
        var strDays = ""
        for i in temp {
            if i.isSelected == true {
               // strDays =  i.dayname + "," + strDays
              ///  strDays =  strDays + "," + i.dayname
                
                if strDays == "" {
                    strDays =   i.dayname
                } else {
                    strDays =  strDays + "," + i.dayname
                }
            }
        }
        self.didSelectedDayAtIndex?(strDays)
        reloadData()
    }
    
}
