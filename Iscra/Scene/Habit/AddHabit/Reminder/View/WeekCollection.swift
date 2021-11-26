//
//  WeekCollection.swift
//  Iscra
//
//  Created by Lokesh Patil on 27/10/21.
//

import Foundation
import UIKit

struct weekStruct{
    var id : Int
    var shortDayname: String
    var dayname: String
    var isSelect: Bool
}

class WeekCollection: UICollectionView{
    var selectedColorTheme =  ColorStruct(id: "1", colorHex: "#ff7B86EB", isSelect: true)
    
    var selcteIndex = 0
    var weakDays = [weekStruct(id: 7, shortDayname: "S", dayname: "sunday", isSelect: false),
                    weekStruct(id: 1, shortDayname: "M", dayname: "monday", isSelect: false),
                    weekStruct(id: 2, shortDayname: "T", dayname: "tuesday", isSelect: false),
                    weekStruct(id: 3, shortDayname: "W", dayname: "wednusday", isSelect: false),
                    weekStruct(id: 4, shortDayname: "T", dayname: "thrusday", isSelect: false),
                    weekStruct(id: 5, shortDayname: "F", dayname: "friday", isSelect: false),
                    weekStruct(id: 6, shortDayname: "S", dayname: "suturday", isSelect: false)]
    func configure(selectedColor:ColorStruct) {
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
