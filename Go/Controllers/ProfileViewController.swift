//
//  ProfileViewController.swift
//  Go
//
//  Created by Elmer Astudillo on 4/6/18.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var storyButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.lightGray
        storyButton = UIButton(frame: CGRect(x: 200, y: 200, width: 100, height: 100))
        storyButton.backgroundColor = UIColor.red
        storyButton.addTarget(self, action: #selector(storyButtonPressed), for: .touchUpInside)
        view.addSubview(storyButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func storyButtonPressed() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        let storiesVC = StoryViewController(collectionViewLayout: layout)
        storiesVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(storiesVC, animated: true, completion: nil)
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
