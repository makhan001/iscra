//
//  IconHeader.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import Foundation
import UIKit
protocol selectedIconCatogory : class {
    func selected(Index:Int)
}

class IconHeader: UICollectionView{
    var iconsHeaderTitle = [[String:Any]]()
    weak var delegateIconCatogory:selectedIconCatogory?
    var selcteIndex = 0
    func configure(iconHeader:[[String:Any]]) {
        self.register(UINib(nibName: "IconHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IconHeaderCollectionViewCell")
        iconsHeaderTitle = iconHeader
        self.delegate = self
        self.dataSource = self
        reloadData()
    }
}

extension IconHeader:  UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconsHeaderTitle.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: "IconHeaderCollectionViewCell", for: indexPath) as? IconHeaderCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(title: iconsHeaderTitle[indexPath.row]["habitName"] as! String, SelecedIndex: selcteIndex , index: indexPath.row)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4 , height:collectionView.frame.height )
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selcteIndex = indexPath.row
        delegateIconCatogory?.selected(Index: indexPath.row)
        reloadData()
    }
    
}
