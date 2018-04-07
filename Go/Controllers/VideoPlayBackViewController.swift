//
//  VideoPlayBackViewController.swift
//  Go
//
//  Created by Kaichi Momose on 2018/04/06.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit

class VideoPlayBackViewController: UIViewController {

    var videoURL: URL!
    
    override func loadView() {
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let videoPlayerView = VideoPlayerView(frame: rect , videoURL: videoURL)
        self.view = videoPlayerView
        videoPlayerView.thisVC = self
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
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
