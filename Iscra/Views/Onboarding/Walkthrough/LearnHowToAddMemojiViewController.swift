//
//  LearnHowToAddMemojiViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 20/10/21.
//


import UIKit
class LearnHowToAddMemojiViewController: UIViewController {
  
    // MARK:-Outlets and variables
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblFirstSubTitle: UILabel!
    @IBOutlet weak var lblSecondSubTitle: UILabel!
    @IBOutlet weak var lblThirdSubTitle: UILabel!
    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
   }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
}

// MARK: Instance Methods
extension LearnHowToAddMemojiViewController {
    private func setup() {
        self.navigationItem.title = "Memoji"
        lblHeaderTitle.text = "How to add your own memoji?"
        lblFirstSubTitle.text = "Open Notes on your iPhone. Click a new note."
        lblSecondSubTitle.text = "Tap the Memoji button then swipe right and tap the New Memoji add new memoji button."
        lblThirdSubTitle.text = "Share your memodji to your notes then click the memodji and save it to your gallery."
        btnAddPhoto.titleLabel?.font =  UIFont(name: "SF-Pro-Display-Black", size: 50)
        [btnAddPhoto, btnCancel].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
}
// MARK:- Button Action
extension LearnHowToAddMemojiViewController {
    
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
