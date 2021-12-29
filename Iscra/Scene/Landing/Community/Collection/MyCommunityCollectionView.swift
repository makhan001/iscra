//
//  MyCommunityCollectionView.swift
//  Iscra
//
//  Created by mac on 25/10/21.
//

import UIKit

class MyCommunityCollectionView: UICollectionView , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var myGroupList = [GroupHabit]()
    var didSelectCollectionAtIndex:((Int) -> Void)?
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(myGroups: [GroupHabit]) {
        self.register(UINib(nibName: "CommunityMyGroupsCell", bundle: nil), forCellWithReuseIdentifier: "CommunityMyGroupsCell")
        self.delegate = self
        self.dataSource = self
        self.myGroupList = myGroups
        reloadData()
    }
    
    // MARK: UICollectionViewDataSource
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myGroupList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectCollectionAtIndex?(indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityMyGroupsCell", for: indexPath) as? CommunityMyGroupsCell else { return UICollectionViewCell() }
        let objMyGroupList = self.myGroupList[indexPath.row]
        cell.configure(obj: objMyGroupList)
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                if !self.myGroupList.isEmpty {
                    return CGSize(width:  (collectionView.bounds.size.width - 10 ) , height: 161)
                } else {
                     return CGSize(width: 386.0, height: 161.0)
                }
    }
}
