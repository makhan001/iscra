//
//  LoginViewController.swift

//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import SDWebImage
import Quickblox
import SVProgressHUD

class LoginViewController: UIViewController {
    
    
    
    // MARK:-Outlets and variables
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var lblHeaderTitle:UILabel!
    @IBOutlet weak var btnShowPassword:UIButton!
    @IBOutlet weak var btnForgotPassword:UIButton!
    @IBOutlet weak var btnApple:UIButton!
    @IBOutlet weak var btnGoogle:UIButton!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    private var inputedLogin: String?
    private var inputedUsername: String?
    @IBOutlet weak var viewNavigation:NavigationBarView!
    weak var router: NextSceneDismisser?
    var profileImage: UIImage = UIImage()
    private let viewModel: LoginViewModel = LoginViewModel(provider: OnboardingServiceProvider())
    let signInConfig = GIDConfiguration.init(clientID: AppConstant.googleClientID)
   
    var dialogID: String? {
        didSet {
            handlePush()
        }
    }
    //MARK: - Life Cycle
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
       
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        self.viewNavigation.lblTitle.text =  "Login"
        self.viewNavigation.delegateBarAction = self
        //navigationController?.setNavigationBarHidden(true, animated: animated)
       
       // self.tabBarController?.tabBar.isHidden = false
    }
   
   
}

// MARK: Instance Methods
extension LoginViewController  : navigationBarAction {
    private func setup() {
        self.navigationController?.view.backgroundColor = UIColor.white
        lblHeaderTitle.text = AppConstant.loginHeaderTitle
        viewModel.view = self
        [txtEmail, txtPassword].forEach{
            $0?.delegate = self
        }
        [btnLogin, btnApple, btnGoogle, btnShowPassword, btnForgotPassword].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        if #available(iOS 13.0, *) {
            btnApple.isHidden = false
        } else {
            btnApple.isHidden = true
        }
        
    }
    
    func ActionType()  {
        router?.dismiss(controller: .login)
    }
    
    private func naviateUserAfterLogin(_ isVerified:Bool) {
        if isVerified == true {
            self.router?.push(scene: .landing)
        } else {
            self.router?.push(scene: .verification)
        }
    }
}

// MARK:- Button Action
extension LoginViewController {
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnLogin:
            self.loginAction()
        case btnGoogle:
            self.loginGoogleAction()
        case btnApple:
            self.loginAppleAction()
        case btnShowPassword:
            self.showPasswordAction()
        case btnForgotPassword:
            self.forgotPasswordAction()
        default:
            break
        }
    }
    
    private func loginAction() {
        print("loginAction")
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        viewModel.onAction(action: .inputComplete(.login), for: .login)
    }
    
    private func loginGoogleAction() {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            self.viewModel.email = user?.profile?.email ?? ""
            self.viewModel.username = user?.profile?.name ?? ""
            print("image--->\(user?.profile?.imageURL(withDimension: 2))")
        //Profile Image Code
//            let url = user?.profile?.imageURL(withDimension: 320)
//            let data = try? Data(contentsOf: url!)
//
//            if let imageData = data {
//                let image = UIImage(data: imageData)
//                self.viewModel.selectedImage = image ?? UIImage()
//            }
            
            self.viewModel.social_id = user?.userID ?? ""
            self.viewModel.socialLogin(logintype: .google)
        }
    }
    
    private func loginAppleAction() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func showPasswordAction() {
        if self.btnShowPassword.isSelected {
            self.btnShowPassword.isSelected = false
            self.txtPassword.isSecureTextEntry = true
        } else {
            self.btnShowPassword.isSelected = true
            self.txtPassword.isSecureTextEntry = false
        }
    }
    
    private func forgotPasswordAction() {
        self.router?.push(scene: .forgot)
    }
}

// MARK:- UITextFieldDelegate
extension LoginViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail{
            self.txtPassword.becomeFirstResponder()
        }else{
            self.txtPassword.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtEmail {
            if let text = txtEmail.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                viewModel.email = updatedText
            }
        } else if textField == txtPassword {
            if let text = txtPassword.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                viewModel.password = updatedText
            }
        }
        return true
    }
}

// MARK: Verification View Controller Delegate
extension LoginViewController: VerificationViewControllerDelegate {
    func isUserVerified() {
        self.router?.push(scene: .landing)
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleCredentials = authorization.credential as? ASAuthorizationAppleIDCredential {
            // self.setSocialLoginValues(email: appleCredentials.email ?? "", name: (appleCredentials.fullName?.givenName) ?? "", socialId: appleCredentials.user, loginType: .apple)
            self.viewModel.email = appleCredentials.email ?? ""
            self.viewModel.username = (appleCredentials.fullName?.givenName) ?? ""
            self.viewModel.social_id = appleCredentials.user
            self.viewModel.socialLogin(logintype: .apple)
        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
//Mark:- Chat
extension LoginViewController{
   
    //Mark:- Login Chat
    func setChatLoginSetup() {
        //Spinner.show("")
        //  let userEmail = UserDefaults.standard.value(forKey: Message.shared.K_UserEmail) as? String ?? ""

        let userEmail = UserStore.userEmail//"ameena@gmail.com"//jitu99@gmail.com"
        let userPassword = "12345678"

        QBRequest.logIn(withUserEmail: UserStore.userEmail ?? "",
                        password: userPassword) { (response, user) in
            let current = Profile()
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
                let userDefaults = UserDefaults.standard
                userDefaults.set(data, forKey: UserProfileConstant.curentProfile)
            } catch {
                debugPrint("[Profile] Couldn't write file to UserDefaults")
            }
            print(current.fullName)
            print("LoginChatSuccess",user)
            self.connectToChat(user: user)
            
        } errorBlock: { (response) in
            print("LoginChatNotSuccess",response)
        }
    }
//    private func setupNavigationBar() {
//        navigationItem.rightBarButtonItems = []
//        navigationItem.leftBarButtonItems = []
//        let leftMyChatBarButtonItem = UIBarButtonItem(title: "My chats", style: .done, target: self, action: #selector(logoutUser))
//        leftMyChatBarButtonItem.setTitleTextAttributes([
//            NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 28.0)!,
//            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8031229377, green: 0.691909194, blue: 0.2029924691, alpha: 1)],
//                                                       for: .normal)
//        self.navigationItem.leftBarButtonItem  = leftMyChatBarButtonItem
//        let usersButtonItem = UIBarButtonItem(image: UIImage(named: "search"),
//                                              style: .plain,
//                                              target: self,
//                                              action: #selector(didTapNewChat(_:)))
//        navigationItem.rightBarButtonItem = usersButtonItem
//        usersButtonItem.tintColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        // addInfoButton()
//    }
//    @objc func logoutUser(){
//        print("clicked")
//    }
//    @objc private func didTapNewChat(_ sender: UIBarButtonItem) {
//        performSegue(withIdentifier: DialogsConstant.selectOpponents, sender: sender)
//    }
    //Mark:- Connect to chat
    private func connectToChat(user: QBUUser) {
        //infoText = LoginStatusConstant.intoChat
        let userPassword = "12345678"//"jitu12345"
        
        if QBChat.instance.isConnected == true {
            //did Login action
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .nanoseconds(Int(0.01))) {
                // DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                //AppDelegate.shared.rootViewController.goToDialogsScreen()
              // self.goToDialogsScreen()
                self.inputedUsername = nil
                self.inputedLogin = nil
            }
        } else {
            QBChat.instance.connect(withUserID: user.id,
                                    password: userPassword,
                                    completion: { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    if error._code == QBResponseStatusCode.unAuthorized.rawValue {
                        // Clean profile
                        Profile.clearProfile()
                        // self.defaultConfiguration()
                    } else {
                        self.showAlertView(LoginConstant.checkInternet, message: LoginConstant.checkInternetMessage)
                        self.handleError(error, domain: ErrorDomain.logIn)
                    }
                } else {
                    //did Login action
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .nanoseconds(Int(0.01))) {
                        // AppDelegate.shared.rootViewController.goToDialogsScreen()
                      //  self.goToDialogsScreen()
                        self.inputedUsername = nil
                        self.inputedLogin = nil
                    }
                }
            })
        }
    }
    
    //Mark:- Navigate to next screen
    func goToDialogsScreen() {
       let storyboard = UIStoryboard(name: "Dialogs", bundle: nil)
        if let dialogsVC = storyboard.instantiateViewController(withIdentifier: "DialogsViewController") as? DialogsViewController {
            
            let dialogsScreen = DialogsNavigationController(rootViewController: dialogsVC)
            // Change header navigation bar color in my chat controller
            dialogsScreen.navigationBar.barTintColor = .white
            dialogsScreen.navigationBar.barStyle = .black
            dialogsScreen.navigationBar.shadowImage = UIImage()
            dialogsScreen.navigationBar.isTranslucent = false
            dialogsScreen.navigationBar.tintColor = .white
            //group title change text color
            dialogsScreen.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.616, green: 0.584, blue: 0.486, alpha: 1)]
            
//            changeCurrentViewController(dialogsScreen)
            handlePush()
            // newHandleVC()
        }
        else{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.text = "I'm a test label"
            self.view.addSubview(label)
        }
    }
    
    private func changeCurrentViewController(_ newCurrentViewController: UIViewController) {
        addChild(newCurrentViewController)
        newCurrentViewController.view.frame = view.bounds
        view.addSubview(newCurrentViewController.view)
        newCurrentViewController.didMove(toParent: self)
        var current: UIViewController = newCurrentViewController
        if current == newCurrentViewController {
            return
        }
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = newCurrentViewController
    }
    
    private func handlePush() {
        let storyboardDia = UIStoryboard(name: "Dialogs", bundle: nil)
        let dialogsVC = storyboardDia.instantiateViewController(withIdentifier: "DialogsViewController") as? DialogsViewController
        let dialogsScreen = DialogsNavigationController(rootViewController: dialogsVC!)
        if let dialogsNavigationController = dialogsVC as? DialogsNavigationController, let dialogID = dialogID {
            if let dialog = ChatManager.instance.storage.dialog(withID: dialogID) {
                // Autojoin to the group chat
                if dialog.type != .private, dialog.isJoined() == false {
                    dialog.join(completionBlock: { error in
                        guard let error = error else {
                            return
                        }
                        debugPrint("[RootParentVC] dialog.join error: \(error.localizedDescription)")
                    })
                }
                dialogsNavigationController.popToRootViewController(animated: false)
                (dialogsNavigationController.topViewController as? DialogsViewController)?.openChatWithDialogID(dialogID)
                self.dialogID = nil
            }
        }
    }
    // MARK: - Handle errors
    private func handleError(_ error: Error?, domain: ErrorDomain) {
        guard let error = error else {
            return
        }
        var infoText = error.localizedDescription
        if error._code == NSURLErrorNotConnectedToInternet {
            infoText = LoginConstant.checkInternet
        }
    }
}


// MARK: API Callback
extension LoginViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case let .login(msg, isVerified):
            self.setChatLoginSetup()
            self.showToast(message: msg, seconds: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.naviateUserAfterLogin(isVerified)
            }
        case let .socialLogin(msg):
            self.showToast(message: msg, seconds: 0.45)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.router?.push(scene: .landing)
            }
        default:
            break
        }
    }
}
