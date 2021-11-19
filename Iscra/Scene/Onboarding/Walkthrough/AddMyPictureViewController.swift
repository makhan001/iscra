//
//  AddMyPictureViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 20/10/21.
//

import UIKit

class AddMyPictureViewController: UIViewController {
  // MARK:-Outlets and variables
  @IBOutlet weak var btnAddPhoto: UIButton!
  @IBOutlet weak var btnCancel: UIButton!
  @IBOutlet weak var imgUser: UIImageView!
    
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
extension AddMyPictureViewController {
  private func setup() {
   
    self.navigationItem.title = AppConstant.nav_addProfilePicture//"Add Profile Picture"
    [btnAddPhoto, btnCancel].forEach {
      $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
  }
}
// MARK:- Button Action
extension AddMyPictureViewController {
  @objc func buttonPressed(_ sender: UIButton) {
    switch sender {
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
    openCameraPhoto()
  }
  private func cancelButtonAction() {
    print("cancelButtonAction")
  }
    
    func openCameraPhoto() {
            CameraHandler.shared.showActionSheetPrivate(vc: self, isEditable: false, isAlreadyExist: false)
            //        CameraHandler.shared.camera(allowsEditing: false)
            CameraHandler.shared.imagePickedBlock = { (image) in
                /* get your image here */
              //  self.privatePhoto = image
                self.imgUser.image = image
//                let timestamp = NSDate().timeIntervalSince1970
//                let intTimeStemp = Int(timestamp)
//                let strImgName = “img_\(intTimeStemp).png”
//                self.lblImgName.text = strImgName
//                self.btnUploadPic.setTitle(“”, for: .normal)
            }
        }
}
