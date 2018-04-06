//
//  VideoCell.swift
//  Go
//
//  Created by Elmer Astudillo on 4/6/18.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoCell: UICollectionViewCell {
    
    //URL of video to save to Firebase storage. URL is being passed from CameraViewController
    var videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/savvy-76695.appspot.com/o/videos%2Fposts%2FZT5rdrB75fXZfYHykRGBD3AASBG2%2F2017-08-25T20%3A30%3A46Z.mov?alt=media&token=8e7b50aa-4732-4b83-b27f-36a47062cb07") //TEMP
    
    var playerLayer = AVPlayerLayer()
    var player: AVPlayer {
        return playerLayer.player!
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setUpPlayerLayer()
        self.setUpViews()
        self.setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
    }
    
    func setConstraints() {
    }
    
    func setUpPlayerLayer() {
        let playerItem = AVPlayerItem(url: videoURL!)
        let player = AVPlayer(playerItem: playerItem)
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer.frame = self.contentView.bounds
        playerLayer.backgroundColor = UIColor.clear.cgColor
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        self.contentView.layer.addSublayer(playerLayer)
        
        playerReachedEndNotification()
    }
    
    func playerReachedEndNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
    }
    
    // Allows the video to keep playing on a loop
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player.seek(to: kCMTimeZero)
            self.player.play()
        }
    }
    
    // MARK: - Helper Functions
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

