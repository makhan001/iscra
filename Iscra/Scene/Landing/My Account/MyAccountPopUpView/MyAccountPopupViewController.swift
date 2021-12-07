//
//  MyAccountPopupViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 29/11/21.
//

import UIKit
protocol ImagePickerDelegate:class {
    func fetchedImage(img:UIImage)
}

class MyAccountPopupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    
    var delegate:ImagePickerDelegate? = nil
    private var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        Setup()
    }
}

extension MyAccountPopupViewController {
    private func Setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTaps(_:)))
        viewBackground.addGestureRecognizer(tap)
        [btnCamera,btnGallery].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    @objc func handleTaps(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK:- Button Action
extension MyAccountPopupViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnCamera:
            self.CameraAction()
        case btnGallery:
            self.GalleryAction()
        default:
            break
        }
    }
    private func CameraAction() {
        self.openCamera()
    }
    
    private func GalleryAction() {
        self.openGallary()
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerController.SourceType.camera
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
     
    }
    
    func openGallary()
    {
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        
        self.present(myPickerControllerGallery, animated: true, completion: nil)
    }
    //MARK: - ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        delegate?.fetchedImage(img: selectedImage)
        dismiss(animated: true, completion: nil)
        
    }
}
