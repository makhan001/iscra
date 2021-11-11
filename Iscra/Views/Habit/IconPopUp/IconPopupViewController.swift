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
    @IBOutlet weak var IocnCollection:IconCollectionView!
    var iconResorces = [[String:Any]]()
    var themeColor = ColorStruct(id: "1", colorHex: "#ff7B86EB", isSelect: true)
    var icons = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension IconPopupViewController {
    func setup()  {
        IocnHeaderCollection.configure(iconHeader: iconResorces)
        icons =  iconResorces[0]["Icons"] as! [[String : Any]]
        IocnCollection.configure(icons: icons, theme: themeColor.colorHex)
        IocnHeaderCollection.delegateIconCatogory = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backGroundView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension IconPopupViewController: selectedIconCatogory{
    func selected(Index: Int) {
        icons =  iconResorces[Index]["Icons"] as! [[String : Any]]
        IocnCollection.configure(icons: icons, theme: themeColor.colorHex)
    }
}
