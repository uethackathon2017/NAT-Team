//
//  SoundManager.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/12/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class SoundManager {
    
    enum nameRing: String {
        case incommingCall = "mtp"
    }
    
    static var share = SoundManager()
    
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    var timerForVibration = Timer()
    
    func playSoundIncommingCall() {
        let audioFilePath = Bundle.main.path(forResource: nameRing.incommingCall.rawValue, ofType: "mp3")
        
        self.timerForVibration = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(oneVibration), userInfo: nil, repeats: true)
        
        if audioFilePath != nil {
            
            let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
            
            audioPlayer = try! AVAudioPlayer(contentsOf: audioFileUrl)
            audioPlayer.play()
            
        } else {
            //
        }
    }
    
    @objc func oneVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func stopSoundBooking() {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        timerForVibration.invalidate()
    }
}
