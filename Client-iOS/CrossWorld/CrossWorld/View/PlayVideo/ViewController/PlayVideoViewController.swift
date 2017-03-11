//
//  PlayVideoViewController.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class PlayVideoViewController: AppViewController {
    // MARK: - Outlet
    @IBOutlet weak var clRelate: UICollectionView!
    @IBOutlet weak var lbLessonName: UILabel!
    @IBOutlet weak var viewContentVideo: UIView!
    
    
    // MARK: - Declare
    var videoId = "3UKNO_-m7so"
    
    // MARK: - Define
    var viewplay = XCDYouTubeVideoPlayerViewController()
    
    // MARK: - Setup
    func preferToPlayVideo(){
        viewplay = XCDYouTubeVideoPlayerViewController(videoIdentifier: videoId)
        viewplay.present(in: self.viewContentVideo)
        viewplay.moviePlayer.prepareToPlay()
        viewplay.moviePlayer.scalingMode = .aspectFill
    }
    
    // MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferToPlayVideo()
        // Do any additional setup after loading the view.
    }
    
    override func setupViewController() {
        self.typeViewController = .child
        self.typeNavigationBar = .transparent
        self.leftButtonType = .back
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewplay.moviePlayer.play()
    }
    
    @IBAction func btnMoreClick(_ sender: Any) {
        
    }
    
    
    func readyForDisplayDidChangeNotification(){
        
    }
}

extension PlayVideoViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: Collection View DataSource
    //Must copy: ,
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayVideoCollectionViewCell", for: indexPath) as? PlayVideoCollectionViewCell{
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    //MARK: Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 30) / 2
        return CGSize(width: width , height: width / 162 * 202)
    }
    
}
