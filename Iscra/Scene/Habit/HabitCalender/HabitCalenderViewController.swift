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
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnEditHabit: UIButton!
    @IBOutlet weak var btnBottomSheet: UIButton!
    @IBOutlet weak var btnDeleteHabit: UIButton!
    @IBOutlet weak var btnPreviousMonth: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDaysCount: UILabel!
    @IBOutlet weak var lblLongestStreak: UILabel!
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewCalender: FSCalendar!
    @IBOutlet weak var viewEditHabit: UIView!
    @IBOutlet weak var viewDeleteHabit: UIView!
    @IBOutlet weak var viewCircular: CircularProgressBar!
    
  //  var objHabitDetail: AllHabits?
    var strTitleName = ""
    private var eventsDateArray: [Date] = []
    private var themeColor = UIColor(hex: "#7B86EB")
    weak var router: NextSceneDismisser?
    let viewModel: HabitCalenderViewModel = HabitCalenderViewModel(provider: HabitServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
       //  print("self.router is \(self.router)")
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
        self.lblLongestStreak.text = "Longest \nStreak"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewBottom.addGestureRecognizer(tap)
        [btnBack,btnBottomSheet,btnEditHabit,btnShare,btnDeleteHabit,btnPreviousMonth].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "editHabit"), object: nil)
        self.viewModel.getHabitDetail()
        self.habitDetailSetup()
    }
    
    @objc func refrershUI(){
        print("refrershUI is called")
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
        self.lblTitle.textColor = self.themeColor
        self.lblTitle.text = self.strTitleName.capitalized
    }
    
    func circularViewSetup() {
        self.viewCircular.lineWidth = 20
        self.viewCircular.ringColor =  self.themeColor!
    }
}

// MARK:- Button Action
extension HabitCalenderViewController {
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.viewBottom.isHidden = true
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnBack:
            self.backAction()
        case btnBottomSheet:
            self.bottomSheetAction()
        case btnEditHabit:
            self.editAction()
        case btnShare:
            self.shareAction()
        case btnDeleteHabit:
            self.deleteAction()
        case btnPreviousMonth:
            self.previousMonthAction()
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
//        let editHabit: EditHabitViewController = EditHabitViewController.from(from: .habit, with: .editHabit)
//        editHabit.objHabitDetail = self.viewModel.objHabitDetail
//        editHabit.router = self.router
//        self.navigationController?.pushViewController(editHabit, animated: true)
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
    
//    func getDateFromTimeStamp(timeStamp : String) -> String {
//        let date = NSDate(timeIntervalSince1970: Double(timeStamp) ?? 0.0 / 1000)
//            let dayTimePeriodFormatter = DateFormatter()
//            dayTimePeriodFormatter.dateFormat = "dd MMM YY, hh:mm a, EEEE"
//        dayTimePeriodFormatter.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
//            let dateString = dayTimePeriodFormatter.string(from: date as Date)
//        print("dateString is \(dateString)")
//            return dateString
//        }
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
