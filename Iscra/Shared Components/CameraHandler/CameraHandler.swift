//
//  CameraHandler.swift
//  KitneMeChhodoge
//
//  Created by Mac on 29/01/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class CameraHandler: NSObject {
    static let shared = CameraHandler()
    
    fileprivate var currentVC: UIViewController!
    
    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var viewImagePickedBlock: ((String) -> Void)?

    
    func camera(allowsEditing: Bool)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = allowsEditing
            
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func frontCamera(vc: UIViewController, allowsEditing: Bool)
    {
        currentVC = vc
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            myPickerController.cameraDevice = .front
            myPickerController.allowsEditing = allowsEditing
            
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary(allowsEditing: Bool)
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = allowsEditing

            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(vc: UIViewController, isEditable: Bool) {
        currentVC = vc
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera(allowsEditing: isEditable)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary(allowsEditing: isEditable)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    func showActionSheetPrivate(vc: UIViewController, isEditable: Bool, isAlreadyExist: Bool) {
        currentVC = vc
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if isAlreadyExist {
            actionSheet.addAction(UIAlertAction(title: "View Photo", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.viewImagePickedBlock?("view")
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Remove Photo", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.viewImagePickedBlock?("remove")
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera(allowsEditing: isEditable)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary(allowsEditing: isEditable)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
}

extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imagePickedBlock?(image)
        } else {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let reSizeImg = self.resizeImage(image: image, targetSize: CGSize.init(width: 600, height: 600))
                self.imagePickedBlock?(reSizeImg)
            } else {
                print("Something went wrong")
            }
        }
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Add Observer
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.cropedImage),
        name: Commons.kNotificationSelectedImage,
        object: nil)
        
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            let cropperViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "cropperViewController") as! CropperViewController
            cropperViewController.image = pickedImage
            
            picker.pushViewController(cropperViewController, animated: true)
        } else {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let cropperViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "cropperViewController") as! CropperViewController
                cropperViewController.image = image
                
                picker.pushViewController(cropperViewController, animated: true)
            } else {
                print("Something went wrong")
            }
        }
    }
    
    @objc private func cropedImage(notification: NSNotification) {
        NotificationCenter.default.removeObserver(self, name: Commons.kNotificationSelectedImage, object: nil)
        self.imagePickedBlock?(notification.object as! UIImage)
    }*/
}
