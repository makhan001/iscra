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
    @IBOutlet weak var viewNavigation:NavigationBarView!
    
    private var selectedIcons = "sport1"
    var habitType: HabitType = .good
    var iconResorces = IconsHabitModel()
    var selectedColorTheme =  ColorStruct(id: "1", colorHex: "#ff7B86EB", isSelect: true)
    private let viewModel = AddHabitViewModel()
    weak var router: NextSceneDismisser?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension SetThemeViewController {
    func setup() {
        viewModel.view = self
        self.viewNavigation.lblTitle.text = ""
        self.viewNavigation.delegateBarAction = self
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        let colorPopUp: ColorPopUpViewController = ColorPopUpViewController.from(from: .habit, with: .colorPopUp)
        colorPopUp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        colorPopUp.delegateColor = self
        self.present(colorPopUp, animated: true, completion: nil)

    }
    
    private func showIcons() {
        let iconPopup: IconPopupViewController = IconPopupViewController.from(from: .habit, with: .iconPopup)
        iconPopup.themeColor = selectedColorTheme
        iconPopup.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        iconPopup.iconResorces = iconResorces
        iconPopup.selectedIcon = self.selectedIcons
        iconPopup.delegateIcon = self
        self.present(iconPopup, animated: true, completion: nil)

    }
    
    private func nextClick() {
        self.viewModel.icon = self.selectedIcons
        self.viewModel.colorTheme = self.selectedColorTheme.colorHex //"#7B86EB"
        viewModel.onAction(action: .setTheme(.setTheme), for: .setTheme)
        viewModel.didNavigateToSetTheme = {
            isNavigate in
            if isNavigate{
               self.router?.push(scene: .reminder)
            }
        }
    }
}

extension SetThemeViewController: selectedColordelegate ,selectedIcondelegate {
    
    func selectedIcon(Icon: String) {
        ImgIcon.image = UIImage(named: Icon)
        self.selectedIcons = Icon
       // self.viewModel.icon = Icon
    }
    
    func selectedColorIndex(color: ColorStruct) {
        selectedColorTheme = color
        ViewColor.backgroundColor = UIColor(hex: color.colorHex)
        ImgIcon.tintColor = UIColor(hex: color.colorHex)
       // self.viewModel.colorTheme = color.colorHex
    }
}

// MARK: API Callback
extension SetThemeViewController: HabitViewRepresentable {
    func onAction(_ action: HabitAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        default:
            break
        }
    }
    
}

// MARK: navigationBarAction Callback
extension SetThemeViewController  : navigationBarAction {
    
    func ActionType()  {
        self.router?.dismiss(controller: .setTheme)
    }
}
