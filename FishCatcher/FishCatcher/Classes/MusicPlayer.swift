//
//  MusicPlayer.swift
//  FishCatcher
//
//  Created by F J Castaneda Ramos on 7/31/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import AVFoundation

class AudioPlayer:NSObject {
    var backgroundPlayer:AVAudioPlayer!
    internal var isPlaying = true
    
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
        isPlaying = false
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
    
    func tooglePlay() {
        if isPlaying{
            stopBackgroundMusic()
            isPlaying = false
        }else{
            playBackgroundMusic()
            isPlaying = true
        }
    }
}
