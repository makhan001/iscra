//
//  SignupViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit


class SignupViewController: UIViewController {
    
    // MARK:-Outlets and variables
    
    @IBOutlet weak var lblHeaderTitle:UILabel!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var btnGoogle:UIButton!
    @IBOutlet weak var btnApple:UIButton!
    @IBOutlet weak var btnShowPassword:UIButton!
    
    weak var router: NextSceneDismisser?
    private let viewModel: SignupViewModel = SignupViewModel(provider: OnboardingServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: Instance Methods
extension SignupViewController {
    private func setup() {
        viewModel.view = self
        lblHeaderTitle.text = AppConstant.signUpHeaderTitle
        [txtEmail, txtPassword].forEach {
            $0?.delegate = self
        }
        [btnRegister, btnGoogle, btnApple, btnShowPassword].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        
        if TARGET_OS_SIMULATOR == 1 {
            viewModel.email = "user87@gmail.com"
            viewModel.password = "123456"
            txtEmail.text = viewModel.email
            txtPassword.text = viewModel.password
        }
    }
}

// MARK: Button Actions
extension SignupViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnRegister:
            self.registerAction()
        case btnGoogle:
            self.registerGoogleAction()
        case btnApple:
            self.registerAppleAction()
        case btnShowPassword:
            self.showPasswordAction()
        default:
            break
        }
    }
    
    private func registerGoogleAction() {
        print("googleLogin")
    }
    
    private func registerAppleAction() {
        print("Applelogin")
    }
    
    private func showPasswordAction() {
        print("showPasswordAction is \(txtPassword.isSecureTextEntry)")
        if  txtPassword.isSecureTextEntry == true {
            self.btnShowPassword.setImage(UIImage(named: "eyeHidden"), for: .normal)
            txtPassword.isSecureTextEntry = false
        }else{
            self.btnShowPassword.setImage(UIImage(named: "eyeVisible"), for: .normal)
            txtPassword.isSecureTextEntry = true
        }
    }
    
    private func forgotPasswordAction() {
        print("forgotPasswordAction")
    }
    
    private func registerAction() {
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        viewModel.onAction(action: .inputComplete(.signup), for: .signup)
    }
}

// MARK:- Verification Delegate
extension SignupViewController : VerificationViewControllerDelegate {
    func isUserVerified() {
        router?.push(scene: .landing)
    }
}

// MARK:- Textfiled Delegate
extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            self.txtEmail.becomeFirstResponder()
        } else {
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
extension SignupViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case .register:
            router?.push(scene: .verification)
        default:
            break
        }
    }
}
