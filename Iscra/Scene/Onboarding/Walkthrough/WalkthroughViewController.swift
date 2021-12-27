//
//  WalkthroughViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 15/10/21.
//

import UIKit

class WalkthroughViewController: UIViewController {
    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnAddMyPicture: UIButton!
    @IBOutlet weak var btnHowToAddMemoji: UIButton!
    
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var lblHeaderTitle:UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textNameView: IscraCustomView! // viewName
    
    var currentIndex: Int = 1
    weak var router: NextSceneDismisser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK:- Instance Methods
extension WalkthroughViewController {
    private func setup() {
        self.lblHeaderTitle.text = AppConstant.onbordingName //"How do your \nfriends call you?"
        self.scrollView.delegate = self
        self.setButtonStatus()
        [btnBack, btnNext, btnAddMyPicture, btnHowToAddMemoji].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        txtName.delegate = self
        self.setScrollView()
    }
    
    private func setScrollView() {
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        if #available(iOS 11, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    private func setNameTextField(newLength: Int, string:String, range: NSRange) {
        if newLength != 0 {
            self.textNameView.layer.borderColor = UIColor(red: 0.758, green: 0.639, blue: 0.158, alpha: 1).cgColor
            self.textNameView.layer.borderWidth = 1
        } else {
            self.textNameView.layer.borderColor = UIColor.clear.cgColor
            self.textNameView.layer.borderWidth = 1
        }
        if let text = txtName.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            OnboadingUtils.shared.username = updatedText
        }
    }
}

// MARK:- Button Action
extension WalkthroughViewController  {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnBack:
            self.backButtonAction()
        case btnNext:
            self.nextButtonAction()
        case btnAddMyPicture:
            self.addMyPictureAction()
        case btnHowToAddMemoji:
            self.howToAddMemojiAction()
        default:
            break
        }
    }
    
    private func backButtonAction() {
        if self.currentIndex >= 1 {
            if self.currentIndex == 1 {
                self.router?.dismiss(controller: .walkthrough)
            } else {
                self.currentIndex = Int(scrollView.contentOffset.x/self.view.frame.size.width) - 1
                scrollView.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.size.width  , y: 0), animated: true)
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func nextButtonAction() {
        if self.currentIndex <= 2 {
            if self.currentIndex == 2 {
                if OnboadingUtils.shared.username == "" {
                    showToast(message: AppConstant.alert_emptynameMsg)
                } else {
                    self.currentIndex = Int(scrollView.contentOffset.x/self.view.frame.size.width) + 1
                    scrollView.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.size.width, y: 0), animated: true)
                }
            } else {
                self.currentIndex = Int(scrollView.contentOffset.x/self.view.frame.size.width) + 1
                scrollView.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.size.width, y: 0), animated: true)
            }
        }
        
        if self.currentIndex == 3 {
            self.router?.push(scene: .signup)
        }
    }
    
    private func addMyPictureAction() {
        self.router?.push(scene: .addMyPicture)
    }
    
    private func howToAddMemojiAction() {
        self.router?.push(scene: .learnHowToAddMemoji)
    }
    
    private func setButtonStatus() {
        if self.currentIndex == 3 {
            self.btnNext.setTitle("Skip", for: .normal)
        } else if   self.currentIndex == 2 {
            self.btnNext.setTitle("Next", for: .normal)
        } else if self.currentIndex == 1 {
            self.btnNext.setTitle("Next", for: .normal)
        }
    }
}

// MARK:- ScrollView Delegate
extension WalkthroughViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentIndex == 2 {
            if txtName.text == "" {
                showToast(message: AppConstant.alert_emptynameMsg)
            } else {
                self.currentIndex = Int(scrollView.contentOffset.x/self.view.frame.size.width) + 1
                self.setButtonStatus()
            }
        } else {
            self.currentIndex = Int(scrollView.contentOffset.x/self.view.frame.size.width) + 1
            self.setButtonStatus()
        }
    }
}

// MARK:- TextField Delegate
extension WalkthroughViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
        if newLength <= 30 {
            if string.rangeOfCharacter(from: .decimalDigits) != nil || string.rangeOfCharacter(from: .whitespacesAndNewlines) != nil {
                return false
            }
            let characterSet = NSCharacterSet(charactersIn: AppConstant.USERNAME_ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: characterSet).joined(separator: "")
            self.setNameTextField(newLength: newLength, string: string, range:range)
            return (string == filtered)
        } else {
            return false
        }
    }
}
