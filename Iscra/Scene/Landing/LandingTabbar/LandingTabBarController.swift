//
//  LandingTabBarController.swift
//  Iscra
//
//  Created by Lokesh Patil on 21/10/21.
//

import UIKit

class LandingTabBarController: UITabBarController {
    
    var toggle:Bool = false
    let kBarHeight: CGFloat = 60
    var centerButton = UIButton()
    var calendarScreenType: CalendarScreenType = .home
    var subscriptionSourceScreen: SubscriptionSourceScreen = .login
    weak var router: NextSceneDismisser?
    
    
    var home: HomeViewController = HomeViewController.from(from: .landing, with: .home)
    var dialogs: DialogsViewController = DialogsViewController.from(from: .dialogs, with: .dialogs)
    var community: CommunityViewController = CommunityViewController.from(from: .landing, with: .community)
    var myAccount: MyAccountViewController = MyAccountViewController.from(from: .landing, with: .myAccount)
    var addHabit: SelectHabitPopUpViewController = SelectHabitPopUpViewController.from(from: .landing, with: .selectHabitPopUp)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OnboadingUtils.shared.username = ""
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = kBarHeight
        tabFrame.origin.y = self.view.frame.size.height - kBarHeight
        self.tabBar.frame = tabFrame
    }
}

// MARK: Instance Method
extension LandingTabBarController {
    private func setup() {
        self.setupItems()
        self.setTabbar()
        AppDelegate.shared.requestNotificationPermission()
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotateIcon) , name: .RotateTab, object: nil)
        if let newButtonImage = UIImage(named: "tab3") {
            self.addCenterButton(withImage: newButtonImage, highlightImage: newButtonImage)
        }
        self.setnavigationBar()
    }
    
    @objc func rotateIcon(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary?, let name = dict["name"] as? String  {
                self.centerButton.setImage(UIImage(named: name), for: .normal)
        }
    }
    
    private func setTabbar() {
        self.delegate = self
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 20)
        self.tabBar.layer.shadowRadius = 10
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.3
        self.tabBar.isTranslucent = true
        self.tabBar.clipsToBounds = true
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = UIColor(named: "GrayAccent")
        self.tabBar.itemPositioning = .automatic
        self.selectedIndex = 0
    }
    
    func setupItems() {
        let home = UITabBarItem()
        home.image = UIImage(named: "tab1")
        home.tag = 1
        
        let community = UITabBarItem()
        community.image = UIImage(named: "tab2")
        community.tag = 2
        
        let addHabit = UITabBarItem()
        addHabit.tag = 3
        
        let dialogs = UITabBarItem()
        dialogs.image = UIImage(named: "tab4")
        dialogs.tag = 4
        
        let myAccount = UITabBarItem()
        myAccount.image = UIImage(named: "tab5")
        myAccount.tag = 5
        
        self.home.tabBarItem = home
        self.home.router = router
        
        self.community.tabBarItem = community
        self.community.router = router
        
        self.addHabit.tabBarItem = addHabit
        self.addHabit.router = router
        
        self.dialogs.tabBarItem = dialogs
        self.dialogs.router = router
        
        self.myAccount.tabBarItem = myAccount
        self.myAccount.router = router
        
        self.viewControllers = [self.home, self.community, self.addHabit, self.dialogs, self.myAccount]
        self.setViewControllers(self.viewControllers, animated: true)
    }
    
    private func setnavigationBar(){
        if let navigation = self.navigationController {
            navigationItem.rightBarButtonItems = []
            navigationItem.leftBarButtonItems = []
            navigation.isNavigationBarHidden = false
            let leftMyChatBarButtonItem = UIBarButtonItem(title: "My chats", style: .done, target: self, action: #selector(logoutUser))
            leftMyChatBarButtonItem.setTitleTextAttributes([
                                                            NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 28.0)!,
                                                            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8031229377, green: 0.691909194, blue: 0.2029924691, alpha: 1)],
                                                           for: .normal)
            self.navigationItem.leftBarButtonItem  = leftMyChatBarButtonItem
            let usersButtonItem = UIBarButtonItem(image: UIImage(named: "search"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(didTapNewChat(_:)))
            navigationItem.rightBarButtonItem = usersButtonItem
            usersButtonItem.tintColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = .white
            navigationController?.view.backgroundColor = .white
            navigationController?.title = "My chats"
            self.navigationController?.navigationItem.leftBarButtonItem = leftMyChatBarButtonItem
            self.navigationController?.navigationItem.rightBarButtonItem = usersButtonItem
        }
    }
    
    @objc private func didTapNewChat(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Dialogs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateNewDialogViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func logoutUser() {
        print("clicked")
    }
}

extension LandingTabBarController {
    @objc func handleTouchTabbarCenter(sender : UIButton) {
        router?.push(scene: .selectHabitPopUp)
    }
    
    func openAddHabitPopupVC() {
        let selectHabitPopUp: SelectHabitPopUpViewController = SelectHabitPopUpViewController.from(from: .landing, with: .selectHabitPopUp)
        selectHabitPopUp.delegate = self
        self.navigationController?.present(selectHabitPopUp, animated: true, completion: nil)
    }
    
    func addCenterButton(withImage buttonImage : UIImage?, highlightImage: UIImage) {
        let paddingBottom : CGFloat = -4.0
        let button = UIButton()
        button.frame = CGRect(x: 0.0, y: 0.0, width: 60, height: 60)
        self.centerButton = button
        button.setImage(buttonImage, for: .normal)
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .clear
        button.layer.cornerRadius = button.frame.height/2
        button.clipsToBounds = true
        let rectBoundTabbar = self.tabBar.bounds
        let xx = rectBoundTabbar.midX
        let yy = rectBoundTabbar.midY - paddingBottom
        button.center = CGPoint(x: xx, y: yy)
        self.tabBar.addSubview(self.centerButton)
        self.tabBar.bringSubviewToFront(self.centerButton)
        self.centerButton.addTarget(self, action: #selector(handleTouchTabbarCenter), for: .touchUpInside)
    }
}

extension LandingTabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.getIndexVC(index: tabBarController.selectedIndex, viewController: viewController)
    }
    
    func getIndexVC(index: Int, viewController: UIViewController) { // viewAtIndex
        switch index {
        case 0:
            self.calendarScreenType = .home
            self.subscriptionSourceScreen = .login
            if viewController.isKind(of: HomeViewController.self) {
                (viewController as! HomeViewController).router = router
            }
        case 1:
            print("Comunity")
            self.calendarScreenType = .community
            if viewController.isKind(of: CommunityViewController.self) {
                (viewController as! CommunityViewController).router = router
            }
        case 2:
            if viewController.isKind(of: DialogsViewController.self) {
                (viewController as! DialogsViewController).router = router
            }
            print("chatVc")
        case 3:
            if viewController.isKind(of: MyAccountViewController.self) {
                (viewController as! MyAccountViewController).router = router
            }
            print("MyAccount")
        default:
            self.subscriptionSourceScreen = .myAccount
            print("default")
        }
    }
}

extension LandingTabBarController: SelectHabitPopUpDelegate{
    func addHabit(type: HabitType) {
        router?.push(scene: .selectHabitPopUp)
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


