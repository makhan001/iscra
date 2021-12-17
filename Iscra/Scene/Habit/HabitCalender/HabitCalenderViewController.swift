//
//  HabitCalenderViewController.swift
//  Iscra
//
//  Created by mac on 03/11/21.
//

import UIKit
import FSCalendar

class HabitCalenderViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblDaysCount: UILabel!
    @IBOutlet weak var viewEditHabit: UIView!
    @IBOutlet weak var btnEditHabit: UIButton!
    @IBOutlet weak var viewDeleteHabit: UIView!
    @IBOutlet weak var viewCalender: FSCalendar!
    @IBOutlet weak var btnDeleteHabit: UIButton!
    @IBOutlet weak var lblLongestStreak: UILabel!
    @IBOutlet weak var btnPreviousMonth: UIButton!
    @IBOutlet weak var viewCircular: CircularProgressBar!
    @IBOutlet weak var viewNavigation: NavigationBarView!
    @IBOutlet weak var viewMarkasComplete: UIView!
    @IBOutlet weak var btnMarkasComplete: UIButton!

    var strTitleName = ""
    private var eventsDateArray: [Date] = []
    private var themeColor = UIColor(hex: "#7B86EB")
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
extension HabitCalenderViewController {
    private func setup() {
        self.viewModel.view = self
        self.viewBottom.isHidden = true
        self.setUpNavigationBar()
        self.lblLongestStreak.text = "Longest \nStreak"
        self.viewMarkasComplete.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewBottom.addGestureRecognizer(tap)
        [btnEditHabit,btnShare,btnDeleteHabit,btnPreviousMonth,btnMarkasComplete].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "editHabit"), object: nil)
        self.viewModel.getHabitDetail()
        self.habitDetailSetup()
    }
    
    @objc func refrershUI(){
                self.viewModel.getHabitDetail()
                self.habitDetailSetup()
    }
    
    private func calenderSetup() {
        self.viewCalender.firstWeekday = 1
        self.viewCalender.placeholderType = .none
        self.viewCalender.allowsSelection = false
        self.viewCalender.appearance.borderRadius = 0.40
        self.viewCalender.appearance.headerDateFormat = "MMMM"
        self.viewCalender.appearance.weekdayTextColor = UIColor(named: "GrayAccent") ?? #colorLiteral(red: 0.6156862745, green: 0.5843137255, blue: 0.4862745098, alpha: 1)
        self.viewCalender.appearance.headerTitleColor = UIColor.black
        self.viewCalender.appearance.headerMinimumDissolvedAlpha = 0.0;
        self.viewCalender.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        self.viewCalender.appearance.headerTitleFont = UIFont.systemFont(ofSize:  CGFloat(22), weight: .medium)
        
        let dateStrings = ["2021-11-02","2021-11-03", "2021-11-05", "2021-11-14","2021-12-8"]
        var dateObjects = [Date]()
        let dateFormatter = DateFormatter()
        // dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for date in dateStrings{
            let dateObject = dateFormatter.date(from: date)
            dateObjects.append(dateObject!)
        }
        self.eventsDateArray = dateObjects
    }
    
    func habitDetailSetup() {
        self.calenderSetup()
        self.circularViewSetup()
        self.viewNavigation.lblTitle.textColor = self.themeColor
        self.viewNavigation.lblTitle.text = self.strTitleName.capitalized
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
            }else{
                self.viewMarkasComplete.isHidden = true
            }
        }
    }
}

// MARK:- Button Action
extension HabitCalenderViewController {
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.viewBottom.isHidden = true
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
        case btnMarkasComplete:
            self.markAsCompleteAction()
        default:
            break
        }
    }
    
    private func backAction() {
        self.router?.dismiss(controller: .habitCalender)
    }
    
    private func bottomSheetAction() {
        UIView.animate(withDuration: 3.0, animations: {
            self.viewBottom.isHidden = false
            self.view.layoutIfNeeded()
        })
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
        
//        let editReminder: EditReminderViewController = EditReminderViewController.from(from: .landing, with: .editReminder)
//        self.navigationController?.present(editReminder, animated: false, completion: nil)
//
//
//        let inviteFriend: InviteFriendViewController = InviteFriendViewController.from(from: .habit, with: .inviteFriend)
//        inviteFriend.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        inviteFriend.habitType = self.habitType
//        inviteFriend.delegateInvite = self
//        inviteFriend.router = self.router
//        self.navigationController?.present(editReminder, animated: true, completion: nil)
    }
    
    private func deleteAction() {
        self.viewBottom.isHidden = true
        self.showAlert(habitId: String(self.viewModel.habitId))
    }
    
    private func previousMonthAction() {
        self.viewCalender.setCurrentPage(getPreviousMonth(date: self.viewCalender.currentPage), animated: true)
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
}

// MARK: FSCalendarDataSource, FSCalendarDelegate
extension HabitCalenderViewController : FSCalendarDataSource, FSCalendarDelegate , FSCalendarDelegateAppearance{
    // Return UIColor for numbers;
    func calendar(_ calendar: FSCalendar,appearance: FSCalendarAppearance,titleDefaultColorFor date: Date) -> UIColor? {
        if self.eventsDateArray.contains(date) {
            return UIColor.white
            // Return UIColor for eventsDateArray
        }
        return UIColor(named: "GrayAccent") ?? #colorLiteral(red: 0.6156862745, green: 0.5843137255, blue: 0.4862745098, alpha: 1) // Return Default Title Color  UIColor.gray
    }
    
    // Return UIColor for Background;
    func calendar(_ calendar: FSCalendar,appearance: FSCalendarAppearance,fillDefaultColorFor date: Date) -> UIColor? {
        if self.eventsDateArray.contains(date) {
            return self.themeColor! // Return UIColor for eventsDateArray
        }
        // Return Default UIColor
        return UIColor.white
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}

// MARK: API Callback
extension HabitCalenderViewController: HabitViewRepresentable {
    func onAction(_ action: HabitAction) {
        switch action {
        case  let .errorMessage(msg):
            self.showToast(message: msg)
        case .sucessMessage(_):
           // self.showToast(message: msg)
            self.themeColor = UIColor(hex: (self.viewModel.objHabitDetail?.colorTheme) ?? "#7B86EB")
            self.strTitleName = (self.viewModel.objHabitDetail?.name) ?? "Learn English".capitalized
            self.checkCurrentDay(days: (self.viewModel.objHabitDetail?.days)!)
            self.habitDetailSetup()
           // self.getDateFromTimeStamp(timeStamp: (self.viewModel.objHabitDetail?.timer)!)
         //   self.viewModel.objHabitDetail?.habitMarks?[0].habitDay
            
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
extension HabitCalenderViewController {
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

// MARK: navigationBar Action
extension HabitCalenderViewController:  navigationBarAction {
    private func setUpNavigationBar() {
        self.viewNavigation.navType = .habitCalender
        self.viewNavigation.commonInit()
        self.viewNavigation.delegateBarAction = self
    }
    
    func ActionType() {
        self.router?.dismiss(controller: .habitCalender)
    }
    
    func RightButtonAction() {
        self.viewBottom.isHidden = false
    }
}
