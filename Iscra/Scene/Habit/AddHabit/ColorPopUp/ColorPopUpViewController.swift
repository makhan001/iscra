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
    var objHabitDetail: AllHabits?
    var isFormEditHabit: Bool = false
    var getUpdetedColorHex:((_ updetedColorHex: String)  ->())?

    var delegateColor:selectedColordelegate?
    var selectedColor:ColorStruct = ColorStruct(id: "1", colorHex: "#ff7B86EB", isSelect: true)
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
        delegateColor?.selectedColorIndex(color: selectedColor)
        self.updatedColorHex(colorHex: selectedColor.colorHex)
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionViewConfigure() {
        if self.isFormEditHabit == true {
                var updatedArray:[ColorStruct] = []
                for i in self.colorCollection.colorItem {
                if  i.colorHex == objHabitDetail?.colorTheme {
                    updatedArray.append(ColorStruct(id: i.id, colorHex: i.colorHex, isSelect: true))
                }else{
                    updatedArray.append(ColorStruct(id: i.id, colorHex: i.colorHex, isSelect: false))
                }
            }
                self.colorCollection.colorItem = updatedArray
            }
        colorCollection.configure()
        colorCollection.delegateColor = self
        self.selectedColor.colorHex = objHabitDetail?.colorTheme ?? "#ff7B86EB"
    }
}

extension ColorPopUpViewController: selectedColordelegate {
    func selectedColorIndex(color: ColorStruct) {
        print("color.colorHex is \(color.colorHex)")
        self.updatedColorHex(colorHex: color.colorHex)
        delegateColor?.selectedColorIndex(color: color)
        selectedColor = color
    }
    
    func updatedColorHex(colorHex: String) {
        if self.isFormEditHabit == true {
        self.getUpdetedColorHex!(colorHex)
        }
    }
}
