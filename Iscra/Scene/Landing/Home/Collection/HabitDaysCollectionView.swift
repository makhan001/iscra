//
//  HabitDaysCollectionView.swift
//  Iscra
//
//  Created by m@k on 30/12/21.
//

import UIKit

class HabitDaysCollectionView: UICollectionView {
    
    var viewModel: HomeViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.setup()
    }
    
    private func setup() {
        contentInsetAdjustmentBehavior = .always
        delegate = self
        dataSource = self
        reloadData()
        layoutIfNeeded()
    }
}

extension HabitDaysCollectionView: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.habitMarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(indexPath) as HabitDaysCell
        cell.configure(viewModel: viewModel, item: viewModel.habitMarks[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel.habitMarks.count <= 3 {
            let width = Int(self.bounds.width) / viewModel.habitMarks.count
            return CGSize(width: width, height: 125)
        } else {
            return CGSize(width: self.bounds.width/3.5, height: 125)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, getSizeAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 125)
    }
}
