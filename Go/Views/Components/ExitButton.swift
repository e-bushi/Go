//
//  ExitButton.swift
//  Go
//
//  Created by Kaichi Momose on 2018/04/06.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit

class ExitButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.addTarget(self, action: #selector(dismess), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismess() {
        print("tapped")
        var thisVC = UIApplication.shared.keyWindow?.rootViewController
        while thisVC?.presentedViewController != nil {
            thisVC = thisVC?.presentedViewController
        }
        thisVC?.dismiss(animated: true, completion: nil)
    }
}
