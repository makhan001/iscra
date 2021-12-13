//
//  HabitNameCoordinator.swift
//  Iscra
//
//  Created by m@k on 19/11/21.
//


import Foundation

final class HabitNameCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    let controller: HabitNameViewController = HabitNameViewController.from(from: .habit, with: .habitName)
    
    let selectHabitPopUp: SelectHabitPopUpViewController = SelectHabitPopUpViewController.from(from: .landing, with: .selectHabitPopUp)
    let setTheme: SetThemeViewController = SetThemeViewController.from(from: .habit, with: .setTheme)
    let reminder: ReminderViewController = ReminderViewController.from(from: .habit, with: .reminder)
    let inviteFriend: InviteFriendViewController = InviteFriendViewController.from(from: .habit, with: .inviteFriend)
    let addGroupImage: AddGroupImageViewController = AddGroupImageViewController.from(from: .habit, with: .addGroupImage)
    
    private var myAccount: MyAccountCoordinator!
    private var landing: LandingCoordinator!
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    func start(type: HabitType) {
        super.start()
        controller.viewModel.habitType = type
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
        selectHabitPopUp.router = self
        setTheme.router = self
        reminder.router = self
        inviteFriend.router = self
        addGroupImage.router = self
    }
    
    private func startLanding() {
        router.dismissModule(animated: false, completion: nil)
        landing = LandingCoordinator(router: Router())
        add(landing)
        landing.delegate = self
        landing.start()
        self.router.present(landing, animated: false)
    }
        
    private func startSetTheme() {
        self.router.present(setTheme, animated: true)
    }
    
    private func startReminder() {
        router.dismissModule(animated: false, completion: nil)
        self.router.present(reminder, animated: true)
    }
    
    private func startAddGroupImage() {
        router.dismissModule(animated: false, completion: nil)
        self.router.present(addGroupImage, animated: true)
    }
    
    private func startInviteFriend() {
        router.dismissModule(animated: false, completion: nil)
        self.router.present(inviteFriend, animated: true)
    }
}

extension HabitNameCoordinator: NextSceneDismisser {
    func push(scene: Scenes) {
        switch scene {
        case .landing: startLanding()
//        case .setTheme: startSetTheme()
//        case.reminder: startReminder()
//        case.addGroupImage: startAddGroupImage()
//        case.inviteFriend: startInviteFriend()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {
        delegate?.dismiss(coordinator: self)
    }
}

extension HabitNameCoordinator: CoordinatorDimisser {
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

