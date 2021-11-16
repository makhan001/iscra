//
//  extentions.swift
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
        // Create scanner
        let scanner: Scanner = Scanner(string: hex)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        //let hexint = Int(self.intFromHexString(hexStr: hex))
        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
        // Create color object, specifying alpha as well
        self.init(red: red, green: green, blue: blue, alpha: 1)
        return
    }
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


extension UIViewController{
    
    func showToast(message : String, seconds: Double = 1.0){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.setMessage(font: UIFont(name: "SourceSansPro-Regular", size: 15), color: UIColor.black)
        alert.view.backgroundColor = UIColor.init(named: "PrimaryAccent")
        alert.view.alpha = 0.7
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
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
