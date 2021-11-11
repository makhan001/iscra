//
//  File.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import Foundation
import UIKit

@IBDesignable open class IscraCustomLabel: UILabel {
    
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
    @IBInspectable var stringId: String {
        set(value) {
        //self.text = AMPLocalizeUtils.defaultLocalizer.stringForKey(key: value)
        }
        get {
            return ""
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // self.text = AMPLocalizeUtils.defaultLocalizer.stringForKey(key: (text ?? ""))
    }
}
