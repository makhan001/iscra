//
//  Iscraswift.swift
//  Iscra
//
//  Created by Lokesh Patil on 14/10/21.
//

import Foundation
import UIKit
class IscraCustomTextField: UITextField {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            layer.masksToBounds = true
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            layer.masksToBounds = true
            return layer.borderWidth
        }
        set {
            layer.masksToBounds = true
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                layer.masksToBounds = true
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.masksToBounds = true
                layer.borderColor = color.cgColor
            } else {
                layer.masksToBounds = true
                layer.borderColor = nil
            }
        }
    }
    
    var fontSize:Int = 16
    @IBInspectable var FontSize: Int {
        set(value) {
            fontSize = value
        }
        get {
            return 16
        }
    }
  
    @IBInspectable
    var SSRegular  : Bool {
        get {
            return false
        }
        set {
            if newValue == true {
                //self.font = UIFont(name: "SourceSansPro-Regular", size: CGFloat(fontSize))
                self.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .regular)
                contentScaleFactor = 0.5
            }
        }
    }
    
    @IBInspectable
    var SSExtraLight : Bool {
        get {
            return false
        }
        set {
            if newValue == true {
                //self.font = UIFont(name: "SourceSansPro-ExtraLight", size: CGFloat(fontSize))
                self.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .ultraLight)
                contentScaleFactor = 0.5
            }
        }
    }
    
    @IBInspectable
    var SSLight   : Bool {
        get {
            return false
        }
        set {
            if newValue == true {
                //self.font = UIFont(name: "SourceSansPro-Light", size: CGFloat(fontSize))
                self.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .light)
                contentScaleFactor = 0.5
            }
        }
    }
    
    @IBInspectable
    var SSSemiBold : Bool {
        get {
            return false
        }
        set {
            if newValue == true {
               // self.font = UIFont(name: "SourceSansPro-SemiBold", size: CGFloat(fontSize))
                self.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .semibold)
                contentScaleFactor = 0.5
            }
        }
    }
    
    @IBInspectable
    var SSBold   : Bool {
        get {
            return false
        }
        set {
            if newValue == true {
               // self.font = UIFont(name: "SourceSansPro-Bold", size:  CGFloat(fontSize))
                self.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .bold)
                contentScaleFactor = 0.5
            }
        }
    }
    
    @IBInspectable
    var SSBlack  : Bool {
        get {
            return false
        }
        set {
            if newValue == true {
                //self.font = UIFont(name: "SourceSansPro-Black", size: CGFloat(fontSize))
                self.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .black)
                contentScaleFactor = 0.5
            }
        }
    }
    @IBInspectable
    var SSMedium  : Bool {
        get {
            return false
        }
        set {
            if newValue == true {
                //self.font = UIFont(name: "SourceSansPro-Black", size: CGFloat(fontSize))
                self.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .medium)
                contentScaleFactor = 0.5
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    override internal func awakeFromNib() {
        super.awakeFromNib()
        
        // self.placeholder = AMPLocalizeUtils.defaultLocalizer.stringForKey(key: (placeholder ?? "Write here.."))
    }
}



