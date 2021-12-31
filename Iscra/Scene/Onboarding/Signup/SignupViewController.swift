//
//  SignupViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

class SignupViewController: UIViewController {
    
    @IBOutlet weak var btnApple:UIButton!
    @IBOutlet weak var btnGoogle:UIButton!
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var btnShowPassword:UIButton!
    
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    
    @IBOutlet weak var lblHeaderTitle:UILabel!
    
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
        self.viewModel.view = self
        self.setViewControls()
    }
    
    private func setViewControls() {
        self.lblHeaderTitle.text = AppConstant.signUpHeaderTitle
        [txtEmail, txtPassword].forEach {
            $0?.delegate = self
        }
        [btnRegister, btnGoogle, btnApple, btnShowPassword].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        if #available(iOS 13.0, *) {
            btnApple.isHidden = false
        } else {
            btnApple.isHidden = true
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
        GIDSignIn.sharedInstance.signIn(with: self.viewModel.gidConfiguration, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            self.viewModel.email = user.profile?.email ?? ""
            self.viewModel.username = user.profile?.name ?? ""
            self.viewModel.social_id = user.userID ?? ""
            if ((user.profile?.hasImage) != nil) {
                guard let url = user.profile?.imageURL(withDimension: 200) else { return }
                self.viewModel.socialLoginImageURL = url
            }
            self.viewModel.socialLogin(logintype: .google)
        }
    }
    
    private func registerAppleAction() {
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
    
    private func registerAction() {
        self.dismissKeyboard()
        self.viewModel.onAction(action: .inputComplete(.signup), for: .signup)
    }
}

// MARK: Verification Delegate
extension SignupViewController : VerificationViewControllerDelegate {
    func isUserVerified() {
        router?.push(scene: .landing)
    }
}

// MARK: Textfiled Delegate
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
        if string.rangeOfCharacter(from: .whitespacesAndNewlines) != nil { return false }
        guard let text = textField.text, let textRange = Range(range, in: text) else { return false }
        if textField == txtEmail {
            viewModel.email = text.replacingCharacters(in: textRange, with: string)
        } else if textField == txtPassword {
            viewModel.password = text.replacingCharacters(in: textRange, with: string)
        }
        return true
    }
}

// MARK: Apple Login
@available(iOS 13.0, *)
extension SignupViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleCredentials = authorization.credential as? ASAuthorizationAppleIDCredential {
            self.viewModel.email = appleCredentials.email ?? ""
            self.viewModel.username = (appleCredentials.fullName?.givenName) ?? ""
            self.viewModel.social_id = appleCredentials.user
            self.viewModel.socialLogin(logintype: .apple)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
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
