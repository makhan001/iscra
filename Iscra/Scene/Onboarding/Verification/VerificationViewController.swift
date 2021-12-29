//
//  VerificationViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 01/11/21.
//

import UIKit

class VerificationViewController: UIViewController {
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblMiddleTittle: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnResendCode: UIButton!
    
    
    @IBOutlet weak var otpTextFieldThird: UITextField!
    @IBOutlet weak var otpTextFieldFirst: UITextField!
    @IBOutlet weak var otpTextFieldSecond: UITextField!
    @IBOutlet weak var otpTextFieldFourth: UITextField!
    
    @IBOutlet weak var verificationTransparentView: UIView!
    
    weak var router: NextSceneDismisser?
    weak var delegate: VerificationViewControllerDelegate?
    private let viewModel: VerificationViewModel = VerificationViewModel(provider: OnboardingServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}
// MARK:- Instance Methods
extension VerificationViewController {
    private func setup() {
        self.viewModel.view = self
        self.setViewControls()
        self.startTimer()
    }
    
    private func setViewControls() {
        self.otpTextFieldFirst.becomeFirstResponder()
        self.lblHeaderTitle.text = AppConstant.otpHeaderTitle
        self.lblMiddleTittle.text = AppConstant.otpMiddleTittle
        self.setViewTextFields()
        [btnCancel, btnResendCode, btnSubmit].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    private func setViewTextFields() {
        [otpTextFieldFirst, otpTextFieldSecond, otpTextFieldThird, otpTextFieldFourth].forEach {
            $0?.delegate = self
            self.addBottomLayerTo(textField: $0 ?? UITextField())
            if $0 == self.otpTextFieldFirst {
                $0?.becomeFirstResponder()
            }
        }
    }
    
    private func addBottomLayerTo(textField: UITextField) {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.frame = CGRect(x: -5, y: textField.frame.height + 5, width: textField.frame.width  , height: 2)
        textField.layer.addSublayer(layer)
    }
    
    private func startTimer() {
        self.btnResendCode.isHidden = true
        self.lblTimer.isHidden = false
        self.viewModel.timerRemainingSeconds = 30
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.viewModel.timerRemainingSeconds > 0 {
                
                let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.black]
                
                let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor(named: "PrimaryAccent")]
                
                let attributedString1 = NSMutableAttributedString(string:"Resend code in ", attributes:attrs1)
                
                let attributedString2 = NSMutableAttributedString(string:"\(self.viewModel.timerRemainingSeconds) seconds", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                self.lblTimer.attributedText = attributedString1
                self.lblTimer.text = "Resend code in " + "\(self.viewModel.timerRemainingSeconds) seconds"
                self.viewModel.timerRemainingSeconds -= 1
            } else {
                self.btnResendCode.isHidden = false
                self.lblTimer.isHidden = true
                Timer.invalidate()
            }
        }
    }
}

// MARK:- Button Action
extension VerificationViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnResendCode:
            self.resendCodeAction()
        case btnSubmit:
            self.submitAction()
        case btnCancel:
            self.dismiss(animated: true)
        default:
            break
        }
    }
    
    private func resendCodeAction() {
        self.viewModel.onAction(action: .resendVerification, for: .verification)
        self.startTimer()
    }
    
    private func submitAction() {
        self.viewModel.strText1 = self.otpTextFieldFirst.text ?? ""
        self.viewModel.strText2 = self.otpTextFieldSecond.text ?? ""
        self.viewModel.strText3 = self.otpTextFieldThird.text ?? ""
        self.viewModel.strText4 = self.otpTextFieldFourth.text ?? ""
        self.viewModel.onAction(action: .inputComplete(.verification), for: .verification)
    }
}

// MARK:- TextField Delegate
extension VerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((textField.text?.count)! < 1) && (string.count > 0) {
            switch textField {
            case otpTextFieldFirst:
                otpTextFieldSecond.becomeFirstResponder()
            case otpTextFieldSecond:
                otpTextFieldThird.becomeFirstResponder()
            case otpTextFieldThird:
                otpTextFieldFourth.becomeFirstResponder()
            case otpTextFieldFourth:
                otpTextFieldFourth.resignFirstResponder()
            default:
                break
            }
            textField.text = string
            return false
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            switch textField {
            case otpTextFieldFirst:
                otpTextFieldFirst.resignFirstResponder()
            case otpTextFieldSecond:
                otpTextFieldFirst.becomeFirstResponder()
            case otpTextFieldThird:
                otpTextFieldSecond.becomeFirstResponder()
            case otpTextFieldFourth:
                otpTextFieldThird.becomeFirstResponder()
            default:
                break
            }
            textField.text = ""
            return false
        } else { if (textField.text?.count)! >= 1 {
            textField.text = string
            DispatchQueue.main.async {
                self.dismissKeyboard()
            }
            return false
        }
            return true
        }
    }
}

// MARK: API Callback
extension VerificationViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case let .verification(msg):
            self.showToast(message: msg, seconds: 0.5)
            if self.viewModel.isResendVerification != true {
                self.router?.dismiss(controller: .verification)
            }
        default:
            break
        }
    }
}

