//
//  StoryViewController.swift
//  Go
//
//  Created by Elmer Astudillo on 4/6/18.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit
import AVFoundation

class StoryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "videoCell")
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        self.view.isUserInteractionEnabled = true
    }
    
    // MARK: - COLLECTION VIEW CONTROLLER
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let videoCell = self.collectionView?.cellForItem(at: indexPath) as! VideoCell
        let avPlayerItem = AVPlayerItem(url: videoCell.videoURL!)
        videoCell.player.replaceCurrentItem(with: avPlayerItem)
        videoCell.playerReachedEndNotification()
        videoCell.player.play()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return number of videos TEMP
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let newItemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return newItemSize
    }
    
    // TODO: Is this the best way to be setting up for loading and dimissing a video
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //TODO: Is this the best way to load a video?
        let videoCell = cell as! VideoCell
        let avPlayerItem = AVPlayerItem(url: videoCell.videoURL!)
        videoCell.player.replaceCurrentItem(with: avPlayerItem)
        videoCell.playerReachedEndNotification()
        videoCell.player.play()
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplaying cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        let newCell = cell as! VideoCell
        newCell.player.replaceCurrentItem(with: nil)
    }
}

