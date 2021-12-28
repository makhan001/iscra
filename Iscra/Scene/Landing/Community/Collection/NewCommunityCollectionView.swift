//
//  NewCommunityCollectionView.swift
//  Iscra
//
//  Created by mac on 25/10/21.
//

import UIKit

protocol CommunityInvitationDetailDelegate: AnyObject {
    func navigate(obj: Invitaion)
}

class NewCommunityCollectionView: UICollectionView , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    var arrInvitaions = [Invitaion]()
    
    weak var communityDelegate : CommunityInvitationDetailDelegate?
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(myInvitaion: [Invitaion]) {
        self.register(UINib(nibName: "CommunityGroupHabit", bundle: nil), forCellWithReuseIdentifier: "CommunityGroupHabit")
        self.delegate = self
        self.dataSource = self
        self.arrInvitaions = myInvitaion
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrInvitaions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityGroupHabit", for: indexPath) as? CommunityGroupHabit else {
            return UICollectionViewCell()
        }
        let objInvitaion = self.arrInvitaions[indexPath.row]
        cell.configure(obj: objInvitaion)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objInvitaion = self.arrInvitaions[indexPath.row]
        communityDelegate?.navigate(obj: objInvitaion)
        print("navigate")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !self.arrInvitaions.isEmpty {
            return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height)
        } else {
             return CGSize(width: 289, height: 229)
        }
    }
}
