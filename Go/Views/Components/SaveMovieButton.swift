//
//  SaveMovieButton.swift
//  Go
//
//  Created by Kaichi Momose on 2018/04/06.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit

protocol SaveMovieDelegate: class {
    func saveMovie()
}

class SaveMovieButton: UIButton {

    weak var delegate: SaveMovieDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        self.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func save() {
        delegate.saveMovie()
    }
}
