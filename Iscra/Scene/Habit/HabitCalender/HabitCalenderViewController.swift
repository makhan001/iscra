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
    @IBOutlet weak var btnNextMonth: UIButton!
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
        self.viewModel.userId = UserStore.userID ?? ""
        self.lblDaysCount.text = "0"
        self.viewMarkasComplete.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewBottom.addGestureRecognizer(tap)
        [btnEditHabit,btnShare,btnDeleteHabit,btnPreviousMonth,btnMarkasComplete,btnNextMonth].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "editHabit"), object: nil)
        //   self.viewModel.getMonthlyHabitDetail() // deepak commented
        self.viewModel.fetchHabitDetail()
        self.habitDetailSetup()
    }
    
    @objc func refrershUI(){
        self.viewModel.fetchHabitDetail()
        self.habitDetailSetup()
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
        case btnNextMonth:
            self.nextMonthAction()
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
    }
    
    private func deleteAction() {
        self.viewBottom.isHidden = true
        self.showAlert(habitId: String(self.viewModel.habitId))
    }
    
    private func previousMonthAction() {
        //  self.viewCalender.setCurrentPage(getPreviousMonth(date: self.viewCalender.currentPage), animated: true)
    }
    
    private func nextMonthAction() {
        // self.viewCalender.setCurrentPage(getNextMonth(date: self.viewCalender.currentPage), animated: true)
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
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
    //
    //    func minimumDate(for calendar: FSCalendar) -> Date {
    //        return Date()
    //    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("self.viewCalender.currentPage timeIntervalSince1970 is \(self.viewCalender.currentPage.timeIntervalSince1970)")
        self.viewModel.habitMonth =  String(format: "%.0f", self.viewCalender.currentPage.timeIntervalSince1970)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.getMonthlyHabitDetail()
        }
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
            self.themeColor = UIColor(hex: (self.viewModel.objShowHabitDetail?.colorTheme) ?? "#7B86EB")
            self.strTitleName = (self.viewModel.objShowHabitDetail?.name) ?? "Learn English".capitalized
            self.checkCurrentDay(days: (self.viewModel.objShowHabitDetail?.days)!)
            
            if UserStore.userID == String(self.viewModel.objShowHabitDetail?.userID ?? 0) {
                self.viewEditHabit.isHidden = false
                self.viewDeleteHabit.isHidden = false
            } else {
                self.viewEditHabit.isHidden = true
                self.viewDeleteHabit.isHidden = true
            }
            
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

// MARK: NavigationBarView Delegate Callback
extension HabitCalenderViewController: NavigationBarViewDelegate {
    private func setUpNavigationBar() {
        self.viewNavigation.navType = .habitCalender
        self.viewNavigation.commonInit()
        self.viewNavigation.delegateBarAction = self
    }
    
    func navigationBackAction() {
        self.router?.dismiss(controller: .habitCalender)
    }
    
    func navigationRightButtonAction() {
        self.viewBottom.isHidden = false
    }
}
