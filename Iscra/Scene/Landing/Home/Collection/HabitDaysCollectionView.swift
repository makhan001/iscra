//
//  HabitDaysCollectionView.swift
//  Iscra
//
//  Created by m@k on 30/12/21.
//

import UIKit

class HabitDaysCollectionView: UICollectionView {

    var habitMarks: [HabitMark] = []
    var colorTheme: String = ""

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
        contentInsetAdjustmentBehavior = .always
        delegate = self
        dataSource = self
        reloadData()
    }
}

extension HabitDaysCollectionView: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return habitMarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(indexPath) as HabitDaysCell
        cell.configure(item: habitMarks[indexPath.row], colorTheme: colorTheme)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if habitMarks.count <= 3 {
            let width = Int(self.bounds.width) / habitMarks.count
            return CGSize(width: width, height: 125)
        } else {
            return CGSize(width: self.bounds.width/3.5, height: 125)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, getSizeAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 125)
    }
}
