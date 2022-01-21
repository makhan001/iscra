//
//  IconCollectionView.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import UIKit
import Foundation

class IconCollectionView: UICollectionView {
    
    var viewModel: IconsViewModel!
    var didSelectIconAtIndex:((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func configure(viewModel: IconsViewModel) {
        self.viewModel = viewModel
        self.setup()
    }
    
    private func setup() {
        delegate = self
        dataSource = self
        reloadData()
    }
}

extension IconCollectionView: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(indexPath) as IconCollectionViewCell
        cell.configure(item: viewModel.icons[indexPath.row], theme: viewModel.themeColor.colorHex)
        if viewModel.iconIndex == indexPath.item {
            viewModel.icons[indexPath.item].isSelected = true
        } else {
            viewModel.icons[indexPath.item].isSelected = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/4 - 10
        return CGSize(width: width , height: width )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectIconAtIndex?(indexPath.row)
    }
}
