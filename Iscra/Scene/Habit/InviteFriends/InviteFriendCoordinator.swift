//
//  InviteFriendCoordinator.swift
//  Iscra
//
//  Created by mac on 15/12/21.
//

import Foundation

final class InviteFriendCoordinator: Coordinator<Scenes> {

    weak var delegate: CoordinatorDimisser?
    private var landing: LandingCoordinator!
    let controller: InviteFriendViewController = InviteFriendViewController.from(from: .habit, with: .inviteFriend)
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
    }
    
    private func startLanding() {
        landing = LandingCoordinator(router: Router())
        add(landing)
        landing.delegate = self
        landing.start()
        self.router.present(landing, animated: true)
    }
}

extension InviteFriendCoordinator: NextSceneDismisser {

    func push(scene: Scenes) {
        switch scene {
        case .landing: startLanding()
        default: break
        }
    }

    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension InviteFriendCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}
