//
//  CommunityDetailCoordinator.swift
//  Iscra
//
//  Created by mac on 29/12/21.
//

import Foundation

final class CommunityDetailCoordinator: Coordinator<Scenes> {

    weak var delegate: CoordinatorDimisser?
    let controller: CommunityDetailViewController = CommunityDetailViewController.from(from: .landing, with: .communityDetail)
    let groupMembers: GroupMembersViewController = GroupMembersViewController.from(from: .landing, with: .groupMembers)
    private var landing: LandingCoordinator!

    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    func start(objInvitation: Invitaion) {
        super.start()
        router.setRootModule(controller, hideBar: true)
        controller.objInvitaion = objInvitation
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
        groupMembers.router = self
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
     
        private func startGroupMembers() {
            groupMembers.viewModel.habitId = controller.viewModel.habitId
            router.present(groupMembers, animated: true)
        }
}

extension CommunityDetailCoordinator: NextSceneDismisser {

    func push(scene: Scenes) {
        switch scene {
        case .landing: startLanding()
        case .habitCalender: startHabitCalender()
        case .groupMembers: startGroupMembers()
        default: break
        }
    }

    func dismiss(controller: Scenes) {
        router.dismissModule(animated: false, completion: nil)
    }
}

extension CommunityDetailCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

