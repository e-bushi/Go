//
//  VideoPlayerView.swift
//  Go
//
//  Created by Kaichi Momose on 2018/04/06.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit
import Photos

class VideoPlayerView: UIView, SaveMovieDelegate {

    var videoURL: URL!
    
    let exitButton = ExitButton()
    let saveMovieButton = SaveMovieButton()
    weak var thisVC: VideoPlayBackViewController!
    
    var playerLayer = AVPlayerLayer()
    var player: AVPlayer {
        return playerLayer.player!
    }
    
    init(frame: CGRect, videoURL: URL) {
        super.init(frame: frame)
        self.videoURL = videoURL
        setUpPlayerLayer()
        saveMovieButton.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpPlayerLayer() {
        let playerItem = AVPlayerItem(url: videoURL)
        let player = AVPlayer(playerItem: playerItem)
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        playerLayer.backgroundColor = UIColor.black.cgColor
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.layer.addSublayer(playerLayer)
        player.play()
        
        playerReachedEndNotification()
    }
    
    func playerReachedEndNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
    }
    
    // Allows the video to keep playing on a loop
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        self.player.seek(to: kCMTimeZero)
        self.player.play()
    }
    
    func saveMovie() {
        PHPhotoLibrary.shared().performChanges({ [unowned self] in
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)
        }) { saved, error in
            if saved {
                let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.thisVC.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helper Functions
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(exitButton)
        addSubview(saveMovieButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        exitButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        saveMovieButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-40)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
    }
    
}
