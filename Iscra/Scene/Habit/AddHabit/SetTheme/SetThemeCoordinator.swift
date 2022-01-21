//
//  SetThemeCoordinator.swift
//  Iscra
//
//  Created by mac on 15/12/21.
//

import Foundation

final class SetThemeCoordinator: Coordinator<Scenes> {
    
    let controller: SetThemeViewController = SetThemeViewController.from(from: .habit, with: .setTheme)
    let iconPopup: IconPopupViewController = IconPopupViewController.from(from: .habit, with: .iconPopup)
    weak var delegate: CoordinatorDimisser?
    
    private var landing: LandingCoordinator!
    private var reminder: ReminderCoordinator!
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
    }

    private func startReminder() {
        reminder = ReminderCoordinator(router: Router())
        add(reminder)
        reminder.delegate = self
        reminder.start(selectedColorTheme: controller.selectedColorTheme)
        self.router.present(reminder, animated: true)
    }
    
    private func startLanding() {
        landing = LandingCoordinator(router: Router())
        add(landing)
        landing.delegate = self
        landing.start()
        self.router.present(landing, animated: true)
    }
    
    private func startIconPopup() {
        iconPopup.viewModel.themeColor = controller.selectedColorTheme
//        iconPopup.didSelectIconAtIndex = controller.didSelectIconAtIndex(<#T##iconName: Int##Int#>)
        iconPopup.selectedIconName = controller.selectedIconName
        iconPopup.modalPresentationStyle = .overCurrentContext
        router.present(iconPopup, animated: true)
    }
}

extension SetThemeCoordinator: NextSceneDismisser {

    func push(scene: Scenes) {
        switch scene {
        case .landing: startLanding()
        case .reminder: startReminder()
        case .iconPopup: startIconPopup()
        default: break
        }
    }

    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension SetThemeCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}
