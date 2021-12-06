//
//  HabitCalenderCoordinator.swift
//  Iscra
//
//  Created by mac on 27/11/21.
//

import Foundation

final class HabitCalenderCoordinator: Coordinator<Scenes> {

    weak var delegate: CoordinatorDimisser?
    let controller: HabitCalenderViewController = HabitCalenderViewController.from(from: .landing, with: .habitCalender)
//    let habitCalender: HomeViewController = HomeViewController.from(from: .landing, with: .home)

  //  private var landing: LandingCoordinator!

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
}

extension HabitCalenderCoordinator: NextSceneDismisser {

    func push(scene: Scenes) {
        switch scene {
        case .habitCalender: startHabitCalender()
        default: break
        }
    }

    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension HabitCalenderCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

