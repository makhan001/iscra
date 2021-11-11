//
//  iconPopupViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import UIKit

class IconPopupViewController: UIViewController {
    @IBOutlet weak var backGroundView:UIView!
    @IBOutlet weak var IocnHeaderCollection:IconHeader!
    @IBOutlet weak var IconCollection:IconCollectionView!
    var iconResorces = IconsHabitModel()
    var themeColor = ColorStruct(id: "1", colorHex: "#ff7B86EB", isSelect: true)
    var icons = [IconModel]()
    var selectedCategoryIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension IconPopupViewController {
    func setup()  {
        IocnHeaderCollection.configure(iconHeader: iconResorces)
        IocnHeaderCollection.delegateIconCatogory = self
        icons =  iconResorces.iconCategory?[0].icons ?? [IconModel]()
        IconCollection.configure(icons: icons, theme: themeColor.colorHex)
        IconCollection.delegateIcon = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backGroundView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension IconPopupViewController: selectedIconCatogory , selectedIcon{
    func selectedIconIndex(Index: Int) {
       
        
        
        let dict = iconResorces.iconCategory?[selectedCategoryIndex].icons?[Index]
        if dict?.value == 0 {
            iconResorces.iconCategory?[selectedCategoryIndex].icons?[Index].value = 1
        }
        else {
            iconResorces.iconCategory?[selectedCategoryIndex].icons?[Index].value = 0
        }
        icons =  iconResorces.iconCategory?[selectedCategoryIndex].icons ?? [IconModel]()
        IconCollection.configure(icons: icons, theme: themeColor.colorHex)
    }
    
    func selected(Index: Int) {
        icons =  iconResorces.iconCategory?[Index].icons ?? [IconModel]()
        selectedCategoryIndex = Index
        IconCollection.configure(icons: icons, theme: themeColor.colorHex)
    }
}
