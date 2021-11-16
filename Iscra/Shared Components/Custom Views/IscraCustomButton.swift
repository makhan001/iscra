//
//  IscraCustomButton.swift
//  Iscra
//
//  Created by Lokesh Patil on 14/10/21.
//

import Foundation
import UIKit
import QuartzCore

/// Computed properties, based on the backing CALayer property, that are visible in Interface Builder.
@IBDesignable open class IscraCustomButton: UIButton {
    
    /// When positive, the background of the layer will be drawn with rounded corners. Also effects the mask generated by the `masksToBounds' property. Defaults to zero. Animatable.
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    
    /// The width of the layer's border, inset from the layer bounds. The border is composited above the layer's content and sublayers and includes the effects of the `cornerRadius' property. Defaults to zero. Animatable.
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    /// The color of the layer's border. Defaults to opaque black. Colors created from tiled patterns are supported. Animatable.
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    /// The color of the shadow. Defaults to opaque black. Colors created from patterns are currently NOT supported. Animatable.
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    /// The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    /// The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
    var fontSize:Int = 10
    @IBInspectable var FontSize: Int {
        set(value) {
            fontSize = value
        }
        get {
            return 10
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
                self.titleLabel?.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .regular)
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
                self.titleLabel?.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .ultraLight)
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
                self.titleLabel?.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .light)
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
                self.titleLabel?.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .semibold)
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
                self.titleLabel?.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .bold)
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
                self.titleLabel?.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .black)
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
                self.titleLabel?.font = UIFont.systemFont(ofSize:  CGFloat(fontSize), weight: .medium)
                contentScaleFactor = 0.5
            }
        }
    }
    
    
    @IBInspectable var stringId: String {
        
        set(value) {
            //    self.setTitle(AMPLocalizeUtils.defaultLocalizer.stringForKey(key: value), for: .normal)
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
        //        if let str:String = AMPLocalizeUtils.defaultLocalizer.stringForKey(key: (titleLabel?.text ?? " "))
        //               {
        //               self.setTitle(AMPLocalizeUtils.defaultLocalizer.stringForKey(key: (titleLabel?.text ?? " ")), for: .normal)
        //               }
    }
}

// Call this Function only, access from any where in your project

// Default values here
private let animationDuration: TimeInterval = 1.0
private let deleyTime: TimeInterval = 0
private let springDamping: CGFloat = 0.25
private let lowSpringDamping: CGFloat = 0.50
private let springVelocity: CGFloat = 8.00

extension IscraCustomButton {
    
    //MARK:- Default Animation here
    public func AnimateImage(){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: springDamping, springVelocity: springVelocity)
    }
    
    //MARK:- Custom Animation here
    public func AnimateImageWithSpringDuration(_ name:UIButton, animationDuration:TimeInterval, springDamping:CGFloat, springVelocity:CGFloat){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: springDamping, springVelocity: springVelocity)
    }
    
    //MARK:- Low Damping Custom Animation here
    public func AnimateImageWithSpringDurationWithLowDamping(_ name:UIButton, animationDuration:TimeInterval, springVelocity:CGFloat){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: lowSpringDamping, springVelocity: springVelocity)
    }
    
    private func provideAnimation(animationDuration:TimeInterval, deleyTime:TimeInterval, springDamping:CGFloat, springVelocity:CGFloat){
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIButton.animate(withDuration: animationDuration,
                         delay: deleyTime,
                         usingSpringWithDamping: springDamping,
                         initialSpringVelocity: springVelocity,
                         options: .allowUserInteraction,
                         animations: {
                            self.transform = CGAffineTransform.identity
                         })
    }
}