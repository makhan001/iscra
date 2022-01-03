//
//  WeekCollection.swift
//  Iscra
//
//  Created by Lokesh Patil on 27/10/21.
//

import UIKit
import Foundation


class WeekCollection: UICollectionView { // WeekCollectionView
    
    var viewModel: AddHabitViewModel!
        
    func confirgure(viewModel: AddHabitViewModel) {
        self.viewModel = viewModel
        self.setup()
    }
    
    private func setup() {
        self.register(UINib(nibName: "WeekDaysCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WeekDaysCollectionViewCell")
        delegate = self
        dataSource = self
        reloadData()
    }
}

extension WeekCollection:  UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.weakDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: "WeekDaysCollectionViewCell", for: indexPath) as? WeekDaysCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(day: viewModel.weakDays[indexPath.row], selectedColor: viewModel.selectedColorTheme)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/7 - 10, height:collectionView.frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.weakDays[indexPath.item].isSelected = !self.viewModel.weakDays[indexPath.item].isSelected
        reloadData()
    }
}
