//
//  WebViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 13/12/21.
//

import UIKit
import WebKit

enum WebPage {
    case termsAndConditions
    case privacyPolicy
    case aboutUs
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
        self.setUp()
    }
}

extension WebViewController {
    private func setUp(){
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
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        viewWeb.load(myRequest)
    }
}

// NavigationBar delegates
extension WebViewController : navigationBarAction {
    func ActionType()  {
        self.router?.dismiss(controller: .webViewController)
    }
}
