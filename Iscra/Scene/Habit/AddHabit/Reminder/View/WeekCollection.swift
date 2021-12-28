//
//  WeekCollection.swift
//  Iscra
//
//  Created by Lokesh Patil on 27/10/21.
//

import UIKit
import Foundation


class WeekCollection: UICollectionView { // WeekCollectionView
    
    var selectedColorTheme =  HabitThemeColor(id: "1", colorHex: "#ff7B86EB", isSelected: true) // viewModel
    
//    var didSelectHabitDayAtIndex: ((Int) -> Void)?
    var selectedHabitDays: ((String) -> Void)?

    var selcteIndex = 0
    var weakDays = [WeekDays(id: 7, shortDayname: "S", dayname: "sunday", isSelected: false),
                    WeekDays(id: 1, shortDayname: "M", dayname: "monday", isSelected: false),
                    WeekDays(id: 2, shortDayname: "T", dayname: "tuesday", isSelected: false),
                    WeekDays(id: 3, shortDayname: "W", dayname: "wednesday", isSelected: false),
                    WeekDays(id: 4, shortDayname: "T", dayname: "thursday", isSelected: false),
                    WeekDays(id: 5, shortDayname: "F", dayname: "friday", isSelected: false),
                    WeekDays(id: 6, shortDayname: "S", dayname: "suturday", isSelected: false)]
    
    func configure(selectedColor:HabitThemeColor) {
        self.register(UINib(nibName: "WeekDaysCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WeekDaysCollectionViewCell")
        self.delegate = self
        self.dataSource = self
        selectedColorTheme = selectedColor
        reloadData()
    }
}

extension WeekCollection:  UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weakDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: "WeekDaysCollectionViewCell", for: indexPath) as? WeekDaysCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(day: weakDays[indexPath.row], selectedColor:selectedColorTheme)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/7 - 10, height:collectionView.frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
                strDays =  i.dayname + "," + strDays
            }
        }
        self.selectedHabitDays?(strDays)
        reloadData()
    }
}
