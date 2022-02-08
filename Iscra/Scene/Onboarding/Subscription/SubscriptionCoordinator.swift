//
//  SubscriptionCoordinator.swift
//  Iscra
//
//  Created by m@k on 04/01/22.
//

import Foundation

final class SubscriptionCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    let controller: SubscriptionViewController = SubscriptionViewController.from(from: .onboarding, with: .subscription)
    let webViewController: WebViewController = WebViewController.from(from: .landing, with: .webViewController)
    
    var landing: LandingCoordinator!
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    func start(sourceScreen: SubscriptionSourceScreen) {
        super.start()
        controller.viewModel.sourceScreen = sourceScreen
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
        webViewController.router = self
    }
    
    private func startWebViewController() {
        webViewController.webPage = .termsAndConditions
        router.present(webViewController, animated: true)
    }
    
    private func startLanding() {
        landing = LandingCoordinator(router: Router())
        add(landing)
        landing.delegate = self
        landing.start()
        self.router.present(landing, animated: true)
    }
}

extension SubscriptionCoordinator: NextSceneDismisser {
    func push(scene: Scenes) {
        switch scene {
        case .landing: startLanding()
        case .webViewController: startWebViewController()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension SubscriptionCoordinator: CoordinatorDimisser {
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

