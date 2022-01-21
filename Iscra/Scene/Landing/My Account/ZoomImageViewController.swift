//
//  ZoomImageViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 07/01/22.
//

import UIKit
import SDWebImage
class ZoomImageViewController: UIViewController , UIScrollViewDelegate, NavigationBarViewDelegate {

    @IBOutlet weak var viewZoomImage: UIView!
    @IBOutlet weak var imgZoom: UIImageView!
    @IBOutlet weak var scrollViewImg: UIScrollView!
    @IBOutlet weak var viewNavigation: NavigationBarView!
    
    var strUrl = ""
    var objImage : UIImage!
    var delegateBarAction:NavigationBarViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.vwBack.setCornerRadius(radius: 20)
      //  self.vwBack.layer.cornerRadius = self.vwBack.frame.height/2
        self.scrollViewImg.minimumZoomScale = 1.0
        self.scrollViewImg.maximumZoomScale = 5.0
        self.scrollViewImg.delegate = self
        self.scrollViewImg.zoomScale = 1.0
        self.viewNavigation.lblTitle.text =  " "
        self.viewNavigation.delegateBarAction = self
        if let url = URL(string: (strUrl)){
            self.imgZoom.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder_group"))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.scrollViewImg.zoomScale = 1.0
        self.viewZoomImage.isHidden = true
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnBackZoomImg(_ sender: UIButton) {
        self.scrollViewImg.zoomScale = 1.0
        self.viewZoomImage.isHidden = true
        self.dismiss(animated: false, completion: nil)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgZoom
    }
    func navigationBackAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
