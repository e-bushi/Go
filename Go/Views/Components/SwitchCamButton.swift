//
//  SwitchCamButton.swift
//  Go
//
//  Created by Kaichi Momose on 2018/04/06.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit

protocol SwitchCameraDelegate: class {
    func switchCam()
}

class SwitchCamButton: UIButton {

    weak var delegate: SwitchCameraDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBackgroundImage(#imageLiteral(resourceName: "switch"), for: .normal)
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapped() {
       delegate.switchCam()
    }
    
}
