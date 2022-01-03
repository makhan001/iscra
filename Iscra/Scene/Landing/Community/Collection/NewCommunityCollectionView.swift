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

class NewCommunityCollectionView: UICollectionView {
    
    var viewModel: CommunityViewModel!
    var didSelectInvitedHabitAtIndex: ((Int) -> Void)?
    var arrInvitaions = [Invitaion]()
    
    weak var communityDelegate : CommunityInvitationDetailDelegate?
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(viewModel: CommunityViewModel) {
        self.viewModel = viewModel
        self.setup()
    }
    
    private func setup() {
        delegate = self
        dataSource = self
        reloadData()
    }
}

extension NewCommunityCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.myInvitaions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(indexPath) as CommunityGroupHabit
        cell.configure(with: viewModel.myInvitaions[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//                didSelectInvitedHabitAtIndex?(indexPath.row)
        let objInvitaion = viewModel.myInvitaions[indexPath.row]
        communityDelegate?.navigate(obj: objInvitaion)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
}
