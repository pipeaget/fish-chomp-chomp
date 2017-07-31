//
//  Logic.swift
//  FishCatcher
//
//  Created by F J Castaneda Ramos on 7/29/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import UIKit

class Logic: NSObject {
    var redFishes:Int          = 1
    var lifes:Int              = 3{
        didSet{
            lifesChanged()
        }
    }
    var catchesToNextLife:Int  = 10
    var score:Int              = 0
    var catchValue             = 10
    var catchesToNextLifeInit  = 10
    
    
    /// Method that dictate what to do when the enemy fish is touched
    ///
    /// - Parameter completion: Boolean with the indication if the game is over or not
    func touchRedFish(_ completion: @escaping (_ gameover:Bool)->Void){
        lifes -= 1
        completion(lifes <= 0)
    }
    
    
    /// Method that dictate what to do when the blue or green fish is touched
    func touchBlueOrGreenFish(){
        score += (redFishes*catchValue)
        catchesToNextLife -= 1
        if catchesToNextLife <= 0 {
            lifes += 1
            catchesToNextLife = catchesToNextLifeInit
        }
        
    }
    
    /// Method that react when you gain a life 
    func lifesChanged(){
        if lifes == 5 && redFishes == 1{
            redFishes += 1
        }else if lifes == 7 && redFishes == 2{
            redFishes += 1
        }
    }
    
}
