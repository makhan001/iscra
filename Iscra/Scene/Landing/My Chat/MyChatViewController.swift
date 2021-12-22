//
//  MyChatViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 22/11/21.
//

//import UIKit
//import Quickblox
//import SVProgressHUD
//
//class MyChatViewController: UIViewController {
//    
//    weak var router: NextSceneDismisser?
//    
//    @IBOutlet var lblNo: UILabel!
//    private var inputedLogin: String?
//    private var inputedUsername: String?
//    
//    var dialogID: String? {
//        didSet {
//            handlePush()
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        SVProgressHUD.show()
//        
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        print("OpenChatUI")
//        self.setChatLoginSetup()
//        self.tabBarController?.tabBar.isHidden = false
//    }
//    //Mark:- Login Chat
//    func setChatLoginSetup() {
//        //Spinner.show("")
//        //  let userEmail = UserDefaults.standard.value(forKey: Message.shared.K_UserEmail) as? String ?? ""
//        
//        let userEmail = UserStore.userEmail//"ameena@gmail.com"//jitu99@gmail.com"
//        let userPassword = "12345678"
//        
//        QBRequest.logIn(withUserEmail: UserStore.userEmail ?? "",
//                        password: userPassword) { (response, user) in
//            let current = Profile()
//            do {
//                let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
//                let userDefaults = UserDefaults.standard
//                userDefaults.set(data, forKey: UserProfileConstant.curentProfile)
//            } catch {
//                debugPrint("[Profile] Couldn't write file to UserDefaults")
//            }
//            print(current.fullName)
//            print("LoginChatSuccess",user)
//            self.connectToChat(user: user)
//            
//        } errorBlock: { (response) in
//            print("LoginChatNotSuccess",response)
//        }
//    }
//    //Mark:- Connect to chat
//    private func connectToChat(user: QBUUser) {
//        //infoText = LoginStatusConstant.intoChat
//        let userPassword = "12345678"//"jitu12345"
//        
//        if QBChat.instance.isConnected == true {
//            //did Login action
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .nanoseconds(Int(0.01))) {
//                // DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                //AppDelegate.shared.rootViewController.goToDialogsScreen()
//                self.goToDialogsScreen()
//                self.inputedUsername = nil
//                self.inputedLogin = nil
//            }
//        } else {
//            QBChat.instance.connect(withUserID: user.id,
//                                    password: userPassword,
//                                    completion: { [weak self] error in
//                guard let self = self else { return }
//                if let error = error {
//                    if error._code == QBResponseStatusCode.unAuthorized.rawValue {
//                        // Clean profile
//                        Profile.clearProfile()
//                        // self.defaultConfiguration()
//                    } else {
//                        self.showAlertView(LoginConstant.checkInternet, message: LoginConstant.checkInternetMessage)
//                        self.handleError(error, domain: ErrorDomain.logIn)
//                    }
//                } else {
//                    //did Login action
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .nanoseconds(Int(0.01))) {
//                        // AppDelegate.shared.rootViewController.goToDialogsScreen()
//                        self.goToDialogsScreen()
//                        self.inputedUsername = nil
//                        self.inputedLogin = nil
//                    }
//                }
//            })
//        }
//    }
//    
//    //Mark:- Navigate to next screen
//    func goToDialogsScreen() {
//        let storyboard = UIStoryboard(name: "Dialogs", bundle: nil)
//        if let dialogsVC = storyboard.instantiateViewController(withIdentifier: "DialogsViewController") as? DialogsViewController {
//            let dialogsScreen = DialogsNavigationController(rootViewController: dialogsVC)
//            // Change header navigation bar color in my chat controller
//            dialogsScreen.navigationBar.barTintColor = .white
//            dialogsScreen.navigationBar.barStyle = .black
//            dialogsScreen.navigationBar.shadowImage = UIImage()
//            dialogsScreen.navigationBar.isTranslucent = false
//            dialogsScreen.navigationBar.tintColor = .white
//            //group title change text color
//            dialogsScreen.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.616, green: 0.584, blue: 0.486, alpha: 1)]
//            
//            changeCurrentViewController(dialogsScreen)
//            handlePush()
//            // newHandleVC()
//        }
//        else{
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
//            label.center = CGPoint(x: 160, y: 285)
//            label.textAlignment = .center
//            label.text = "I'm a test label"
//            self.view.addSubview(label)
//        }
//    }
//    
//    private func changeCurrentViewController(_ newCurrentViewController: UIViewController) {
//        addChild(newCurrentViewController)
//        newCurrentViewController.view.frame = view.bounds
//        view.addSubview(newCurrentViewController.view)
//        newCurrentViewController.didMove(toParent: self)
//        var current: UIViewController = newCurrentViewController
//        if current == newCurrentViewController {
//            return
//        }
//        current.willMove(toParent: nil)
//        current.view.removeFromSuperview()
//        current.removeFromParent()
//        current = newCurrentViewController
//    }
//    
//    private func handlePush() {
//        let storyboardDia = UIStoryboard(name: "Dialogs", bundle: nil)
//        let dialogsVC = storyboardDia.instantiateViewController(withIdentifier: "DialogsViewController") as? DialogsViewController
//        let dialogsScreen = DialogsNavigationController(rootViewController: dialogsVC!)
//        if let dialogsNavigationController = dialogsVC as? DialogsNavigationController, let dialogID = dialogID {
//            if let dialog = ChatManager.instance.storage.dialog(withID: dialogID) {
//                // Autojoin to the group chat
//                if dialog.type != .private, dialog.isJoined() == false {
//                    dialog.join(completionBlock: { error in
//                        guard let error = error else {
//                            return
//                        }
//                        debugPrint("[RootParentVC] dialog.join error: \(error.localizedDescription)")
//                    })
//                }
//                dialogsNavigationController.popToRootViewController(animated: false)
//                (dialogsNavigationController.topViewController as? DialogsViewController)?.openChatWithDialogID(dialogID)
//                self.dialogID = nil
//            }
//        }
//    }
//    // MARK: - Handle errors
//    private func handleError(_ error: Error?, domain: ErrorDomain) {
//        guard let error = error else {
//            return
//        }
//        var infoText = error.localizedDescription
//        if error._code == NSURLErrorNotConnectedToInternet {
//            infoText = LoginConstant.checkInternet
//        }
//    }
//    
//}
