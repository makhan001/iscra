//
//  HabitCell.swift
//  Iscra
//
//  Created by mac on 21/10/21.
//

import UIKit

class HabitCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var viewMates: UIView!
    @IBOutlet weak var viewNomates: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgHabit: UIImageView!
    @IBOutlet weak var lblHabitTitle: UILabel!
    @IBOutlet weak var imgHabitMates: UIImageView!
    @IBOutlet weak var lblHabitTitleMates: UILabel!
    @IBOutlet weak var collectionMates: UICollectionView!
    @IBOutlet weak var collectiondays: UICollectionView!
    @IBOutlet weak var constraintWidth:NSLayoutConstraint!
    
    let arr = ["1","1","1"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionMates.register(UINib(nibName: "MatesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MatesCollectionCell")
        self.collectionMates.backgroundColor = UIColor.clear.withAlphaComponent(0)
        self.collectionMates.dataSource = self
        self.collectionMates.delegate = self
        self.collectionMates.reloadData()
        
        self.collectiondays.register(UINib(nibName: "HabitDaysCell", bundle: nil), forCellWithReuseIdentifier: "HabitDaysCell")
        self.collectiondays.dataSource = self
        self.collectiondays.delegate = self
        self.collectiondays.reloadData()
       // setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if arr.count <= 3 {
            constraintWidth.constant =  CGFloat((arr.count * 60))
        }else{
            constraintWidth.constant =  CGFloat((arr.count * 50))
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure() {
        self.lblHabitTitle.text = "GYM Workout"
        self.lblHabitTitleMates.text = "GYM Workout"
        self.imgHabit.image = #imageLiteral(resourceName: "google")
        self.imgHabitMates.image = #imageLiteral(resourceName: "google")
        self.viewNomates.isHidden = true
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource and UICollectionViewDelegateFlowLayout
extension HabitCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , CustomCollectionViewLayoutDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectiondays{
            return arr.count
        }else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectiondays{
            guard let cell = self.collectiondays.dequeueReusableCell(withReuseIdentifier: "HabitDaysCell", for: indexPath) as? HabitDaysCell else {
                return UICollectionViewCell()
            }
            cell.configure()
            return cell
        }else{
            guard let cell = self.collectionMates.dequeueReusableCell(withReuseIdentifier: "MatesCollectionCell", for: indexPath) as? MatesCollectionCell else {
                return UICollectionViewCell()
            }
            cell.configure()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectiondays{
            if arr.count <= 3 {
                return CGSize(width: Int(self.collectiondays.bounds.width) / arr.count - 10, height: 125)
            }else{
                return CGSize(width: self.collectiondays.bounds.width/3.5, height: 125)
            }
        }else {
            return CGSize(width: 35, height: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, getSizeAtIndexPath indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectiondays{
            return CGSize(width: 50, height: 125)
        }else {
            return CGSize(width: 35, height: 35)
        }
    }
    
}
