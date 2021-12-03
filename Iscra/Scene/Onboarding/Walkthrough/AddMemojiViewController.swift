//
//  LearnHowToAddMemojiViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 20/10/21.
//


import UIKit
class AddMemojiViewController: UIViewController {
  
    // MARK:-Outlets and variables
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblFirstSubTitle: UILabel!
    @IBOutlet weak var lblSecondSubTitle: UILabel!
    @IBOutlet weak var lblThirdSubTitle: UILabel!
    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewNavigation:NavigationBarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        self.viewNavigation.lblTitle.text =  "Memoji"
        self.viewNavigation.delegateBarAction = self
    }
}

// MARK: Instance Methods
extension AddMemojiViewController: navigationBarAction {
    private func setup() {
        self.navigationItem.title = AppConstant.nav_memoji
        lblHeaderTitle.text = AppConstant.nav_memoji
        //lblFirstSubTitle.text = AppConstant.Sub1Title
        lblSecondSubTitle.text = AppConstant.Sub2Title
        lblThirdSubTitle.text = AppConstant.Sub3Title
        [btnAddPhoto, btnCancel].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        let fullString = NSMutableAttributedString(string: AppConstant.Sub1Title)
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "ic-addNote-image")
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        lblFirstSubTitle.attributedText = fullString
    }
    func ActionType()  {
      //  router?.dismiss(controller: .addMyPicture)
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK:- Button Action
extension AddMemojiViewController {
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnAddPhoto:
            self.addPhotoButtonAction()
        case btnCancel:
            self.cancelButtonAction()
        default:
            break
        }
    }
    private func addPhotoButtonAction() {
        print("addPhotoButtonAction")
    }
    private func cancelButtonAction() {
        print("cancelButtonAction")
    }
}
