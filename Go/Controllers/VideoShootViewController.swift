//
//  VideoShootViewController.swift
//  Go
//
//  Created by Kaichi Momose on 2018/04/06.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit
import AVFoundation

class VideoShootViewController: UIViewController {
    
    override func loadView() {
        self.view = VideoCaptureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
