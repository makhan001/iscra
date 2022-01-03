//
//  HabitMatesCollectionView.swift
//  Iscra
//
//  Created by m@k on 03/01/22.
//

import UIKit

class HabitMatesCollectionView: UICollectionView {
    
    var groupMember: [GroupMember] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func configure(groupMember: [GroupMember]) {
        self.groupMember = groupMember
        reloadData()
    }
    
    private func setup() {
        delegate = self
        dataSource = self
        layoutIfNeeded()
        reloadData()
    }
}

extension HabitMatesCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupMember.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(indexPath) as MatesCollectionCell
        cell.configure(with: groupMember[indexPath.row].profileImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 35, height: 35)
    }
}
