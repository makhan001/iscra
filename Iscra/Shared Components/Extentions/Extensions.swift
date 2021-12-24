//
//  Extensions.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import Foundation
import  UIKit

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


extension UIViewController {
    
    func showToast(message : String, seconds: Double = 1.0){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.init(named: "PrimaryAccent")
        alert.view.alpha = 0.7
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
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

extension String {
    func getDateFromTimeStamp(timeStamp : String, isDayName: Bool) ->  String {
        let date = NSDate(timeIntervalSince1970: Double(timeStamp) ?? 0.0 / 1000)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd-EE" // "dd MMM YY, hh:mm a, EEEE"
    //    dayTimePeriodFormatter.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        let fullNameArr = dateString.components(separatedBy: "-")
      //  print("dateString is \(fullNameArr[0]) and \(fullNameArr[1])")
        if isDayName == true {
            return  fullNameArr[1]
        }else{
            return fullNameArr[0]
        }
    }
}

extension UIImageView {
    func setImageFromURL(_ url:String, with defaultImage:UIImage?) {
        if url.contains("no_image") {
            self.image = defaultImage
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

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
