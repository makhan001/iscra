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
   
    var delegateColor:selectedColordelegate?
    var selectedColor:ColorStruct = ColorStruct(id: "1", colorHex: "#ff7B86EB", isSelect: true)
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backGroundView.addGestureRecognizer(tap)
        colorCollection.configure()
        colorCollection.delegateColor = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorCollection.layoutIfNeeded()
        self.cnsCollectionHeight.constant = (colorCollection.frame.width/4 - 10) * 2
    }
  
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        delegateColor?.selectedColorIndex(color: selectedColor)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ColorPopUpViewController: selectedColordelegate {
    func selectedColorIndex(color: ColorStruct) {
        print(color)
        delegateColor?.selectedColorIndex(color: color)
        selectedColor = color
    }
}
