//
//  LearnHowToAddMemojiViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 20/10/21.
//


import UIKit
class AddMemojiViewController: UIViewController {
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblThirdSubTitle: UILabel!
    @IBOutlet weak var lblFirstSubTitle: UILabel!
    @IBOutlet weak var lblSecondSubTitle: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var viewNavigation:NavigationBarView!
    
    weak var router: NextSceneDismisser?
    private var imagePicker = UIImagePickerController()
    
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
extension AddMemojiViewController: NavigationBarViewDelegate {
    private func setup() {
        self.setHeaderLabel()
        [btnAddPhoto, btnCancel].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        self.addNoteIconToText()
        self.addTapGestureForNotes()
    }
    
    private func setHeaderLabel() {
        self.navigationItem.title = AppConstant.nav_memoji
        lblHeaderTitle.text = AppConstant.nav_memoji
        lblSecondSubTitle.text = AppConstant.Sub2Title
        lblThirdSubTitle.text = AppConstant.Sub3Title
    }
    
    private func addNoteIconToText() {
        let fullString = NSMutableAttributedString(string: AppConstant.Sub1Title)
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "ic-addNote-image")
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        self.lblFirstSubTitle.attributedText = fullString
    }
    
    private func addTapGestureForNotes() {
        let labelTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.openNotes))
        lblFirstSubTitle.isUserInteractionEnabled = true
        lblFirstSubTitle.addGestureRecognizer(labelTapGesture)
    }
    
    @objc func openNotes() {
        //UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString) as! URL)
//        UIApplication.shared.open(URL(string: "App-prefs:NOTES")!)
        print("tapped")
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
        self.openGallary()
    }
    
    private func cancelButtonAction() {
        print("cancelButtonAction")
    }
    
    func openGallary() {
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)
    }
}

// MARK:- Image Picker Delegate
extension AddMemojiViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgUser.contentMode = .scaleAspectFill
            self.imgUser.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- Navigation Bar Delegate
extension AddMemojiViewController {
    func navigationBackAction()  {
        router?.dismiss(controller: .learnHowToAddMemoji)
    }
}
