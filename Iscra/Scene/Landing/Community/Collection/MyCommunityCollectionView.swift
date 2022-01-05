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
        cell.btnHabitDetail.tag = indexPath.item
        cell.btnHabitDetail.addTarget(self,action:#selector(navigateToHabitDetail(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func navigateToHabitDetail(sender:UIButton) {
        if viewModel.myGroups.count > 0 {
            self.didSelectCollectionAtIndex?(sender.tag)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
}
