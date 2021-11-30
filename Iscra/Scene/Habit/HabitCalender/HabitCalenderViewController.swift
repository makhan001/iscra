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
    
    var strTitleName = "Learn English"
    private var eventsDateArray: [Date] = []
    private var themeColor = UIColor(hex: "#7B86EB")
    weak var router: NextSceneDismisser?

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
extension HabitCalenderViewController {
    private func setup() {
        self.calenderSetup()
        self.circularViewSetup()
        self.viewBottom.isHidden = true
        self.lblTitle.textColor = self.themeColor
        self.lblTitle.text = self.strTitleName
        self.lblLongestStreak.text = "Longest \nStreak"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewBottom.addGestureRecognizer(tap)
        [btnBack,btnBottomSheet,btnEditHabit,btnShare,btnDeleteHabit,btnPreviousMonth].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
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
//        let storyboard = UIStoryboard(name: "Habit", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "EditHabitViewController") as! EditHabitViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let editHabit: EditHabitViewController = EditHabitViewController.from(from: .habit, with: .editHabit)
        self.navigationController?.pushViewController(editHabit, animated: true)
        
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
        let alertController = UIAlertController(title: "Delete Habit", message: "Are you sure? The habit will be permanently deleted.", preferredStyle: .alert)
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
        self.present(alertController, animated: true, completion:nil)
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

class CircularProgressBar: UIView {
    //MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.sublayers = nil
        drawBackgroundLayer()
    }
    
    public var ringColor:UIColor =  UIColor(named: "GrayAccent") ?? #colorLiteral(red: 0.6156862745, green: 0.5843137255, blue: 0.4862745098, alpha: 1) {
        didSet{
            self.backgroundLayer.strokeColor = ringColor.cgColor
        }
    }
    
    public var lineWidth:CGFloat = 10 {
        didSet{
            backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }
    
    let backgroundLayer = CAShapeLayer()
    private var radius: CGFloat {
        get{
            if self.frame.width < self.frame.height { return (self.frame.width - lineWidth)/2 }
            else { return (self.frame.height - lineWidth)/2 }
        }
    }
    
    private var pathCenter: CGPoint{ get{ return self.convert(self.center, from: self.superview) } }
    private func drawBackgroundLayer() {
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        self.backgroundLayer.path = path.cgPath
        self.backgroundLayer.lineWidth = lineWidth - (lineWidth * 20/100)
        self.backgroundLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(backgroundLayer)
    }
}


