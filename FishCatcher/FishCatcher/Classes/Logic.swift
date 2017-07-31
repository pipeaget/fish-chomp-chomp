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
    
    
    func touchRedFish(_ completion: @escaping (_ gameover:Bool)->Void){
        lifes -= 1
        completion(lifes <= 0)
    }
    
    func touchBlueOrGreenFish(){
        score += (redFishes*catchValue)
        catchesToNextLife -= 1
        if catchesToNextLife <= 0 {
            lifes += 1
            catchesToNextLife = 10
        }
        
    }
    
    func lifesChanged(){
        if lifes == 5 && redFishes == 1{
            redFishes += 1
        }else if lifes == 7 && redFishes == 2{
            redFishes += 1
        }
    }
    
}
