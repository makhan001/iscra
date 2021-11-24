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
    @IBOutlet weak var lblHeaderTitle:UILabel!
    @IBOutlet weak var btnAddMyPicture: UIButton!
    @IBOutlet weak var txtFieldName:UITextField!
    @IBOutlet weak var btnHowToAddMemoji: UIButton!
    @IBOutlet weak var scrollview_Walkthrough: UIScrollView!
    
    var currentIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        scrollview_Walkthrough.isPagingEnabled = true
        scrollview_Walkthrough.showsHorizontalScrollIndicator = false
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

}

// MARK:- Instance Methods
extension WalkthroughViewController {
    
    private func setup() {
        lblHeaderTitle.text = "How do your \nfriends call you?"
        self.scrollview_Walkthrough.delegate = self
        self.setButtonStatus()
        [btnBack, btnNext, btnAddMyPicture, btnHowToAddMemoji].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        txtFieldName.delegate = self
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
                self.currentIndex = Int(scrollview_Walkthrough.contentOffset.x/self.view.frame.size.width)
                scrollview_Walkthrough.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.size.width , y: 0), animated: true)
            }else{
                self.currentIndex = Int(scrollview_Walkthrough.contentOffset.x/self.view.frame.size.width) - 1
                scrollview_Walkthrough.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.size.width  , y: 0), animated: true)
            }
        }
    }
    
    private func nextButtonAction() {
        if self.currentIndex <= 2 {
            if currentIndex == 2 {
                if txtFieldName.text == "" {
                    showToast(message: "Please enter your name", seconds: 2.0)
                }
                else{
                    self.currentIndex = Int(scrollview_Walkthrough.contentOffset.x/self.view.frame.size.width) + 1
                    scrollview_Walkthrough.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.size.width, y: 0), animated: true)
                }
            }
            else{
                self.currentIndex = Int(scrollview_Walkthrough.contentOffset.x/self.view.frame.size.width) + 1
                scrollview_Walkthrough.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.size.width, y: 0), animated: true)
            }
        }
        if self.currentIndex == 3 {
            let VC = storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
            navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    private func addMyPictureAction() {
        let VC = storyboard?.instantiateViewController(withIdentifier: "AddMyPictureViewController") as! AddMyPictureViewController
        navigationController?.pushViewController(VC, animated: true)
    }
    
    private func howToAddMemojiAction() {
        let VC = storyboard?.instantiateViewController(withIdentifier: "LearnHowToAddMemojiViewController") as! LearnHowToAddMemojiViewController
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func setButtonStatus(){
        if self.currentIndex == 3 {
            btnNext.setTitle("Skip", for: .normal)
        }else if self.currentIndex == 1 {
            btnBack.setTitleColor(#colorLiteral(red: 0.1098039216, green: 0.09019607843, blue: 0.02745098039, alpha: 0.1495653609), for: .normal)
            btnBack.isUserInteractionEnabled = false
        }else{
            btnNext.setTitle("Next", for: .normal)
            btnBack.isUserInteractionEnabled = true
            btnBack.setTitleColor(#colorLiteral(red: 0.1098039216, green: 0.09019607843, blue: 0.02745098039, alpha: 1), for: .normal)
        }
    }
    
}

// MARK:- UIScrollViewDelegate
extension WalkthroughViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentIndex == 2 {
            if txtFieldName.text == "" {
                showToast(message: "Please enter your name", seconds: 2.0)
            }
            else{
                self.currentIndex = Int(scrollview_Walkthrough.contentOffset.x/self.view.frame.size.width) + 1
                self.setButtonStatus()
            }
        }
        else{
            self.currentIndex = Int(scrollview_Walkthrough.contentOffset.x/self.view.frame.size.width) + 1
            self.setButtonStatus()
        }
    }
    
}


// MARK:- UITextFieldDelegate
extension WalkthroughViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
                       if newLength <= 30 {
                           return true
                       } else {
                           return false
                       }
           }

}
