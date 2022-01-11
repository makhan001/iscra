//
//  Extensions.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import  UIKit
import Foundation
import SVProgressHUD


extension UIColor {
    static let primaryAccent: UIColor = UIColor(named: "PrimaryAccent")!
    public convenience init?(hex: String) {
        var hexInt: UInt32 = 0
        let scanner: Scanner = Scanner(string: hex)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
        return
    }
}

protocol AlertControllerDelegate: AnyObject {
    func didPerformAction()
}

enum CustomFontSize : CGFloat {
    case vvvsmall = 8
    /// size 10
    case extraSmall = 10
    /// size 11
    case verySmall = 11
    /// size 12
    case small = 12
    /// size 13
    case mediumSmall = 13
    /// size 14
    case regular = 14
    /// size 15
    case semimedium = 15
    /// size 16
    case medium = 16
    /// size 18
    case large = 18
    /// size 20
    case largemid = 20
    /// size 22
    case vLarge = 22
    /// size 24
    case vvLarge = 24
    /// size 26
    case xLarge = 26
    /// size 28
    case xxLarge = 28
    /// size 32
    case xxxLarge = 32
    /// size 36
    case xxxxLarge = 36
}
enum CustomFont : String {
    case black = "Rubik-Black"
    
}

//// Various custom fonts
extension UIFont {
    static func setCustomFontWithSize( fontType: CustomFont, fontSize : CustomFontSize) -> UIFont {
        return UIFont.init(name:fontType.rawValue , size: fontSize.rawValue) ?? UIFont()
    }
}

extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,byRoundingCorners: corners,cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}


extension UIViewController {
    
    func showToast(message : String, seconds: Double = 1.0){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.init(named: "PrimaryAccent")
        alert.view.alpha = 0.7
        alert.view.layer.cornerRadius = 15
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    static func from<T>(from storyboard: Storyboard, with identifier: StoryboardIdentifier) -> T {
        guard let controller = UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: identifier.rawValue) as? T else {
            fatalError("unable to instantiate view controller")
        }
        return controller
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addHabitCancelAlert(title:String, message:String, preferredStyle:UIAlertController.Style, actionTitle:String) {
        weak var delegate: AlertControllerDelegate?
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let action = UIAlertAction(title: actionTitle, style: .default) { (action:UIAlertAction!) in
            delegate?.didPerformAction()
        }
        action.setValue(UIColor.red, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        cancelAction.setValue(UIColor.gray, forKey: "titleTextColor")
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func startAnimation() {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    func stopAnimation() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}

extension UITabBar {
    @IBInspectable var topCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
}


extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod5,1":                 return "iPod Touch 5"
        case "iPod7,1":                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":   return "iPhone 4"
        case "iPhone4,1":                return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":         return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":         return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":         return "iPhone 5s"
        case "iPhone7,2":                return "iPhone 6"
        case "iPhone7,1":                return "iPhone 6 Plus"
        case "iPhone8,1":                return "iPhone 6s"
        case "iPhone8,2":                return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":         return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":         return "iPhone 7 Plus"
        case "iPhone8,4":                return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":      return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":      return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":      return "iPad Air"
        case "iPad5,3", "iPad5,4":           return "iPad Air 2"
        case "iPad6,11", "iPad6,12":          return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":      return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":      return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":      return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":           return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":           return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":           return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":           return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":           return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":               return "Apple TV"
        case "i386", "x86_64":             return "Simulator"
        default:                    return identifier
        }
    }
}

extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var containsEmoji: Bool { contains { $0.isEmoji } }
    
    func getDateFromTimeStamp(timeStamp : String, isDayName: Bool) ->  String {
        let date = NSDate(timeIntervalSince1970: Double(timeStamp) ?? 0.0 / 1000)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd-EE" // "dd MMM YY, hh:mm a, EEEE"
        //    dayTimePeriodFormatter.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        let fullNameArr = dateString.components(separatedBy: "-")
        if isDayName == true {
            return  fullNameArr[1]
        } else {
            return fullNameArr[0]
        }
    }
}

extension UIImageView {
    func setImageFromURL(_ url:String, with defaultImage:UIImage?) {
        self.image = defaultImage
        if url.contains("null") {
            self.contentMode = .scaleAspectFit
            return
        }
        
        let imageLink = url
        guard let urlImage = imageLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            if defaultImage != nil {
                self.image = defaultImage
                self.contentMode = .scaleAspectFit
            } else {
                self.image = nil
            }
            return
        }
        
        let imageURL = URL.init(string: urlImage)
        self.sd_setImage(with: imageURL) { (image, error, _, _) in
            if error != nil {
                self.image = defaultImage
                self.contentMode = .scaleAspectFit
            } else {
                self.image = image
                self.contentMode = .scaleAspectFill
            }
        }
    }
}

extension Locale {
    static var is24Hour: Bool {
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        return dateFormat.firstIndex(of: "a") == nil
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func convertedDate(format: String, strDate: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: strDate) ?? Date()
    }
    
    func addDays(days:Int) -> TimeInterval {
        var dayComponent = DateComponents()
        dayComponent.day = days
        let theCalendar = Calendar.current
        if let nextDate = theCalendar.date(byAdding: dayComponent, to: self) {
            return nextDate.timeIntervalSince1970
        } else {
            return self.timeIntervalSince1970
        }
    }
 
    var currentHabitDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    var currentDate: Int {
        let calendar = Calendar.current
        let compomnents = calendar.dateComponents([.day], from: self)
        return compomnents.day ?? 0
    }
    
    var currentMonth: Int {
        let calendar = Calendar.current
        let compomnents = calendar.dateComponents([.month], from: self)
        return compomnents.month ?? 0
    }
    
    var currentYear: Int {
        let calendar = Calendar.current
        let compomnents = calendar.dateComponents([.year], from: self)
        return compomnents.year ?? 0
    }
}

extension UITableView {
    private struct AssociatedObjectKey {
        static var registeredCells = "registeredCells"
    }
    
    private var registeredCells: Set<String> {
        get {
            if objc_getAssociatedObject(self, &AssociatedObjectKey.registeredCells) as? Set<String> == nil {
                self.registeredCells = Set<String>()
            }
            return objc_getAssociatedObject(self, &AssociatedObjectKey.registeredCells) as! Set<String>
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedObjectKey.registeredCells, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func reloadSection(section:Int, animation: UITableView.RowAnimation = .none) {
        self.reloadSections(IndexSet(integer: section), with: animation)
    }
    
    func registerReusable<T: UITableViewCell>(_: T.Type) where T: Reusable {
        let bundle = Bundle(for: T.self)
        
        if bundle.path(forResource: T.reuseIndentifier, ofType: "nib") != nil {
            let nib = UINib(nibName: T.reuseIndentifier, bundle: bundle)
            register(nib, forCellReuseIdentifier: T.reuseIndentifier)
        } else {
            register(T.self, forCellReuseIdentifier: T.reuseIndentifier)
        }
    }
    
    func dequeueReusable<T: UITableViewCell>(_ indexPath: IndexPath) -> T where T: Reusable {
        if registeredCells.contains(T.reuseIndentifier) == false {
            registeredCells.insert(T.reuseIndentifier)
            registerReusable(T.self)
        }
        
        guard let reuseCell = self.dequeueReusableCell(withIdentifier: T.reuseIndentifier, for: indexPath) as? T else { fatalError("Unable to dequeue cell with identifier \(T.reuseIndentifier)") }
        return reuseCell
    }
    
    func registerReusable<T: UITableViewCell>(_: T.Type) where T: ReusableReminder {
        let bundle = Bundle(for: T.self)
        
        if bundle.path(forResource: T.reuseIndentifier, ofType: "nib") != nil {
            let nib = UINib(nibName: T.reuseIndentifier, bundle: bundle)
            register(nib, forCellReuseIdentifier: T.reuseIndentifier)
        } else {
            register(T.self, forCellReuseIdentifier: T.reuseIndentifier)
        }
    }
    
    func dequeueReusable<T: UITableViewCell>(_ indexPath: IndexPath) -> T where T: ReusableReminder {
        if registeredCells.contains(T.reuseIndentifier) == false {
            registeredCells.insert(T.reuseIndentifier)
            registerReusable(T.self)
        }
        
        guard let reuseCell = self.dequeueReusableCell(withIdentifier: T.reuseIndentifier, for: indexPath) as? T else { fatalError("Unable to dequeue cell with identifier \(T.reuseIndentifier)") }
        return reuseCell
    }
}

// MARK: UIAlertController
extension UIAlertController {
    
    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let title = self.message else {
            return
        }
        let attributedString = NSMutableAttributedString(string: title)
        if let titleFont = font {
            attributedString.addAttributes([NSAttributedString.Key.font : titleFont], range: NSMakeRange(0, title.utf8.count))
        }
        if let titleColor = color {
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor], range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributedString, forKey: "attributedMessage")//4
    }
    
    //Set title font and message color
    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let attributeString = NSMutableAttributedString(string: title, attributes: [
                                                            NSAttributedString.Key.paragraphStyle: paragraphStyle])//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, title.utf8.count))
        }
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")
    }
    
    //Set message font and message color
    func setForgotMessage(font: UIFont?, color: UIColor?) {
        guard let title = self.message else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let attributedString = NSMutableAttributedString(string: title, attributes: [
                                                            NSAttributedString.Key.paragraphStyle: paragraphStyle])
        if let titleFont = font {
            attributedString.addAttributes([NSAttributedString.Key.font : titleFont], range: NSMakeRange(0, title.utf8.count))
        }
        if let titleColor = color {
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor], range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributedString, forKey: "attributedMessage")
    }
}

extension Notification.Name {
    static let RotateTab = Notification.Name("rotateTab")
    static let EditHabit = Notification.Name("EditHabit")
    static let JoinHabit = Notification.Name("JoinHabit")
    static let MarkAsComplete = Notification.Name("MarkAsComplete")
    static let SearchAllGroup = Notification.Name("SearchAllGroup")
    static let purchaseFinished = Notification.Name("purchaseFinished")
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
    static let IAPHelperPurchaseFinishNotification = Notification.Name("IAPHelperPurchaseFinishNotification")
    static let IAPHelperSubscriptionExpireDateNotification = Notification.Name("IAPHelperSubscriptionExpireDateNotification")
}

extension Int {
    var toDouble: Double {
        return Double(self)
    }
}

extension TimeInterval {
    var habitDate: String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    var date: Date {
        return Date(timeIntervalSince1970: self)
    }
    
    var daysDifference: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self.date, to: Date())
        return components.day ?? 0
    }
}

extension UICollectionView {
    private struct AssociatedObjectKey {
        static var registeredCells = "registeredCells"
    }
    private var registeredCells: Set<String> {
        get {
            if objc_getAssociatedObject(self, &AssociatedObjectKey.registeredCells) as? Set<String> == nil {
                self.registeredCells = Set<String>()
            }
            return objc_getAssociatedObject(self, &AssociatedObjectKey.registeredCells) as! Set<String>
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedObjectKey.registeredCells, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func registerReusable<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        let bundle = Bundle(for: T.self)
        if bundle.path(forResource: T.reuseIndentifier, ofType: "nib") != nil {
            let nib = UINib(nibName: T.reuseIndentifier, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: T.reuseIndentifier)
        } else {
            register(T.self, forCellWithReuseIdentifier: T.reuseIndentifier)
        }
    }
    func dequeueReusable<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T where T: Reusable {
        if registeredCells.contains(T.reuseIndentifier) == false {
            registeredCells.insert(T.reuseIndentifier)
            registerReusable(T.self)
        }
        guard let reuseCell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIndentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier \(T.reuseIndentifier)")
        }
        return reuseCell
    }
    func registerReusable<T: UICollectionViewCell>(_: T.Type) where T: ReusableReminder {
        let bundle = Bundle(for: T.self)
        if bundle.path(forResource: T.reuseIndentifier, ofType: "nib") != nil {
            let nib = UINib(nibName: T.reuseIndentifier, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: T.reuseIndentifier)
        } else {
            register(T.self, forCellWithReuseIdentifier: T.reuseIndentifier)
        }
    }
    func dequeueReusable<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T where T: ReusableReminder {
        if registeredCells.contains(T.reuseIndentifier) == false {
            registeredCells.insert(T.reuseIndentifier)
            registerReusable(T.self)
        }
        guard let reuseCell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIndentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier \(T.reuseIndentifier)")
        }
        return reuseCell
    }
}

class ColumnFlowLayout: UICollectionViewFlowLayout {
    let cellsPerRow: Int
    init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        super.init()
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
}

