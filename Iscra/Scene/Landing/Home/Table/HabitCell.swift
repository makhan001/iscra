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
    var habitList = [AllHabits]()
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
    
    func configure(obj: AllHabits) {
        self.lblHabitTitle.text =  obj.name?.capitalized
        self.lblHabitTitleMates.text = obj.name?.capitalized
        self.imgHabit.image = UIImage(named: obj.icon ?? "sport1")
        self.imgHabitMates.image = UIImage(named: obj.icon ?? "sport1")
        self.imgHabit.tintColor = UIColor(hex: obj.colorTheme ?? "#ff7B86EB")
        self.imgHabitMates.tintColor = UIColor(hex: obj.colorTheme ?? "#ff7B86EB")
        self.viewNomates.isHidden = false
        self.viewMates.isHidden = true
//        print("obj.colorTheme \(String(describing: obj.colorTheme))")
//        print("obj.id \(String(describing: obj.id))")
//        print("obj.name \(String(describing: obj.name))")
//        print("obj.reminders \(String(describing: obj.reminders))")
//        print("obj.timer \(String(describing: obj.timer))")
//        print("obj.days \(String(describing: obj.days))")
//        print("obj.habitDescription \(String(describing: obj.habitDescription))")
//        print("obj.habitType \(String(describing: obj.habitType))")
//        print("obj.groupImage \(String(describing: obj.groupImage))")
//        print("obj.userID \(String(describing: obj.userID))")
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
