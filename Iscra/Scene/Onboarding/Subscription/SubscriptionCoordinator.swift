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
    }
    
    //    private func startSignup() {
    //        router.dismissModule(animated: false, completion: nil)
    //        signup = SignupCoordinator(router: Router())
    //        add(signup)
    //        signup.delegate = self
    //        signup.start()
    //        self.router.present(signup, animated: true)
    //    }
}

extension SubscriptionCoordinator: NextSceneDismisser {
    func push(scene: Scenes) {
        switch scene {
        case .walkthrough: break
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

