//
//  LoginViewController.swift

//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit


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
    @IBOutlet weak var viewNavigation:NavigationBarView!
    weak var router: NextSceneDismisser?
    private let viewModel: LoginViewModel = LoginViewModel(provider: OnboardingServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.viewNavigation.lblTitle.text =  "Login"
        self.viewNavigation.delegateBarAction = self
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
        
//        if TARGET_OS_SIMULATOR == 1 {
//            viewModel.email = "ios6@gmail.com"
//            viewModel.password = "123456"
//            txtEmail.text = viewModel.email
//            txtPassword.text = viewModel.password
//        }
    }
    
    func ActionType() {
        router?.dismiss(controller: .login)
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
        
        
        //        router?.push(scene: .landing)
        //
        //        if viewModel.ValidateUserInputs(emailId: txtFieldEmailId.text ?? "", password: txtFieldPassword.text ?? "")
        //        {
        //            viewModel.Login(emailId: txtFieldEmailId.text ?? "", password: txtFieldPassword.text ?? "")
        //            {
        //                self.showToast(message:self.viewModel.LoginData.message , seconds: 3.0)
        //            }
        //        }
        //        else {
        //            print(viewModel.errorMsg)
        //            self.showToast(message:viewModel.errorMsg , seconds: 1.0)
        //        }
    }
    
    private func loginGoogleAction() {
        print("loginGoogleAction")
    }
    
    private func loginAppleAction() {
        //router?.dismiss(controller: .login)
        print("loginAppleAction")
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
        let VC = storyboard?.instantiateViewController(withIdentifier: "forgot") as! ForgotPasswordViewController
        navigationController?.pushViewController(VC, animated: true)
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

// MARK: API Callback
extension LoginViewController: OnboardingViewRepresentable , verificationDelegate {
    func verified() {
        dismiss(animated: false, completion: nil)
        self.router?.push(scene: .landingTab)
//        let seconds = 2.0
//        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
//            self.router?.push(scene: .landingTab)
//            //                let storyboard = UIStoryboard(name: "Landing", bundle: nil)
//            //                let vc = storyboard.instantiateViewController(withIdentifier: "landingTab") as! LandingTabBarViewController
//            //                self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        // deepak
        case let .login(msg, isvarified):
            print("isvarified =====>>>\(isvarified)")
           
           // self.showToast(message: msg)
            //let seconds = 2.0
            if isvarified == true{
                self.router?.push(scene: .landingTab)
//                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
//                    self.router?.push(scene: .landingTab)
//                }
            }
            else {
                let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                VC.delegateOTP = self
                navigationController?.present(VC, animated: true, completion: nil)
            }
            
            
            //            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            //                           let VC = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
            //            VC.delegateOTP = self
            //                           navigationController?.present(VC, animated: true, completion: nil)
            // deepak
            
            
            //        case .login:
            //
            //            router?.push(scene: .landingTab)
            
            // navigate to verification screen
            break
        default:
            break
        }
    }
}
