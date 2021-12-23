//
//  CommunityMyGroupsCell.swift
//  Iscra
//
//  Created by mac on 25/10/21.
//

import UIKit

class CommunityMyGroupsCell: UICollectionViewCell {
    
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
    
    let arr = ["1","1"]
    var arrHabitMarks: [HabitMark]?
    var colorTheme: String = ""
    
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
        print(" reload on CommunityMyGroupsCell awakeFromNib ")

    }
    
    override func updateConstraints() {
        super.updateConstraints()
       // print("self.arrHabitMarks?.count is \(self.arrHabitMarks?.count)")
        if self.arrHabitMarks?.count == nil {
            constraintWidth.constant =  0
        }else{
        if  self.arrHabitMarks!.count <= 3 {
            constraintWidth.constant =  CGFloat(( self.arrHabitMarks!.count * 45))
        }else{
            constraintWidth.constant =  150
        }
        }
    }
          
    func configure(obj: GroupHabit) {
        self.colorTheme = obj.colorTheme ?? "#ff7B86EB"
        self.arrHabitMarks = obj.habitMarks
        self.lblHabitTitle.text = obj.name?.capitalized
        self.lblHabitTitleMates.text = obj.name?.capitalized
        self.imgHabit.image =  UIImage(named: obj.icon ?? "sport1")
        self.imgHabitMates.image =  UIImage(named: obj.icon ?? "sport1")
        self.imgHabit.tintColor = UIColor(hex: obj.colorTheme ?? "#ff7B86EB")
        self.imgHabitMates.tintColor = UIColor(hex: obj.colorTheme ?? "#ff7B86EB")
        self.viewNomates.isHidden = false
        self.viewMates.isHidden = true
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource and UICollectionViewDelegateFlowLayout
extension CommunityMyGroupsCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , CustomCollectionViewLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectiondays{
                   return  self.arrHabitMarks?.count ?? 0
               }else {
                   return 3
               }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectiondays{
            guard let cell = self.collectiondays.dequeueReusableCell(withReuseIdentifier: "HabitDaysCell", for: indexPath) as? HabitDaysCell else {
                return UICollectionViewCell()
            }
            guard let objHabitMarks = self.arrHabitMarks?[indexPath.row] else {  return UICollectionViewCell()  }
            cell.configureHabitDays(obj: objHabitMarks, colorTheme:  self.colorTheme )
            return cell
        }else{
            guard let cell = self.collectionMates.dequeueReusableCell(withReuseIdentifier: "MatesCollectionCell", for: indexPath) as? MatesCollectionCell else {
                return UICollectionViewCell()
            }
            cell.configure()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, getSizeAtIndexPath indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectiondays{
            return CGSize(width: 50, height: 125)
        }else {
            return CGSize(width: 35, height: 35)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                if collectionView == self.collectiondays{
                    if self.arrHabitMarks!.count <= 3 {
                        return CGSize(width: Int(self.collectiondays.bounds.width) / self.arrHabitMarks!.count - 10, height: 125)
                    }else{
                        return CGSize(width: self.collectiondays.bounds.width/3.5, height: 125)
                    }
                }else {
                    return CGSize(width: 35, height: 35)
                }
    }
}
