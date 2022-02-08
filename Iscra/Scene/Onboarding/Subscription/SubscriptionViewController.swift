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
    @IBOutlet weak var lblIAPContent: UILabel!

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: Instance Methods
extension SubscriptionViewController {
    private func setup() {
        self.startAnimation()
        self.setViewControls()
        self.setNavigationView()
        self.viewModel.view = self
        self.viewModel.getProducts()
        self.addNotificationObserver()
    }
    
    private func setViewControls() {
        self.lblHeaderTitle.text = "Dear \(UserStore.userName ?? ""), we need your support"
        self.lblMiddleText.text = AppConstant.subscriptionTitle
        self.btnAllowAds.isHidden = true
        [btnSubscription, btnAllowAds].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        self.lblIAPContent.text = AppConstant.IAPContent
    }
    
    private func setNavigationView() {
        self.viewNavigation.navType = .subscription
        self.viewNavigation.commonInit()
        self.viewNavigation.lblTitle.text =  "Iscra Subscription"
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
            UserStore.save(primeUser: true)
            NotificationCenter.default.post(name: .SubscriptionActiveNotification,
                                            object: nil,
                                            userInfo:["isSubscribed": true])
            self.viewModel.subscription(type: "month", amount: "100", identifier: notification.userInfo?["transactionIdentifier"] as? String ?? "")
        } else {
            UserStore.save(primeUser: false)
            self.stopAnimation()
        }
    }
}

// MARK: Button Action
extension SubscriptionViewController  {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnSubscription:
            self.subscriptionAction()
        case btnAllowAds:
            self.allowAdsAction()
        default:
            break
        }
    }
    
    private func subscriptionAction() {
        if let product = (viewModel.products.filter { $0.productIdentifier.contains("month")}).first {
            self.startAnimation()
            self.viewModel.buyProduct(product)
        }
    }
    
    private func allowAdsAction() {
        print("allowAdsAction")
    }
    
    private func dismiss() {
        if self.viewModel.sourceScreen == .myAccount {
            self.router?.dismiss(controller: .subscription)
        } else {
            self.router?.push(scene: .landing)
        }
    }
}

// MARK: Button Action
extension SubscriptionViewController: NavigationBarViewDelegate {
    func navigationBackAction()  {
        self.router?.dismiss(controller: .subscription)
    }
    
    func navigationRightButtonAction() {
        self.router?.push(scene: .webViewController)
    }
}

// MARK: API Call
extension SubscriptionViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case .subscription:
            self.dismiss()
        default:
            self.stopAnimation()
        }
    }
}
