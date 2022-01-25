//
//  LandingCoordinator.swift
//  Iscra
//
//  Created by m@k on 19/11/21.
//


import Foundation

final class LandingCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    let controller: LandingTabBarController = LandingTabBarController.from(from: .landing, with: .landing)
    let selectHabitPopUp: SelectHabitPopUpViewController = SelectHabitPopUpViewController.from(from: .landing, with: .selectHabitPopUp)
    let webViewController: WebViewController = WebViewController.from(from: .landing, with: .webViewController)
    let myAccountViewController: MyAccountViewController = MyAccountViewController.from(from: .landing, with: .myAccount)
    let changePassword: ChangePasswordViewController = ChangePasswordViewController.from(from: .onboarding, with: .changePassword)
    let updateProfile: UpdateProfileViewController = UpdateProfileViewController.from(from: .onboarding, with: .updateProfile)
    let myAccountPopup: MyAccountPopupViewController = MyAccountPopupViewController.from(from: .landing, with: .myAccountPopup)
    
    private var login: LoginCoordinator!
    private var welcome: OnboardingCoordinator!
    private var habitName: HabitNameCoordinator!
    private var myAccount: MyAccountCoordinator!
    private var subscription: SubscriptionCoordinator!
    private var habitCalender: HabitCalenderCoordinator!
    private var addMemojiCoordinator: AddMemojiCoordinator!
    private var communityDetail: CommunityDetailCoordinator!
    private var communitySearch: CommunitySearchCoordinator!
    private var groupHabitCalender: GroupHabitCalenderCoordinator!
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
        selectHabitPopUp.router = self
        selectHabitPopUp.delegate = self
        webViewController.router = self
        myAccountViewController.router = self
        changePassword.router = self
        updateProfile.router = self
        myAccountPopup.router = self
    }
    
    private func startLogin() {
        let router = Router()
        login = LoginCoordinator(router: router)
        add(login)
        login.delegate = self
        login.start()
        self.router.present(login, animated: true)
    }
    
    private func startWelcome() {
        let router = Router()
        welcome = OnboardingCoordinator(router: router)
        add(welcome)
        welcome.delegate = self
        welcome.start()
        self.router.present(welcome, animated: true)
    }
    
    private func startMyAccount() {
        myAccount = MyAccountCoordinator(router: Router())
        add(myAccount)
        myAccount.delegate = self
        myAccount.start()
        self.router.present(myAccount, animated: true)
    }
    
    private func startCommunitySearch() {
        communitySearch = CommunitySearchCoordinator(router: Router())
        add(communitySearch)
        communitySearch.delegate = self
        communitySearch.start()
        self.router.present(communitySearch, animated: false)
    }
    
    private func startAddMemoji() {
        addMemojiCoordinator = AddMemojiCoordinator(router: Router())
        add(addMemojiCoordinator)
        addMemojiCoordinator.delegate = self
        addMemojiCoordinator.start(isfromMyAccount: true)
        self.router.present(addMemojiCoordinator, animated: true)
    }
    
    private func startHabitCalender() {
        habitCalender = HabitCalenderCoordinator(router: Router())
        add(habitCalender)
        habitCalender.delegate = self
        habitCalender.start(habitId: controller.home.viewModel.habitId, userId: habitCalender.controller.viewModel.userId, isfromGroupHabitCalendar: false)
        self.router.present(habitCalender, animated: true)
    }
    
    private func startGroupHabitCalender() {
        groupHabitCalender = GroupHabitCalenderCoordinator(router: Router())
        add(groupHabitCalender)
        groupHabitCalender.delegate = self
        if controller.calendarScreenType == .home {
            groupHabitCalender.start(habitId: controller.home.viewModel.habitId)
        } else {
            groupHabitCalender.start(habitId: controller.community.viewModel.habitId)
        }
        self.router.present(groupHabitCalender, animated: true)
    }
    
    private func startHabitTypeView() {
        let imageDataDict:[String: String] = ["name": "tab33"]
        NotificationCenter.default.post(name: .RotateTab, object: nil, userInfo: imageDataDict)
        self.router.present(selectHabitPopUp, animated: true)
    }
    
    private func startHabitName(type: HabitType) {
        habitName = HabitNameCoordinator(router: Router())
        add(habitName)
        habitName.delegate = self
        habitName.start(type: type)
        self.router.present(habitName, animated: true)
    }
    
    private func startCommunityDetail() {
        communityDetail = CommunityDetailCoordinator(router: Router())
        add(communityDetail)
        communityDetail.delegate = self
        communityDetail.start(habitId: controller.community.viewModel.habitId)
        self.router.present(communityDetail, animated: true)
    }
    
    
    private func startUpdateProfile() {
        updateProfile.didUpdateName = controller.myAccount.didUpdateName
        router.present(updateProfile, animated: true)
    }
    
    private func startChangePassword() {
        router.present(changePassword, animated: true)
    }
    
    private func startWebViewController() {
        webViewController.webPage = controller.myAccount.viewModel.webPage
        router.present(webViewController, animated: true)
    }
    
    private func startMyAccountPopup() {
        router.present(myAccountPopup, animated: true)
    }
    
    private func startSubscription() {
        subscription = SubscriptionCoordinator(router: Router())
        add(subscription)
        subscription.delegate = self
        if controller.subscriptionSourceScreen == .login {
            subscription.start(sourceScreen: .login)
        } else {
            subscription.start(sourceScreen: .myAccount)
        }
        self.router.present(subscription, animated: true)
    }
}

extension LandingCoordinator: NextSceneDismisser {
    
    func push(scene: Scenes) {
        switch scene {
        case .login: startLogin()
        case .welcome: startWelcome()
        case .myAccount: startMyAccount()
        case .subscription: startSubscription()
        case .habitCalender: startHabitCalender()
        case .updateProfile: startUpdateProfile()
        case .changePassword: startChangePassword()
        case .myAccountPopup: startMyAccountPopup()
        case .learnHowToAddMemoji: startAddMemoji()
        case .selectHabitPopUp: startHabitTypeView()
        case .communityDetail: startCommunityDetail()
        case .communitySearch: startCommunitySearch()
        case .webViewController: startWebViewController()
        case .groupHabitFriends: startGroupHabitCalender()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension LandingCoordinator: CoordinatorDimisser {
    
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

extension LandingCoordinator: SelectHabitPopUpDelegate {
    func addHabit(type: HabitType) {
        self.startHabitName(type: type)
    }
}
