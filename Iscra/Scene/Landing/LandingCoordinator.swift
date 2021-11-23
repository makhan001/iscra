//
//  LandingCoordinator.swift
//  Iscra
//
//  Created by m@k on 19/11/21.
//

import Foundation

final class LandingCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    let controller: LandingTabBarViewController = WelcomeViewController.from(from: .landing, with: .landingTab)
    
    private var login: LoginCoordinator!
    
        
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: false)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
    }
    
    private func startLogin() {
        let router = Router()
        login = LoginCoordinator(router: router)
        add(login)
        login.delegate = self
        login.start()
        self.router.present(login, animated: true)
    }
    
    private func startWalkthrough() {
//        let router = Router()
//        walkthrough = WalkthroughCoordinator(router: router)
//        add(walkthrough)
//        walkthrough.delegate = self
//        walkthrough.start()
//        self.router.present(walkthrough, animated: true)
    }
    
    private func startLanding() {
//        landing = LandingCoordinator(router: Router())
//        add(landing)
//        landing.delegate = self
//        landing.start(imageUrl: controller.viewModel.socialLoginImageURL)
//        self.router.present(landing, animated: true)
    }
}

extension LandingCoordinator: NextSceneDismisser {
    
    func push(scene: Scenes) {
        switch scene {
        case .login: startLogin()
        case .landing: startLanding()
        case .walkthrough: startWalkthrough()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {}
}

extension LandingCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}
