//
//  GameChanged.swift
//  FishCatcher
//
//  Created by Javier Castañeda on 9/11/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import UIKit

protocol GameChanged {
    func loseLife()
    func getLife()
    func fishCatch(_ fishesToCatch: Int)
    func setScore(score: Int)
    func gameover()
    
}
