//
//  LandingTabBarViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 21/10/21.
//

import UIKit

class LandingTabBarViewController: UITabBarController {
    
    var toggle:Bool = false
    weak var router: NextSceneDismisser?
    
    private var home: HomeViewController = HomeViewController.from(from: .landing, with: .home)
    private var myAccount: MyAccountViewController = MyAccountViewController.from(from: .landing, with: .myAccount)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if let newButtonImage = UIImage(named: "tab3") {
            self.addCenterButton(withImage: newButtonImage, highlightImage: newButtonImage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBarController?.selectedIndex = 1
    }
    
}
extension LandingTabBarViewController {
    
    @objc func handleTouchTabbarCenter(sender : UIButton) {
        self.openAddHabitPopupVC()
    }
    
    func openAddHabitPopupVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectHabitPopUpViewController") as! SelectHabitPopUpViewController
        vc.delegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func addCenterButton(withImage buttonImage : UIImage, highlightImage: UIImage) {
        let paddingBottom : CGFloat = -4.0
        
        let button = UIButton()
        button.frame = CGRect(x: 0.0, y: 0.0, width: 60, height: 60)
        button.setImage(buttonImage, for: .normal)
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .clear
        button.layer.cornerRadius = button.frame.height/2
        button.clipsToBounds = true
        let rectBoundTabbar = self.tabBar.bounds
        let xx = rectBoundTabbar.midX
        let yy = rectBoundTabbar.midY - paddingBottom
        button.center = CGPoint(x: xx, y: yy)
        self.tabBar.addSubview(button)
        self.tabBar.bringSubviewToFront(button)
        button.addTarget(self, action: #selector(handleTouchTabbarCenter), for: .touchUpInside)
        
    }
}
extension LandingTabBarViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.getIndexVC(index: tabBarController.selectedIndex, viewController: viewController)
    }
    
    func getIndexVC(index: Int, viewController: UIViewController) {
        switch index {
        case 0:
            print("HomeVC")
        case 1:
            print("Comunity")
        case 2:
            print("chatVc")
        case 3:
            if viewController.isKind(of: MyAccountViewController.self) {
                (viewController as! MyAccountViewController).router = router
            }
            print("MyAccount")
        default:
            print("default")
        }
    }
}

extension LandingTabBarViewController: selectHabitToAddProtocol{
    func addHabit(habitType: habitType) {
        let storyboard = UIStoryboard(name: "Habit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddHabitViewController") as! AddHabitViewController
        vc.habitType = habitType
        navigationController?.pushViewController(vc, animated: true)
//        switch  habitType {
//        case .good:
//            AddHabitNAvigation()
//        case .bad:
//            let storyboard = UIStoryboard(name: "Habit", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "AddHabitViewController") as! AddHabitViewController
//            vc.habitType = habitType
//            navigationController?.pushViewController(vc, animated: true)
//        case .group:
//            let storyboard = UIStoryboard(name: "Habit", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "AddHabitViewController") as! AddHabitViewController
//            vc.habitType = habitType
//            navigationController?.pushViewController(vc, animated: true)
//        }
//   }
    }
}

class CustomTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 0.0
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height
        }
        return sizeThatFits
    }
}


