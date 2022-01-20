//
//  SubscriptionViewController.swift
//  Iscra
//
//  Created by m@k on 04/01/22.
//

import UIKit

class SubscriptionViewController: UIViewController {
    
    @IBOutlet weak var lblMiddleText: UILabel!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    @IBOutlet weak var btnAllowAds: UIButton!
    @IBOutlet weak var btnSubscription: UIButton!
    
    @IBOutlet weak var imageFriends: UIImageView!
    @IBOutlet weak var viewNavigation:NavigationBarView!
    
    weak var router: NextSceneDismisser?
    let viewModel: SubscriptionViewModel = SubscriptionViewModel(provider: OnboardingServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: Instance Methods
extension SubscriptionViewController {
    private func setup() {
        self.viewModel.view = self
        self.setNavigationView()
        self.addNotificationObserver()
        self.lblHeaderTitle.text = "Dear \(UserStore.userName ?? ""), we need your support"
        self.lblMiddleText.text = AppConstant.subscriptionTitle
        [btnSubscription, btnAllowAds].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    private func setNavigationView() {
        self.viewNavigation.lblTitle.text =  ""
        self.viewNavigation.delegateBarAction = self
        self.viewNavigation.btnBack.isHidden = (viewModel.sourceScreen != .myAccount) ? true : false
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(paymentSuccess(_:)),
                                               name: .IAPHelperPurchaseFinishNotification,
                                               object: nil)
    }
    
    @objc func paymentSuccess (_ notification: Notification) {
        if notification.userInfo?["status"] as? String == "success" {
            print("Payment done")
            //            viewModel.transactionID = notification.userInfo?["transactionIdentifier"] as? String ?? ""
            //            viewModel.productIdentifier = notification.userInfo?["productIdentifier"] as? String ?? ""
            if UserStore.primeUser == false {
                UserStore.save(primeUser: true)
                NotificationCenter.default.post(name: .purchaseFinished, object: nil, userInfo:notification.userInfo)
                //                            viewModel.setSubscription()
            }
        } else {
            self.stopAnimation()
        }
    }
}

// MARK: Button Action
extension SubscriptionViewController  {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnSubscription:
            self.getSubscriptionAction()
        case btnAllowAds:
            self.allowAdsAction()
        default:
            break
        }
    }
    
    private func getSubscriptionAction() {
        print("getSubscriptionAction")
        self.viewModel.getProducts()
    }
    
    private func allowAdsAction() {
        print("allowAdsAction")
    }
    
    private func monthAction() {
        if let product = (viewModel.products.filter { $0.productIdentifier.contains("month")}).first {
            self.viewModel.buyProduct(product)
        }
    }
}

// MARK: Button Action
extension SubscriptionViewController: NavigationBarViewDelegate {
    func navigationBackAction()  {
        self.router?.dismiss(controller: .subscription)
    }
}

// MARK: API Call
extension SubscriptionViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case .subscription:
            break
        default:
            break
        }
    }
}
