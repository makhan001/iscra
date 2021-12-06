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
//            viewModel.email = "user10@gmail.com"
//            viewModel.password = "123456"
//            txtEmail.text = viewModel.email
//            txtPassword.text = viewModel.password
//        }

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
        print("loginGoogleAction")
    }
    
    private func loginAppleAction() {
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
//        let VC = storyboard?.instantiateViewController(withIdentifier: "forgot") as! ForgotPasswordViewController
//        navigationController?.pushViewController(VC, animated: true)
        
        let forgot: ForgotPasswordViewController = ForgotPasswordViewController.from(from: .onboarding, with: .forgot)
        self.navigationController?.pushViewController(forgot, animated: true)

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

// MARK: API Callback
extension LoginViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case let .login(msg, isVerified):
            self.showToast(message: msg, seconds: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.naviateUserAfterLogin(isVerified)
            }
        default:
            break
        }
    }
}

