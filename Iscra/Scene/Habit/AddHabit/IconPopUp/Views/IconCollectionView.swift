//
//  IconCollectionView.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import Foundation
import UIKit
protocol selectedIcon : class {
    func selectedIconIndex(Index:Int)
}

class IconCollectionView: UICollectionView{
    
    var iconArray = [IconModel]()
    var selcteIndex = 0
    var themeColor = ""
    weak var delegateIcon:selectedIcon?
    
    func configure(icons : [IconModel], theme:String) {
        self.register(UINib(nibName: "IconCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IconCollectionViewCell")
        self.iconArray = icons
        themeColor = theme
        self.delegate = self
        self.dataSource = self
        reloadData()
    }
}

extension IconCollectionView:  UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: "IconCollectionViewCell", for: indexPath) as? IconCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(iconArr: iconArray[indexPath.row], theme: themeColor)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/4 - 10
        return CGSize(width: width , height: width )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selcteIndex = indexPath.row
        delegateIcon?.selectedIconIndex(Index: indexPath.row)
        
        print("selectedCategoryIndex on didselect is \(indexPath.row)")
    }
}
