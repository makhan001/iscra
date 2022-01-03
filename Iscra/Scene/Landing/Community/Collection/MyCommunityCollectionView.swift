//
//  MyCommunityCollectionView.swift
//  Iscra
//
//  Created by mac on 25/10/21.
//

import UIKit

class MyCommunityCollectionView: UICollectionView {
    
    var viewModel: CommunityViewModel!
    var didSelectCollectionAtIndex:((Int) -> Void)?
    
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

extension MyCommunityCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.myGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusable(indexPath) as CommunityMyGroupsCell
        cell.configure(viewModel: viewModel, groupHabit: viewModel.myGroups[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectCollectionAtIndex?(indexPath.row)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
}
