//
//  ColorCollectionView.swift
//  Iscra
//
//  Created by Lokesh Patil on 25/10/21.
//

import UIKit
import Foundation

protocol HabitThemeColorDelegate:class { // HabitThemeColorDelegate
    func selectedHabitTheme(color:HabitThemeColor) // selectedHabitTheme
}

class ColorCollection: UICollectionView {
    var colorItem = [HabitThemeColor(id: "1", colorHex: "#ff7B86EB", isSelected: true),
                     HabitThemeColor(id: "2", colorHex: "#ff9F7BEB", isSelected: false),
                     HabitThemeColor(id: "3", colorHex: "#ffEB7BAA", isSelected: false),
                     HabitThemeColor(id: "4", colorHex: "#ffEB7B7B", isSelected: false),
                     HabitThemeColor(id: "5", colorHex: "#ffDDB140", isSelected: false),
                     HabitThemeColor(id: "6", colorHex: "#ff59C196", isSelected: false),
                     HabitThemeColor(id: "7", colorHex: "#ff62ACF0", isSelected: false),
                     HabitThemeColor(id: "8", colorHex: "#ffC69466", isSelected: false)]

    var delegateColor:HabitThemeColorDelegate?

    func configure() {
        self.register(UINib(nibName: "ColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ColorCollectionViewCell")
        self.delegate = self
        self.dataSource = self
        reloadData()
    }
}

extension ColorCollection:  UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorItem.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as? ColorCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(color: colorItem[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/4 - 10
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for index in 0..<colorItem.count{
            if indexPath.row == index{
                if colorItem[index].isSelected == true{
                    colorItem[index].isSelected = false
                } else {
                    colorItem[index].isSelected = true
                }
            } else {
                colorItem[index].isSelected = false
            }
        }
        collectionView.reloadData()
        let filtered = colorItem.filter { $0.isSelected == true }
        if filtered.count > 0 {
            delegateColor?.selectedHabitTheme(color: filtered[0])
        }
    }
}
