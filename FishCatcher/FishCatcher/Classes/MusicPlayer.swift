//
//  MusicPlayer.swift
//  FishCatcher
//
//  Created by F J Castaneda Ramos on 7/31/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import AVFoundation

class AudioPlayer:NSObject {
    lazy var backgroundPlayer:AVAudioPlayer?  = {
        guard  let url = Bundle.main.url(forResource: "Chase", withExtension: "wav") else{
            return nil
        }
        do{
            let  backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer.numberOfLoops = -1
            backgroundPlayer.prepareToPlay()
            return backgroundPlayer
        } catch {
            return nil
        }
    }()
    internal var isPlaying = false
    
    /// Method that plays the music
    func playBackgroundMusic(){
        guard let backgroundPlayer = backgroundPlayer, !isPlaying else{
            return
        }
        backgroundPlayer.play()
        isPlaying = true
    }
    
    
    /// Method that stops the music
    func stopBackgroundMusic(){
        
        guard let backgroundPlayer = backgroundPlayer, isPlaying else{
            return
        }
        backgroundPlayer.stop()
        isPlaying = false
    }
    
}
