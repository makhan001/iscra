//
//  VerificationViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 01/11/21.
//

import UIKit

class VerificationViewController: UIViewController {
    
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnResendCode: UIButton!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblMiddleTittle: UILabel!
    @IBOutlet weak var otpTextFieldThird: UITextField!
    @IBOutlet weak var otpTextFieldFirst: UITextField!
    @IBOutlet weak var otpTextFieldSecond: UITextField!
    @IBOutlet weak var otpTextFieldFourth: UITextField!
    @IBOutlet weak var verificationTransparentView: UIView!
    @IBOutlet weak var lblTimer: UILabel!
    
    weak var router: NextSceneDismisser?
    weak var delegate: VerificationViewControllerDelegate?
    var secondsRemaining = 30
    
    private let viewModel: VerificationViewModel = VerificationViewModel(provider: OnboardingServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        customTextFieldFont()
        addBottomLayerTo(textField: otpTextFieldFirst)
        addBottomLayerTo(textField: otpTextFieldSecond)
        addBottomLayerTo(textField: otpTextFieldThird)
        addBottomLayerTo(textField: otpTextFieldFourth)
        
        
        
    }
    func addBottomLayerTo(textField: UITextField) {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.frame = CGRect(x: 8, y: textField.frame.height + 5, width: textField.frame.width - 10 , height: 2)
        textField.layer.addSublayer(layer)
    }
}
// MARK:- Instance Methods
extension VerificationViewController {
    private func setup() {
        viewModel.view = self
        lblHeaderTitle.text = AppConstant.otpHeaderTitle
        lblMiddleTittle.text = AppConstant.otpMiddleTittle
        otpTextFieldFirst.delegate = self
        otpTextFieldSecond.delegate = self
        otpTextFieldThird.delegate = self
        otpTextFieldFourth.delegate = self
        [btnResendCode, btnSubmit].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        self.startTimer()
    }
    
    private func customTextFieldFont(){
        otpTextFieldFirst.becomeFirstResponder()
    }
    
    // MARK:- SetTimer for resend password
    private func startTimer(){
        self.btnResendCode.isHidden = true
        self.lblTimer.isHidden = false
        self.secondsRemaining = 30
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.secondsRemaining > 0 {
                
                let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.black]
                
                let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor(named: "PrimaryAccent")]
                
                let attributedString1 = NSMutableAttributedString(string:"Resend code in ", attributes:attrs1)
                
                let attributedString2 = NSMutableAttributedString(string:"\(self.secondsRemaining) seconds", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                self.lblTimer.attributedText = attributedString1
                self.lblTimer.text = "Resend code in " + "\(self.secondsRemaining) seconds"
                self.secondsRemaining -= 1
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
            self.btnSubmitAction()
        default:
            break
        }
    }
    
    private func resendCodeAction() {
        viewModel.onAction(action: .resendVerification, for: .verification)
        self.startTimer()
    }
    
    private func btnSubmitAction() {
        self.viewModel.strText1 = self.otpTextFieldFirst.text ?? ""
        self.viewModel.strText2 = self.otpTextFieldSecond.text ?? ""
        self.viewModel.strText3 = self.otpTextFieldThird.text ?? ""
        self.viewModel.strText4 = self.otpTextFieldFourth.text ?? ""
        viewModel.onAction(action: .inputComplete(.verification), for: .verification)
    }
}

// MARK:- TextField Delegate
extension VerificationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((textField.text?.count)! < 1) && (string.count > 0) {
            if textField == otpTextFieldFirst {
                otpTextFieldSecond.becomeFirstResponder()
            }
            if textField == otpTextFieldSecond {
                otpTextFieldThird.becomeFirstResponder()
            }
            if textField == otpTextFieldThird {
                otpTextFieldFourth.becomeFirstResponder()
            }
            if textField == otpTextFieldFourth {
                otpTextFieldFourth.resignFirstResponder()
            }
            textField.text = string
            return false
        }else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == otpTextFieldSecond{
                otpTextFieldFirst.becomeFirstResponder()
            }
            if textField == otpTextFieldThird{
                otpTextFieldSecond.becomeFirstResponder()
            }
            if textField == otpTextFieldFourth{
                otpTextFieldThird.becomeFirstResponder()
            }
            if textField == otpTextFieldFirst{
                otpTextFieldFirst.resignFirstResponder()
            }
            textField.text = ""
            
            return false
        }
        else if (textField.text?.count)! >= 1 {
            textField.text = string
            DispatchQueue.main.async {
                self.dismissKeyboard()
            }
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

