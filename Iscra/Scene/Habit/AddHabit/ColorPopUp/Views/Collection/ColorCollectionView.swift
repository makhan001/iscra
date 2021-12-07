//
//  ColorCollectionView.swift
//  Iscra
//
//  Created by Lokesh Patil on 25/10/21.
//

import Foundation
import UIKit
protocol selectedColordelegate:class {
    func selectedColorIndex(color:ColorStruct)
}

struct ColorStruct{
    var id : String
    var colorHex: String
    var isSelect: Bool
}

class ColorCollection: UICollectionView {
    var colorItem = [ColorStruct(id: "1", colorHex: "#ff7B86EB", isSelect: true),
                     ColorStruct(id: "2", colorHex: "#ff9F7BEB", isSelect: false),
                     ColorStruct(id: "3", colorHex: "#ffEB7BAA", isSelect: false),
                     ColorStruct(id: "4", colorHex: "#ffEB7B7B", isSelect: false),
                     ColorStruct(id: "5", colorHex: "#ffDDB140", isSelect: false),
                     ColorStruct(id: "6", colorHex: "#ff59C196", isSelect: false),
                     ColorStruct(id: "7", colorHex: "#ff62ACF0", isSelect: false),
                     ColorStruct(id: "8", colorHex: "#ffC69466", isSelect: false)]

    var delegateColor:selectedColordelegate?

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
                if colorItem[index].isSelect == true{
                    colorItem[index].isSelect = false
                } else{
                    colorItem[index].isSelect = true
                }
            }else {
                colorItem[index].isSelect = false
            }
        }
        collectionView.reloadData()
        let filtered = colorItem.filter { $0.isSelect == true }
        if filtered.count > 0 {
            delegateColor?.selectedColorIndex(color: filtered[0])
        }
    }
}
