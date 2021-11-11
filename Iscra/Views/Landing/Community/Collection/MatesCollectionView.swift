//
//  MatesCollectionView.swift
//  Iscra
//
//  Created by mac on 02/11/21.
//

import UIKit

class MatesCollectionView: UICollectionView , UICollectionViewDelegate , UICollectionViewDataSource, CustomCollectionViewLayoutDelegate{
    
    var count: Int = 0
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func configure(obj: Int) {
        self.register(UINib(nibName: "MatesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MatesCollectionCell")
        self.delegate = self
        self.dataSource = self
        self.count = obj
        reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatesCollectionCell", for: indexPath) as? MatesCollectionCell else { return UICollectionViewCell() }
        
        cell.configure()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, getSizeAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35, height: 35)
    }
    
    
}
