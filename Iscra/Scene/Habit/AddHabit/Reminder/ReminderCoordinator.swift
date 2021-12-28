//
//  ReminderCoordinator.swift
//  Iscra
//
//  Created by mac on 15/12/21.
//

import Foundation

final class ReminderCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    let controller: ReminderViewController = ReminderViewController.from(from: .habit, with: .reminder)
    
    private var landing: LandingCoordinator!
    private var addGroupImage: AddGroupImageCoordinator!
    private var inviteFriend: InviteFriendCoordinator!
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    func start(selectedColorTheme: HabitThemeColor) {
        super.start()
        controller.selectedColorTheme = selectedColorTheme
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
        landing = LandingCoordinator(router: Router())
        add(landing)
        landing.delegate = self
        landing.start()
        self.router.present(landing, animated: true)
    }
    
    private func startAddGroupImage() {
        addGroupImage = AddGroupImageCoordinator(router: Router())
        add(addGroupImage)
        addGroupImage.delegate = self
        addGroupImage.start()
        self.router.present(addGroupImage, animated: true)
    }
    
    private func startInviteFriend() {
        inviteFriend = InviteFriendCoordinator(router: Router())
        add(inviteFriend)
        inviteFriend.delegate = self
        inviteFriend.start()
        self.router.present(inviteFriend, animated: true)
    }
}

extension ReminderCoordinator: NextSceneDismisser {
    
    func push(scene: Scenes) {
        switch scene {
        case .habitCalender: startHabitCalender()
        case .landing: startLanding()
        case.inviteFriend: startInviteFriend()
        case .addGroupImage: startAddGroupImage()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension ReminderCoordinator: CoordinatorDimisser {
    
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}
