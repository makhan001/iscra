//
//  CommunitySearchCoordinator.swift
//  Iscra
//
//  Created by mac on 15/12/21.
//

import Foundation

final class CommunitySearchCoordinator: Coordinator<Scenes> {

    weak var delegate: CoordinatorDimisser?
    let controller: CommunitySearchViewController = CommunitySearchViewController.from(from: .landing, with: .community)

    private var landing: LandingCoordinator!
    private var editHabit: EditHabitCoordinator!
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
    }

    private func startHabitCalender() {
        router.present(controller, animated: true)
    }
       
    private func startLanding() {
        router.dismissModule(animated: false, completion: nil)
        landing = LandingCoordinator(router: Router())
        add(landing)
        landing.delegate = self
        landing.start()
        self.router.present(landing, animated: true)
    }
}

extension CommunitySearchCoordinator: NextSceneDismisser {

    func push(scene: Scenes) {
        switch scene {
        case .habitCalender: startHabitCalender()
        case .landing: startLanding()
        default: break
        }
    }

    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension CommunitySearchCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}
