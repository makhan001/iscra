//
//  MyCommunityCollectionView.swift
//  Iscra
//
//  Created by mac on 25/10/21.
//

import UIKit

class MyCommunityCollectionView: UICollectionView , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var count: Int = 0
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    func configure(obj: Int) {
        self.register(UINib(nibName: "CommunityMyGroupsCell", bundle: nil), forCellWithReuseIdentifier: "CommunityMyGroupsCell")
        self.delegate = self
        self.dataSource = self
        self.count = obj
        reloadData()
    }
    
    // MARK: UICollectionViewDataSource

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityMyGroupsCell", for: indexPath) as? CommunityMyGroupsCell else { return UICollectionViewCell() }
        
        cell.configure()
            return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  (collectionView.bounds.size.width - 10 ) , height: 161)

    }
   
}
