//
//  NewGroupCollectionView.swift
//  Iscra
//
//  Created by mac on 25/10/21.
//

import UIKit

class NewGroupCollectionView: UICollectionView {
    
    var viewModel: CommunityViewModel!
    var didSelectInvitedHabitAtIndex: ((Int) -> Void)?
    var arrInvitaions = [Invitaion]()
    
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

extension NewGroupCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.myInvitaions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(indexPath) as CommunityGroupHabit
        cell.configure(with: viewModel.myInvitaions[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                didSelectInvitedHabitAtIndex?(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
}
