//
//  ProgressView.swift
//  Go
//
//  Created by Kaichi Momose on 2018/04/06.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit

import UIKit

class ProgressView: UIView {
    
    // MARK: - INITIALIZATION
    var didAnimate: Bool = false {
        didSet {
            circleLayer.strokeEnd = didAnimate ? 1.0 : 0.0
        }
    }
    
    var circleBackgroundLayer: CAShapeLayer!
    var circleLayer: CAShapeLayer!
    var percent:CGFloat = 100.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    private var startAngle = CGFloat(-90 * Double.pi / 180)
    private var endAngle = CGFloat(270 * Double.pi / 180)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        // BACKGROUND CIRCLE
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circleBackgroundPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleBackgroundLayer = CAShapeLayer()
        circleBackgroundLayer.path = circleBackgroundPath.cgPath
        circleBackgroundLayer.lineCap = kCALineCapRound
        circleBackgroundLayer.fillColor = UIColor.clear.cgColor
        circleBackgroundLayer.strokeColor = UIColor.lightGray.cgColor
        circleBackgroundLayer.lineWidth = 8.0;
        
        // Draw the circle initially
        circleBackgroundLayer.strokeEnd = 1.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleBackgroundLayer)
        
        // PROGRESS CIRCLE
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: startAngle, endAngle: (endAngle - startAngle) * (percent / 100) + startAngle, clockwise: true)
        
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.lineCap = kCALineCapRound
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 8.0;
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ANIMATION
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e The speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // Right value when the animation ends
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
        
    }
}
