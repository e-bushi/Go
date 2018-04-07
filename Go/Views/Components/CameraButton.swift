//
//  CameraButton.swift
//  Go
//
//  Created by Elmer Astudillo on 4/6/18.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit
import SnapKit

protocol CameraButtonDelegate: class {
    func capture()
    func stopCapture()
    func captureDuration(seconds: Int)
}

class CameraButton: UIView {
    
    var timer = Timer()
    var seconds = 10
    
    weak var cameraButtonDelegate: CameraButtonDelegate!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LAYOUT
    override func layoutSubviews() {
        super.layoutSubviews()
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.red
        self.layer.cornerRadius = 50.0
        let cameraButtonRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(cameraButtonRecognizer)
    }
    
    // MARK: - CameraButtonDelegate
    
    @objc func capturePressed() {
        cameraButtonDelegate.capture()
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began{
            cameraButtonDelegate.capture()
            //start timer
            runTimer()
            
            cameraButtonDelegate.captureDuration(seconds: self.seconds)
        } else if gesture.state == .ended || seconds <= 0 {
            cameraButtonDelegate.stopCapture()
            //stop timer
            timer.invalidate()
            self.seconds = 10
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        self.seconds -= 1
    }
}
