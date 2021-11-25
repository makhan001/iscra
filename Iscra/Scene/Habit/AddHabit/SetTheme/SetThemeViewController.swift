//
//  SetThemeViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 22/10/21.
//

import UIKit

class SetThemeViewController: UIViewController {
   
    @IBOutlet weak var btnIcon:UIButton!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var ViewColor:UIView!
    @IBOutlet weak var btnColor:UIButton!
    @IBOutlet weak var ImgIcon:UIImageView!
    var habitType : habitType = .good
    var iconResorces = IconsHabitModel()
    var selectedColorTheme =  ColorStruct(id: "1", colorHex: "#ff7B86EB", isSelect: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension SetThemeViewController {
    func setup() {
        navigationController?.navigationBar.isHidden = false
        [btnColor, btnIcon, btnNext].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        
//        if let URL = Bundle.main.url(forResource: "HabitIcons", withExtension: "plist") {
//            if let HabitIconsPlist =  NSArray(contentsOf: URL) as? [[String:Any]] {
//              //  print("HabitIconsPlist\(HabitIconsPlist)")
//                iconResorces = HabitIconsPlist
//            }
//        }
//        let IconsData = Utils.fetchDataFromLocalJson(name: "HabitIconsMock") as! [String : Any]
        let IconsDatas = Utils.readLocalFile(forName: "HabitIconsMock")
        parse(jsonData: IconsDatas ?? Data())
        print(IconsDatas!)
    }
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(IconsHabitModel.self,from: jsonData)
            iconResorces = decodedData
            print("iconResorces,\(iconResorces)")
        } catch {
            print("decode error")
        }
    }
}
// MARK:- Button Action
extension SetThemeViewController {
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnColor:
            self.showColor()
        case btnIcon:
            self.showIcons()
        case btnNext:
            self.nextClick()
        default:
            break
        }
    }
    
    private func showColor() {
        let storyboard = UIStoryboard(name: "Habit", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "ColorPopUpViewController") as! ColorPopUpViewController
        pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pvc.delegateColor = self
        self.present(pvc, animated: true, completion: nil)
    }
    private func showIcons() {
        let storyboard = UIStoryboard(name: "Habit", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "IconPopupViewController") as! IconPopupViewController
        pvc.themeColor = selectedColorTheme
        pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pvc.iconResorces = iconResorces
        pvc.delegateIcon = self
        self.present(pvc, animated: true, completion: nil)
    }
    private func nextClick() {
        let storyboard = UIStoryboard(name: "Habit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReminderViewController") as! ReminderViewController
        vc.selectedColorTheme = selectedColorTheme
        vc.habitType = habitType
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension SetThemeViewController : selectedColordelegate ,selectedIcondelegate {
    
    func selectedIcon(Icon: String) {
        ImgIcon.image = UIImage(named: Icon)
    }
    
    func selectedColorIndex(color: ColorStruct) {
        selectedColorTheme = color
        ViewColor.backgroundColor = UIColor(hex: color.colorHex)
        ImgIcon.tintColor = UIColor(hex: color.colorHex)
    }
}

