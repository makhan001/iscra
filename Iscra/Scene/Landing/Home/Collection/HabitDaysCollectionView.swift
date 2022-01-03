//
//  HabitDaysCollectionView.swift
//  Iscra
//
//  Created by m@k on 30/12/21.
//

import UIKit

class HabitDaysCollectionView: UICollectionView {

    var colorTheme: String = ""
    var habitMarks: [HabitMark] = []
    
    
    let columnFlowLayout = ColumnFlowLayout(
        cellsPerRow: 3,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func configure(colorTheme: String, habitMark: [HabitMark]) {
        self.colorTheme = colorTheme
        self.habitMarks = habitMark
        reloadData()
    }
    
    private func setup() {
        delegate = self
        dataSource = self
        layoutIfNeeded()
        reloadData()
    }
}

extension HabitDaysCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return habitMarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(indexPath) as HabitDaysCell
        cell.configure(item: habitMarks[indexPath.row], colorTheme: colorTheme)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width / 3.0, height: 125.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5.0
    }
}
