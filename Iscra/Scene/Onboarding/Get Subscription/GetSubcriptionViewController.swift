//
//  GetSubcriptionViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 02/11/21.
//

import UIKit

class GetSubcriptionViewController: UIViewController {

    @IBOutlet weak var friends_image: UIImageView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblMiddleText: UILabel!
    @IBOutlet weak var btnGetSubcription: UIButton!
    @IBOutlet weak var btnAllowAds: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
      setup()
        // Do any additional setup after loading the view.
    }
    
}
// MARK:- Instance Methods
extension GetSubcriptionViewController {
    
    private func setup() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        friends_image.image = UIImage(named: "ic-getSubscription")
        lblHeaderTitle.text = "Dear Adil, we need your support"
        lblMiddleText.text = AppConstant.subscriptionTitle
        [btnGetSubcription, btnAllowAds].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
}

// MARK:- Button Action
extension GetSubcriptionViewController  {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnGetSubcription:
            self.GetSubscriptionAction()
        case btnAllowAds:
            self.AllowAdsAction()
        default:
            break
        }
    }
    private func GetSubscriptionAction() {
       print("GetSubscriptionAction")
    }
    private func AllowAdsAction() {
       print("AllowAdsAction")
    }
}
