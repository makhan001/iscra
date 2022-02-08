
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
    @IBOutlet weak var viewShareHabit: UIView!
    
    private var themeColor = UIColor.clear//UIColor(hex: "#7B86EB")
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
        self.viewShareHabit.isHidden = true
        self.setViewControls()
        self.reloadView()
        self.addObserver()
    }
    
    private func setViewControls() {
        self.lblDaysCount.text = ""
        self.lblLongestStreak.text = "Longest \nStreak"
        self.viewMarkasComplete.isHidden = false
        [btnEditHabit,btnShare,btnDeleteHabit,btnPreviousMonth,btnMarkasComplete,btnNextMonth].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
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
        self.headerMonthSetup()
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
    
    private func headerMonthSetup() {
        
        if Date().currentMonth == self.viewCalender.currentPage.currentMonth && Date().currentYear == self.viewCalender.currentPage.currentYear {
            self.btnNextMonth.isHidden = true
        } else {
            self.btnNextMonth.isHidden = false
        }
    }
    
    private func reloadCaledar() {
        self.calenderSetup()
        self.circularViewSetup()
        self.refreshViews()
        self.viewNavigation.lblTitle.textColor = self.themeColor
        if let daysCount = self.viewModel.longestStreak {
            self.lblDaysCount.text = String(daysCount)
        }
    }
    
    private func circularViewSetup() {
        self.viewCircular.lineWidth = 20
        self.viewCircular.ringColor =  self.themeColor
    }
    
    private func refreshViews() {
        //  if UserStore.userID == self.viewModel.userId {
          if UserStore.userID == self.viewModel.userId &&  UserStore.userID == String(self.viewModel.objHabitDetail?.userID ?? 0) {
              self.viewEditHabit.isHidden = false
              self.viewDeleteHabit.isHidden = false
            self.updateMarksAsCompleteView()
          } else if UserStore.userID == self.viewModel.userId {
            self.viewEditHabit.isHidden = true
            self.viewDeleteHabit.isHidden = true
            self.updateMarksAsCompleteView()
          } else {
              self.viewEditHabit.isHidden = true
              self.viewDeleteHabit.isHidden = true
              self.viewMarkasComplete.isHidden = true
          }
        
          if self.viewModel.objHabitDetail?.habitType == "group_habit" {
              self.viewShareHabit.isHidden = false
          } else {
              self.viewShareHabit.isHidden = true
          }
    }
    
    private func updateMarksAsCompleteView() {
          if  viewModel.arrHabitCalender?.first?.isCompleted == true && viewModel.arrHabitCalender?.first?.habitDay?.toDouble.habitDate == Date().currentHabitDate {
              self.viewMarkasComplete.isHidden = true
          } else if viewModel.arrHabitCalender?.first?.habitDay?.toDouble.habitDate != Date().currentHabitDate {
            self.viewMarkasComplete.isHidden = true
          } else {
            self.viewMarkasComplete.isHidden = false
          }
    }
}

// MARK: Button Action
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
        self.router?.push(scene: .editHabit)
        self.viewBottom.isHidden = true
    }
    
    private func markAsCompleteAction() {
        self.viewModel.apiMarkAsComplete()
        self.viewBottom.isHidden = true
    }
    
    private func shareAction() {
        self.router?.push(scene: .shareHabit)
        self.viewBottom.isHidden = true
    }
    
    private func deleteAction() {
        self.showAlert(habitId: String(self.viewModel.habitId))
        self.viewBottom.isHidden = true
    }
    
    private func previousMonthAction() {
        //  self.viewCalender.setCurrentPage(getPreviousMonth(date: self.viewCalender.currentPage), animated: true)
    }
    
    private func nextMonthAction() {
        // self.viewCalender.setCurrentPage(getNextMonth(date: self.viewCalender.currentPage), animated: true)
    }
    
    private func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    private func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
}

// MARK: FSCalendarDataSource, FSCalendarDelegate
extension HabitCalenderViewController : FSCalendarDataSource, FSCalendarDelegate , FSCalendarDelegateAppearance {
    
    private var habitArrays: (completedArray: [Date]?, inCompletedArray: [Date]?) {
        let completedArray = viewModel.arrHabitCalender?.filter { $0.isCompleted == true }.compactMap { $0.date }
        let inCompletedArray = viewModel.arrHabitCalender?.filter { $0.isCompleted == false }.compactMap { $0.date }
        return (completedArray: completedArray, inCompletedArray: inCompletedArray)
    }
    
    // Return UIColor for numbers;
    func calendar(_ calendar: FSCalendar,appearance: FSCalendarAppearance,titleDefaultColorFor date: Date) -> UIColor? {
        guard let completedArray = habitArrays.completedArray,  let inCompletedArray = habitArrays.inCompletedArray else { return nil }
        
        if completedArray.contains(date)  {
            return UIColor.white
        } else if inCompletedArray.contains(date) {
            return UIColor.white
        }
        return UIColor(named: "GrayAccent") ?? #colorLiteral(red: 0.6156862745, green: 0.5843137255, blue: 0.4862745098, alpha: 1) // Return Default Title Color  UIColor.gray
    }
    
    // Return UIColor for Background;
    func calendar(_ calendar: FSCalendar,appearance: FSCalendarAppearance,fillDefaultColorFor date: Date) -> UIColor? {
        guard let completedArray = habitArrays.completedArray,
              let inCompletedArray = habitArrays.inCompletedArray
        else { return nil }
        if completedArray.contains(date) {
            return self.themeColor
        } else if inCompletedArray.contains(date) {
            return .systemRed
        }
        // Return Default UIColor
        return UIColor.white
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.headerMonthSetup()
        self.getMonthlyHabitDetail()
    }
    
    private func getMonthlyHabitDetail() {
        let timestamp = self.viewCalender.currentPage.addDays(days: 10)
        print("timestamp is \(timestamp)")
        self.viewModel.habitMonth =  String(format: "%.0f", timestamp)
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
            self.themeColor = UIColor(hex: (self.viewModel.objHabitDetail?.colorTheme) ?? "#7B86EB") ?? UIColor.clear
            if self.viewModel.isfromGroupHabitCalendar != true {
                
                guard let name = self.viewModel.objHabitDetail?.name else { return }
                self.viewNavigation.lblTitle.text = name.capitalized
            } else {
                let arrMember = self.viewModel.objHabitDetail?.members?.filter({$0.id == Int(self.viewModel.userId)})
                if arrMember?.isEmpty != true {
                    
                    guard let member = arrMember?[0], let username = member.username else { return }
                    let name = username.capitalized + "’s progress"
                    self.viewNavigation.lblTitle.text = name
                }
            }
            
            self.reloadCaledar()
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
    private func showAlert(habitId: String) {
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

extension HabitCalender {
    var date: Date?{
        guard let habitDay = habitDay else { return nil }
        let epocTime =  TimeInterval(habitDay)
        let calenderDate = Date(timeIntervalSince1970: epocTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date =  dateFormatter.string(from: calenderDate)
        let convertedDate = dateFormatter.date(from: date)
        return convertedDate
    }
}


