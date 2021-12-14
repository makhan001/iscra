//
//  LearnHowToAddMemojiViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 20/10/21.
//


import UIKit
class AddMemojiViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    // MARK:-Outlets and variables
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblFirstSubTitle: UILabel!
    @IBOutlet weak var lblSecondSubTitle: UILabel!
    @IBOutlet weak var lblThirdSubTitle: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
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
//    override func viewDidAppear(_ animated: Bool) {
//        let alertController = UIAlertController (title: "Title", message: "Go to Settings?", preferredStyle: .alert)
//
//        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
//
//            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                return
//            }
//
//            if UIApplication.shared.canOpenURL(settingsUrl) {
//                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                    print("Settings opened: \(success)") // Prints true
//                })
//            }
//        }
//        alertController.addAction(settingsAction)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//        alertController.addAction(cancelAction)
//
//        present(alertController, animated: true, completion: nil)
//    }
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
        router?.dismiss(controller: .learnHowToAddMemoji)
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
        openGallary()
        print("addPhotoButtonAction")
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

               if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                       self.imgUser.contentMode = .scaleAspectFill
                       self.imgUser.image = pickedImage
                   }

               dismiss(animated: true, completion: nil)
           }
}
