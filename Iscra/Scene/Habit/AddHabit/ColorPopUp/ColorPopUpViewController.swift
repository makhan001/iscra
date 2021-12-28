//
//  ColorPopUpViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import UIKit

class ColorPopUpViewController: UIViewController {
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var colorCollection: ColorCollection!
    @IBOutlet weak var cnsCollectionHeight: NSLayoutConstraint!

    var isFormEditHabit: Bool = false
    var colorTheme: String = "#ff7B86EB"
    var delegateColor:HabitThemeColorDelegate?
    var getUpdetedColorHex:((_ updetedColorHex: String)  ->())?
    var selectedColor:HabitThemeColor = HabitThemeColor(id: "1", colorHex: "#ff7B86EB", isSelected: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backGroundView.addGestureRecognizer(tap)
        self.collectionViewConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorCollection.layoutIfNeeded()
        self.cnsCollectionHeight.constant = (colorCollection.frame.width/4 - 10) * 2
    }
  
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        delegateColor?.selectedHabitTheme(color: selectedColor)
        self.updatedColorHex(colorHex: selectedColor.colorHex)
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionViewConfigure() {
        if self.isFormEditHabit == true {
                var updatedArray:[HabitThemeColor] = []
                for i in self.colorCollection.colorItem {
                    if  i.colorHex == self.colorTheme {
                    updatedArray.append(HabitThemeColor(id: i.id, colorHex: i.colorHex, isSelected: true))
                } else {
                    updatedArray.append(HabitThemeColor(id: i.id, colorHex: i.colorHex, isSelected: false))
                }
            }
                self.colorCollection.colorItem = updatedArray
            }
        colorCollection.configure()
        colorCollection.delegateColor = self
        self.selectedColor.colorHex = self.colorTheme
    }
}

extension ColorPopUpViewController: HabitThemeColorDelegate {
    func selectedHabitTheme(color: HabitThemeColor) {
        print("color.colorHex is \(color.colorHex)")
        self.updatedColorHex(colorHex: color.colorHex)
        delegateColor?.selectedHabitTheme(color: color)
        selectedColor = color
    }
    
    func updatedColorHex(colorHex: String) {
        if self.isFormEditHabit == true {
        self.getUpdetedColorHex!(colorHex)
        }
    }
}
