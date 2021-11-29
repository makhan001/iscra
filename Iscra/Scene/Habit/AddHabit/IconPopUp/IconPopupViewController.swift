//
//  iconPopupViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import UIKit
protocol selectedIcondelegate:class {
    func selectedIcon(Icon:String)
}
class IconPopupViewController: UIViewController {
    @IBOutlet weak var backGroundView:UIView!
    @IBOutlet weak var IocnHeaderCollection:IconHeader!
    @IBOutlet weak var IconCollection:IconCollectionView!
    var iconResorces = IconsHabitModel()
    var themeColor = ColorStruct(id: "1", colorHex: "#ff7B86EB", isSelect: true)
    var icons = [IconModel]()
    var selectedCategoryIndex = 0
    var selectedIcon = "sport1"
    var delegateIcon:selectedIcondelegate?
    
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
        delegateIcon?.selectedIcon(Icon: selectedIcon)
    }
}

extension IconPopupViewController: selectedIconCatogory , selectedIcon{
    
    func selectedIconIndex(Index: Int) {
        let dict = iconResorces.iconCategory?[selectedCategoryIndex].icons?[Index]
        for iconCategoryIndex in 0..<iconResorces.iconCategory!.count{
            if iconCategoryIndex != selectedCategoryIndex {
                for iconCategoryIndex in 0..<(iconResorces.iconCategory?[selectedCategoryIndex].icons!.count)!{
                    iconResorces.iconCategory?[selectedCategoryIndex].icons?[iconCategoryIndex].value = 0
                }
            }
            else{
                if dict?.value == 0 {
                    iconResorces.iconCategory?[selectedCategoryIndex].icons?[Index].value = 1
                    selectedIcon = iconResorces.iconCategory?[selectedCategoryIndex].icons?[Index].iconName ?? "sport1"
                    delegateIcon?.selectedIcon(Icon: selectedIcon)
                }
                else {
                    iconResorces.iconCategory?[selectedCategoryIndex].icons?[Index].value = 0
                }
                icons =  iconResorces.iconCategory?[selectedCategoryIndex].icons ?? [IconModel]()
                iconResorces.iconCategory?[selectedCategoryIndex].icons  = icons
                IconCollection.configure(icons: icons, theme: themeColor.colorHex)
            }
        }
    }
    
    func selected(Index: Int) {
        selectedCategoryIndex = Index
        IconCollection.configure(icons: iconResorces.iconCategory?[Index].icons ?? [IconModel](), theme: themeColor.colorHex)
    }
}
