//
//  RepeatDaysTableView.swift
//  Iscra
//
//  Created by mac on 03/11/21.
//

import UIKit

class  RepeatDaysTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var weakDays = [weekStruct(id: 7, shortDayname: "S", dayname: "sunday", isSelect: false),
                    weekStruct(id: 1, shortDayname: "M", dayname: "monday", isSelect: false),
                    weekStruct(id: 2, shortDayname: "T", dayname: "tuesday", isSelect: false),
                    weekStruct(id: 3, shortDayname: "W", dayname: "wednesday", isSelect: false),
                    weekStruct(id: 4, shortDayname: "T", dayname: "thursday", isSelect: false),
                    weekStruct(id: 5, shortDayname: "F", dayname: "friday", isSelect: false),
                    weekStruct(id: 6, shortDayname: "S", dayname: "suturday", isSelect: false)]
    
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
        if temp[indexPath.row].isSelect == true {
            temp[indexPath.row].isSelect = false
        }
        else{
            temp[indexPath.row].isSelect = true
        }
        weakDays = temp
        reloadData()
    }
    
}
