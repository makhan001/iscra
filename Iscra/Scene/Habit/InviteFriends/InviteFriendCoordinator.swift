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
    let shareHabit: ShareHabitViewController = ShareHabitViewController.from(from: .landing, with: .shareHabit)

    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    func start(habitId: Int ) {
        super.start()
        router.setRootModule(controller, hideBar: true)
        controller.habitId = habitId
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
        shareHabit.router = self
    }
    
    private func startLanding() {
        landing = LandingCoordinator(router: Router())
        add(landing)
        landing.delegate = self
        landing.start()
        self.router.present(landing, animated: true)
    }
    
    private func startShareHabit() {
        shareHabit.viewModel.habitId = controller.habitId // deepak
        shareHabit.viewModel.sourceScreen = .invite
        router.present(shareHabit, animated: true)
    }
}

extension InviteFriendCoordinator: NextSceneDismisser {

    func push(scene: Scenes) {
        switch scene {
        case .landing: startLanding()
        case .shareHabit: startShareHabit()
        default: break
        }
    }

//    func dismiss(controller: Scenes) {
//        router.dismissModule(animated: true, completion: nil)
//    }
    
    func dismiss(controller: Scenes) {
        switch  controller {
        case .shareHabit:
            router.dismissModule(animated: false) {
                self.startLanding()
            }
        default:
            delegate?.dismiss(coordinator: self)
        }
    }
}

extension InviteFriendCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}
