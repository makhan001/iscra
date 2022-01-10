//
//  HabitDaysCollectionView.swift
//  Iscra
//
//  Created by m@k on 30/12/21.
//

import UIKit

enum HabitDaysSourceScreen: String {
    case home
    case friend
}

class HabitDaysCollectionView: UICollectionView {

    var colorTheme: String = ""
    var habitMarks: [HabitMark] = []
    var sourceScreen: HabitDaysSourceScreen = .home
    var didMarkAsComplete:((Int) ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func configure(colorTheme: String, habitMark: [HabitMark], sourceScreen: HabitDaysSourceScreen = .home) {
        self.colorTheme = colorTheme
        self.habitMarks = habitMark
        self.habitMarks.sort { Int($0.habitDay!) > Int($1.habitDay!) } 
        self.sourceScreen = sourceScreen
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
        cell.didMarkAsComplete = didMarkAsComplete
        cell.configure(item: habitMarks[indexPath.row], colorTheme: colorTheme, tag: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if sourceScreen == .home {
           return CGSize(width: collectionView.bounds.width / 3.0, height: 125.0)
        } else {
            return CGSize(width: collectionView.bounds.width / 7.0, height: 125.0)
        }
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
