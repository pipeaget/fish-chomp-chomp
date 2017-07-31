//
//  MusicPlayer.swift
//  FishCatcher
//
//  Created by F J Castaneda Ramos on 7/31/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import AVFoundation

class AudioPLayer:NSObject {
    var backgroundPlayer:AVAudioPlayer!
    
    
    /// Method that plays the music
    func playBackgroundMusic(){
        guard  let url = Bundle.main.url(forResource: "Chase", withExtension: "wav") else{
            return
        }
        do{
            try backgroundPlayer = AVAudioPlayer(contentsOf: url)
            backgroundPlayer.numberOfLoops = -1
            backgroundPlayer.prepareToPlay()
            backgroundPlayer.play()
        }catch let e {
            print(e.localizedDescription)
        }
    }
    
    
    /// Method that stops the music
    func stopBackgroundMusic(){
        guard let backgroundPlayer = backgroundPlayer, backgroundPlayer.isPlaying else{
            return
        }
        backgroundPlayer.stop()
    }
    
    
    
    /// Method that pauses the music
    func pauseBackgroundMusic(){
        guard let backgroundPlayer = backgroundPlayer, backgroundPlayer.isPlaying else{
            return
        }
        backgroundPlayer.pause()
    }
}
