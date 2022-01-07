//
//  IconHeaderCollectionView.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import UIKit
import Foundation

class IconHeaderCollectionView: UICollectionView {
    
    var viewModel: IconsViewModel!
    var didSelectCategoryAtIndex:((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func configure(viewModel: IconsViewModel) {
        self.viewModel = viewModel
    }
    
    private func setup() {
        delegate = self
        dataSource = self
        reloadData()
    }
}

extension IconHeaderCollectionView:  UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.iconCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(indexPath) as IconHeaderCollectionViewCell
        cell.configure(title: viewModel.iconCategory[indexPath.row].habitName, isSelected: viewModel.iconCategory[indexPath.item].isSelected)
        if self.viewModel.categoryIndex == indexPath.item {
            self.viewModel.iconCategory[indexPath.row].isSelected = true
        } else {
            self.viewModel.iconCategory[indexPath.item].isSelected = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4 , height:collectionView.frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectCategoryAtIndex?(indexPath.item)
    }
}
