//
//  GroupHabitFriendsViewController.swift
//  Iscra
//
//  Created by mac on 11/11/21.
//

import UIKit
import FSCalendar

class GroupHabitFriendsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var viewEditHabit: UIView!
    @IBOutlet weak var lblDaysCount: UILabel!
    @IBOutlet weak var btnEditHabit: UIButton!
    @IBOutlet weak var btnNextMonth: UIButton!
    @IBOutlet weak var viewDeleteHabit: UIView!
    @IBOutlet weak var btnDeleteHabit: UIButton!
    @IBOutlet weak var viewCalender: FSCalendar!
    @IBOutlet weak var lblLongestStreak: UILabel!
    @IBOutlet weak var btnPreviousMonth: UIButton!
    @IBOutlet weak var btnSegment: UISegmentedControl!
    @IBOutlet weak var viewCircular: CircularProgressBar!
    @IBOutlet weak var viewNavigation: NavigationBarView!
    @IBOutlet weak var tableFriends: GroupHabitFriendsTable!
    @IBOutlet weak var viewMarkasComplete: UIView!
    @IBOutlet weak var btnMarkasComplete: UIButton!
    
    private var eventsDateArray: [Date] = []
    private var themeColor = UIColor(hex: "#7B86EB")
    private let selectedColor = [NSAttributedString.Key.foregroundColor: UIColor(named: "WhiteAccent")]
    private let unselectedColor = [NSAttributedString.Key.foregroundColor: UIColor(named: "BlackAccent")]

    var strTitleName = ""
    weak var router: NextSceneDismisser?
    let viewModel: HabitCalenderViewModel = HabitCalenderViewModel(provider: HabitServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: Instance Methods
extension GroupHabitFriendsViewController {
    private func setup() {
        self.viewModel.view = self
        self.viewBottom.isHidden = true
        self.configureTable()
        self.setViewControls()
        self.viewModel.userId = UserStore.userID ?? ""
        self.reloadView()
        self.addObserver()
    }
    
    private func setViewControls() {
        self.viewBottom.isHidden = true
        self.viewProgress.isHidden = true
        self.viewMarkasComplete.isHidden = true
        self.lblLongestStreak.text = "Longest \nStreak"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewBottom.addGestureRecognizer(tap)
        [btnEditHabit,btnShare,btnDeleteHabit,btnPreviousMonth,btnMarkasComplete,btnNextMonth].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        [btnSegment ].forEach {
            $0?.addTarget(self, action: #selector(segmentPressed(_:)), for: .valueChanged)
        }
        self.btnSegment.setTitleTextAttributes(unselectedColor as [NSAttributedString.Key : Any], for: .normal)
        self.btnSegment.setTitleTextAttributes(selectedColor as [NSAttributedString.Key : Any], for: .selected)
        self.setUpNavigationBar()
        self.addGestureOnBottomView()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadView) , name: .EditHabit, object: nil)
    }
    
    private func addGestureOnBottomView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.viewBottom.addGestureRecognizer(tap)
    }
    
    @objc func reloadView() {
        self.viewModel.fetchHabitDetail()
        self.getMonthlyHabitDetail()
        self.reloadCaledar()
    }
        
    private func calenderSetup() {
        self.viewCalender.firstWeekday = 1
        self.viewCalender.placeholderType = .none
        self.viewCalender.allowsSelection = false
        self.viewCalender.appearance.borderRadius = 0.40
        self.viewCalender.appearance.headerDateFormat = "MMMM YYYY"
        self.viewCalender.appearance.weekdayTextColor = UIColor(named: "GrayAccent") ?? #colorLiteral(red: 0.6156862745, green: 0.5843137255, blue: 0.4862745098, alpha: 1)
        self.viewCalender.appearance.headerTitleColor = UIColor.black
        self.viewCalender.appearance.headerMinimumDissolvedAlpha = 0.0;
        self.viewCalender.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        self.viewCalender.appearance.headerTitleFont = UIFont.systemFont(ofSize:  CGFloat(22), weight: .medium)
    }
        
    func reloadCaledar() {
        self.calenderSetup()
        self.circularViewSetup()
        self.viewNavigation.lblTitle.textColor = self.themeColor
        self.btnSegment.selectedSegmentTintColor = self.themeColor
        self.lblDaysCount.text = String(self.viewModel.longestStreak ?? 0)
        self.viewNavigation.lblTitle.text = self.strTitleName.capitalized
        self.eventsDateArray = viewModel.arrHabitCalender?.compactMap { $0.date } ?? [Date()]
    }
    
    func circularViewSetup() {
        self.viewCircular.lineWidth = 20
        self.viewCircular.ringColor =  self.themeColor!
    }
    
    func checkCurrentDay(days: [String]) {
        var dayName: String = ""
        dayName =  dayName.getDateFromTimeStamp(timeStamp : String(format: "%.0f", NSDate().timeIntervalSince1970), isDayName: true).lowercased()
        for i in days {
            if i.contains(dayName){
                self.viewMarkasComplete.isHidden = false
            }
        }
    }
    
    private func configureTable() {
      self.tableFriends.configure(viewModel: viewModel)
      self.tableFriends.isHidden = false
     // self.tableFriends.configure(obj: 10)
      self.tableFriends.friendTableNavigationDelegate = self
  }
}

// MARK:- Button Action
extension GroupHabitFriendsViewController {
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.viewBottom.isHidden = true
    }
    
    @objc func segmentPressed(_ sender: UISegmentedControl) {
        switch btnSegment.selectedSegmentIndex {
        case 0:
            friendsAction()
        case 1:
            progressAction()
        default:
            break
        }
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnEditHabit:
            self.editAction()
        case btnShare:
            self.shareAction()
        case btnDeleteHabit:
            self.deleteAction()
        case btnPreviousMonth:
            self.previousMonthAction()
        case btnNextMonth:
            self.nextMonthAction()
        case btnMarkasComplete:
            self.markAsCompleteAction()
        default:
            break
        }
    }
    
    private func progressAction() {
        self.viewProgress.isHidden = false
        self.tableFriends.isHidden = true
    }
    
    private func friendsAction() {
        self.viewProgress.isHidden = true
        self.tableFriends.isHidden = false
    }
    
    private func backAction() {
        self.router?.dismiss(controller: .habitCalender)
    }
    
    private func editAction() {
        self.viewBottom.isHidden = true
        self.router?.push(scene: .editHabit)
    }
    
    private func markAsCompleteAction() {
        self.viewBottom.isHidden = true
        self.viewModel.apiMarkAsComplete()
    }
    
    private func shareAction() {
        self.viewBottom.isHidden = true
        self.showToast(message: "Under development", seconds: 0.5)
    }
    
    private func deleteAction() {
        self.viewBottom.isHidden = true
        self.showAlert(habitId: String(self.viewModel.habitId))
    }
    
    private func previousMonthAction() {
      //  self.viewCalender.setCurrentPage(getPreviousMonth(date: self.viewCalender.currentPage), animated: true)
    }
    
    private func nextMonthAction() {
      //  self.viewCalender.setCurrentPage(getNextMonth(date: self.viewCalender.currentPage), animated: true)
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Delete Habit", message: AppConstant.deleteHabit, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action: UIAlertAction!) in
            print("Delete button tapped");
        }
        deleteAction.setValue(UIColor.gray, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction!) in
            print("Cancel button tapped");
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension GroupHabitFriendsViewController : FSCalendarDataSource, FSCalendarDelegate , FSCalendarDelegateAppearance{
    // Return UIColor for numbers;
    func calendar(_ calendar: FSCalendar,appearance: FSCalendarAppearance,titleDefaultColorFor date: Date) -> UIColor? {
        if self.eventsDateArray.contains(date) {
            return UIColor.white
            // Return UIColor for eventsDateArray
        }
        return  UIColor(named: "GrayAccent") ?? #colorLiteral(red: 0.6156862745, green: 0.5843137255, blue: 0.4862745098, alpha: 1) // Return Default Title Color  UIColor.gray
    }
    
    // Return UIColor for Background;
    func calendar(_ calendar: FSCalendar,appearance: FSCalendarAppearance,fillDefaultColorFor date: Date) -> UIColor? {
        if self.eventsDateArray.contains(date) {
            return self.themeColor! // Return UIColor for eventsDateArray
        }
        return UIColor.white // Return Default UIColor
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.getMonthlyHabitDetail()
    }
    
    func getMonthlyHabitDetail() {
        let timestamp = self.viewCalender.currentPage.addDays(days: 10)
        print("timestamp is \(timestamp)")
        self.viewModel.habitMonth =  String(format: "%.0f", timestamp)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.getMonthlyHabitDetail()
        }
    }
}

extension GroupHabitFriendsViewController: FriendTableNavigation{
    func didNavigateToCalender() {
        //        let habitCalender: HabitCalenderViewController = HabitCalenderViewController.from(from: .landing, with: .habitCalender)
        //        habitCalender.strTitleName = "Me"
        //        habitCalender.router = self.router
        //        print("self.router is \(self.router)")
        //        self.navigationController?.pushViewController(habitCalender, animated: true)
        //
        self.showToast(message: "Under development", seconds: 0.5)
        //  self.router?.push(scene: .habitCalender)
    }
}

// MARK: API Callback
extension GroupHabitFriendsViewController: HabitViewRepresentable {
    func onAction(_ action: HabitAction) {
        switch action {
        case  let .errorMessage(msg):
            self.showToast(message: msg)
        case .sucessMessage(_):
            // self.showToast(message: msg)
            self.themeColor = UIColor(hex: (self.viewModel.objHabitDetail?.colorTheme) ?? "#7B86EB")
            self.strTitleName = (self.viewModel.objHabitDetail?.name) ?? "Learn English".capitalized
            self.checkCurrentDay(days: (self.viewModel.objHabitDetail?.days)!)
            if UserStore.userID == String(self.viewModel.objHabitDetail?.userID ?? 0) {
                self.viewEditHabit.isHidden = false
                self.viewDeleteHabit.isHidden = false
            } else {
                self.viewEditHabit.isHidden = true
                self.viewDeleteHabit.isHidden = true
            }
            self.reloadCaledar()
            print("members count is \(String(describing: self.viewModel.objHabitDetail?.members?.count))")
            self.tableFriends.reloadData()

            break
        case let .isHabitDelete(true, msg):
            self.showToast(message: msg, seconds: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.router?.push(scene: .landing)
            }
        default:
            break
        }
    }
}
// MARK: showAlert for delete habit
extension GroupHabitFriendsViewController {
    func showAlert(habitId: String) {
        let alertController = UIAlertController(title: "Delete Habit", message: AppConstant.deleteHabit, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action: UIAlertAction!) in
            self.viewModel.deleteHabit(habitId: habitId)
        }
        deleteAction.setValue(UIColor.gray, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction!) in
            print("Cancel button tapped");
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
}

// MARK: NavigationBarView Delegate Callback
extension GroupHabitFriendsViewController: NavigationBarViewDelegate {
    private func setUpNavigationBar() {
        self.viewNavigation.navType = .habitCalender
        self.viewNavigation.commonInit()
        self.viewNavigation.delegateBarAction = self
        self.viewNavigation.lblTitle.textColor = self.themeColor
    }
    
    func navigationBackAction() {
        self.router?.dismiss(controller: .habitCalender)
    }
    
    func navigationRightButtonAction() {
        self.viewBottom.isHidden = false
    }
}
