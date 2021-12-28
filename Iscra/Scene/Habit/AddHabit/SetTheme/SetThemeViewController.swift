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
    var selectedColorTheme =  HabitThemeColor(id: "1", colorHex: "#ff7B86EB", isSelected: true)
    private let viewModel = AddHabitViewModel()
    weak var router: NextSceneDismisser?
    weak var alertDelegate: AlertControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK:- Instance Methods
extension SetThemeViewController {
    private func setup() {
        self.viewModel.view = self
        self.viewNavigation.navType = .addHabit
        self.viewNavigation.commonInit()
        self.viewNavigation.lblTitle.text = ""
        self.viewNavigation.delegateBarAction = self
        self.viewModel.didNavigateToSetTheme = self.didNavigateToSetTheme
        [btnColor, btnIcon, btnNext].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        let IconsDatas = Utils.readLocalFile(forName: "HabitIconsMock")
        parse(jsonData: IconsDatas ?? Data())
        print(IconsDatas!)
    }
    
    private func didNavigateToSetTheme(isNavigate: Bool) {
        if isNavigate{
            self.router?.push(scene: .reminder)
        }
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
    
    private func showHabitCancelAlert() {
        let alertController = UIAlertController(title: "Warning!!", message: "Do you really want exit from adding habit?", preferredStyle: .alert)
        let logoutaction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            HabitUtils.shared.removeAllHabitData()
            self.router?.push(scene: .landing)
        }
        logoutaction.setValue(UIColor.red, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        cancelAction.setValue(UIColor.gray, forKey: "titleTextColor")
        alertController.addAction(logoutaction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
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
        self.viewModel.onAction(action: .setTheme(.setTheme), for: .setTheme)
    }
}

extension SetThemeViewController: HabitThemeColorDelegate ,selectedIcondelegate {
    
    func selectedIcon(Icon: String) {
        ImgIcon.image = UIImage(named: Icon)
        self.selectedIcons = Icon
       // self.viewModel.icon = Icon
    }
    
    func selectedHabitTheme(color: HabitThemeColor) {
        selectedColorTheme = color
        ViewColor.backgroundColor = UIColor(hex: color.colorHex)
        ImgIcon.tintColor = UIColor(hex: color.colorHex)
       // self.viewModel.colorTheme = color.colorHex
    }
}



// MARK: NavigationBarView Callback
extension SetThemeViewController  : NavigationBarViewDelegate {
    func navigationBackAction()  {
        self.router?.dismiss(controller: .setTheme)
    }
    
    func navigationRightButtonAction() {
        self.showHabitCancelAlert()
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
