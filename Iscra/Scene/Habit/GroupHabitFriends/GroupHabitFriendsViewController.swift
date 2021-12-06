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
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnEditHabit: UIButton!
    @IBOutlet weak var btnBottomSheet: UIButton!
    @IBOutlet weak var btnDeleteHabit: UIButton!
    @IBOutlet weak var btnPreviousMonth: UIButton!
    @IBOutlet weak var btnSegment: UISegmentedControl!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDaysCount: UILabel!
    @IBOutlet weak var lblLongestStreak: UILabel!
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewCalender: FSCalendar!
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var viewEditHabit: UIView!
    @IBOutlet weak var viewDeleteHabit: UIView!
    @IBOutlet weak var viewCircular: CircularProgressBar!
    @IBOutlet weak var tableFriends: GroupHabitFriendsTable!
    
    private var eventsDateArray: [Date] = []
    private var themeColor = UIColor(hex: "#7B86EB")
    private let selectedColor = [NSAttributedString.Key.foregroundColor: UIColor(named: "WhiteAccent")]
    private let unselectedColor = [NSAttributedString.Key.foregroundColor: UIColor(named: "BlackAccent")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
}

// MARK: Instance Methods
extension GroupHabitFriendsViewController {
    private func setup() {
        self.calenderSetup()
        self.circularViewSetup()
        self.viewBottom.isHidden = true
        self.viewProgress.isHidden = true
        self.tableFriends.isHidden = false
        self.tableFriends.configure(obj: 10)
        self.lblTitle.textColor = self.themeColor
        self.lblLongestStreak.text = "Longest \nStreak"
        self.tableFriends.friendTableNavigationDelegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewBottom.addGestureRecognizer(tap)
        [btnBack,btnBottomSheet,btnEditHabit,btnShare,btnDeleteHabit,btnPreviousMonth].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        [btnSegment ].forEach {
            $0?.addTarget(self, action: #selector(segmentPressed(_:)), for: .valueChanged)
        }
        if #available(iOS 13.0, *) {
            self.btnSegment.selectedSegmentTintColor = self.themeColor
        }
        self.btnSegment.setTitleTextAttributes(unselectedColor as [NSAttributedString.Key : Any], for: .normal)
        self.btnSegment.setTitleTextAttributes(selectedColor as [NSAttributedString.Key : Any], for: .selected)
    }
    
    private func calenderSetup() {
        self.viewCalender.firstWeekday = 1
        self.viewCalender.placeholderType = .none
        self.viewCalender.allowsSelection = false
        self.viewCalender.appearance.borderRadius = 0.40
        self.viewCalender.appearance.headerDateFormat = "MMMM"
        self.viewCalender.appearance.headerTitleColor = UIColor.black
        self.viewCalender.appearance.headerMinimumDissolvedAlpha = 0.0;
        self.viewCalender.appearance.weekdayTextColor = UIColor(named: "GrayAccent") ?? #colorLiteral(red: 0.6156862745, green: 0.5843137255, blue: 0.4862745098, alpha: 1)
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
    
    func circularViewSetup() {
        self.viewCircular.lineWidth = 20
        self.viewCircular.ringColor =  self.themeColor!
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
    
    private func progressAction() {
        self.viewProgress.isHidden = false
        self.tableFriends.isHidden = true
    }
    
    private func friendsAction() {
        self.viewProgress.isHidden = true
        self.tableFriends.isHidden = false
    }
    
    private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func bottomSheetAction() {
        self.viewBottom.isHidden = false
    }
    
    private func editAction() {
        self.viewBottom.isHidden = true
        
        let editHabit: EditHabitViewController = EditHabitViewController.from(from: .habit, with: .editHabit)
        self.navigationController?.pushViewController(editHabit, animated: true)
        
//        let storyboard = UIStoryboard(name: "Habit", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "EditHabitViewController") as! EditHabitViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func shareAction() {
        self.viewBottom.isHidden = true
//        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "EditReminderViewController") as! EditReminderViewController
//        self.navigationController?.present(vc, animated: false, completion: nil)
        
        let editReminder: EditReminderViewController = EditReminderViewController.from(from: .landing, with: .editReminder)
        self.navigationController?.present(editReminder, animated: false, completion: nil)
    }
    
    private func deleteAction() {
        self.viewBottom.isHidden = true
        self.showAlert()
    }
    
    private func previousMonthAction() {
        self.viewCalender.setCurrentPage(getPreviousMonth(date: self.viewCalender.currentPage), animated: true)
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
}

extension GroupHabitFriendsViewController: FriendTableNavigation{
    func didNavigateToCalender() {
//        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "HabitCalenderViewController") as! HabitCalenderViewController
//        vc.strTitleName = "Me"
//        navigationController?.pushViewController(vc, animated: true)
        
        let habitCalender: HabitCalenderViewController = HabitCalenderViewController.from(from: .landing, with: .habitCalender)
        habitCalender.strTitleName = "Me"
        self.navigationController?.pushViewController(habitCalender, animated: true)
        
    }
}
