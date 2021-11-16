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
    @IBOutlet weak var txtEmail:UITextField! // txtEmail txtViewAddress
    @IBOutlet weak var txtPassword:UITextField! // txtPassword
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var btnGoogle:UIButton! // btnGoogle
    @IBOutlet weak var btnApple:UIButton! // btnApple
    @IBOutlet weak var btnShowPassword:UIButton!
    
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
        
        viewModel.onAction(action: .inputComplete(.signup), for: .signup)
        
        
//        if viewModel.ValidateUserInputs(emailId: txtEmail.text ?? "", password: txtPassword.text ?? "")
//        {
//            viewModel.signUp(emailId: txtEmail.text ?? "", password: txtPassword.text ?? "")
//            {
//                let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
//                let VC = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
//                VC.delegateOTP = self
//                self.navigationController?.present(VC, animated: true, completion: {
//                    VC.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
//                })
//            }
//        }
//        else {
//            print(viewModel.errorMsg)
//            self.showToast(message:viewModel.errorMsg , seconds: 1.0)
//        }
    }

}

// MARK:- Textfiled Delegate
extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            self.txtPassword.becomeFirstResponder()
        } else {
            self.txtPassword.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtEmail {
            viewModel.email = textField.text ?? ""
        } else if textField == txtPassword {
            viewModel.password = textField.text ?? ""
        }
        return true
    }
}

// MARK:- Verification Delegate
extension SignupViewController : verificationDelegate {
    func verified() {
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LandingTabBarViewController") as! LandingTabBarViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: API Callback
extension SignupViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case .register:
            // navigate to verification screen
            break
        default:
            break
        }
    }
}
