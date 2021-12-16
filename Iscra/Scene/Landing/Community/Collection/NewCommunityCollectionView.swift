//
//  NewCommunityCollectionView.swift
//  Iscra
//
//  Created by mac on 25/10/21.
//

import UIKit

protocol communityGroupHabitDetail: class {
    func navigate()
}

class NewCommunityCollectionView: UICollectionView , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{

    var count: Int = 0
    weak var delegate1 : communityGroupHabitDetail?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(obj: Int) {
        self.register(UINib(nibName: "CommunityGroupHabit", bundle: nil), forCellWithReuseIdentifier: "CommunityGroupHabit")
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityGroupHabit", for: indexPath) as? CommunityGroupHabit else {
                return UICollectionViewCell()
            }
            cell.configure()
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("navigate")
        delegate1?.navigate()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // return CGSize(width: 289, height: 229)
        return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height)
    }
    
}
