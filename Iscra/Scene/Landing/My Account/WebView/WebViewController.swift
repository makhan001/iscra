//
//  WebViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 13/12/21.
//

import UIKit
import WebKit

enum WebPage {
    case aboutUs
    case privacyPolicy
    case termsAndConditions
}

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var viewWeb:WKWebView!
    @IBOutlet weak var viewNavigation:NavigationBarView!
    
    var webPage: WebPage = .termsAndConditions
    weak var router: NextSceneDismisser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }
}

extension WebViewController {
    private func setup() {
        self.viewWeb.scrollView.delegate = self
        self.viewNavigation.delegateBarAction = self
        switch webPage {
        case .termsAndConditions:
            self.viewNavigation.lblTitle.text = AppConstant.termsAndConditionTitle
            self.loadUrl(urlString: AppConstant.termsAndConditionURL)
        case .privacyPolicy:
            self.viewNavigation.lblTitle.text = AppConstant.privacyPolicyTitle
            self.loadUrl(urlString: AppConstant.privacyPolicyURL)
        case .aboutUs:
            self.viewNavigation.lblTitle.text = AppConstant.aboutUsTitle
            self.loadUrl(urlString: AppConstant.aboutUsURL)
        }
    }
    
    private func loadUrl(urlString: String){
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        self.viewWeb.load(urlRequest)
    }
}

// MARK:  NavigationBar Delegate
extension WebViewController: NavigationBarViewDelegate {
    func navigationBackAction()  {
        self.router?.dismiss(controller: .webViewController)
    }
}

extension WebViewController: UIScrollViewDelegate {
   func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
      scrollView.pinchGestureRecognizer?.isEnabled = false
   }
}
