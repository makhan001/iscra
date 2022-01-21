//
//  MatesCollectionView.swift
//  Iscra
//
//  Created by mac on 02/11/21.
//

import UIKit

class MatesCollectionView: UICollectionView , UICollectionViewDelegate , UICollectionViewDataSource, CustomCollectionViewLayoutDelegate{
    
    var arrMemberList: [UsersProfileImageURL]?
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(arrMember: [UsersProfileImageURL]?) {
        self.register(UINib(nibName: "MatesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MatesCollectionCell")
        self.delegate = self
        self.dataSource = self
        self.arrMemberList = arrMember!
        reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrMemberList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(indexPath) as MatesCollectionCell
        cell.configure(with: self.arrMemberList?[indexPath.row].profileImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, getSizeAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35, height: 35)
    }
}
