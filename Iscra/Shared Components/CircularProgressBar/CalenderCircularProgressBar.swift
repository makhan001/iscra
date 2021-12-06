//
//  CalenderCircularProgressBar.swift
//  Iscra
//
//  Created by mac on 06/12/21.
//

import UIKit
import Foundation

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
