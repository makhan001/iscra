//
//  AddGroupImageCoordinator.swift
//  Iscra
//
//  Created by mac on 15/12/21.
//

import Foundation

final class AddGroupImageCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    private var inviteFriend: InviteFriendCoordinator!
    let controller: AddGroupImageViewController = AddGroupImageViewController.from(from: .habit, with: .addGroupImage)

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
        
    private func startInviteFriend() {
        inviteFriend = InviteFriendCoordinator(router: Router())
        add(inviteFriend)
        inviteFriend.delegate = self
        inviteFriend.start()
        self.router.present(inviteFriend, animated: true)
    }
}

extension AddGroupImageCoordinator: NextSceneDismisser {
    
    func push(scene: Scenes) {
        switch scene {
        case .habitCalender: startHabitCalender()
        case.inviteFriend: startInviteFriend()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension AddGroupImageCoordinator: CoordinatorDimisser {
    
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}
