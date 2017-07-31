//
//  FishCatcherTests.swift
//  FishCatcherTests
//
//  Created by F J Castaneda Ramos on 7/29/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import XCTest
@testable import FishCatcher

class FishCatcherTests: XCTestCase {
    lazy var logic:Logic = {
        return Logic()
    }()
    
    func testCatchGoodFish(){
        let fishesToNextLife = logic.catchesToNextLife
        logic.touchBlueOrGreenFish()
        XCTAssertEqual(logic.catchesToNextLife, fishesToNextLife-1)
    }
    
    func testGetALife(){
        let numberOfLifes = logic.lifes
        for _ in 0...9{
            logic.touchBlueOrGreenFish()
        }
        XCTAssertEqual(logic.catchesToNextLife, 10)
        XCTAssertEqual(logic.lifes, numberOfLifes+1)
    }
    
    func testEnableSecondRedFish(){
        let redFishes = logic.redFishes
        for _ in 0...19{
            logic.touchBlueOrGreenFish()
        }
        XCTAssertEqual(logic.redFishes, redFishes+1)
        XCTAssertEqual(logic.lifes, 5)
    }
    
    func testGetSecondRedFishAndLoseLife(){
        for _ in 0...19{
            logic.touchBlueOrGreenFish()
        }
        let expect = expectation(description: "Lose life")
        logic.touchRedFish { gameover in
            self.logic.touchBlueOrGreenFish()
            XCTAssertEqual(self.logic.redFishes, 2)
            XCTAssertEqual(self.logic.lifes, 4)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 0.5)
    }
    
    func testGetSecondFishLoseALifeAndGetNewLife(){
        for _ in 0...19{
            logic.touchBlueOrGreenFish()
        }
        let expect = expectation(description: "Lose life")
        logic.touchRedFish { gameover in
            for _ in 0...9{
                self.logic.touchBlueOrGreenFish()
            }
            XCTAssertEqual(self.logic.redFishes, 2)
            XCTAssertEqual(self.logic.lifes, 5)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 0.5)
    }
    
    func testThirdRedFishAppear(){
        let redFishes = logic.redFishes
        for _ in 0...39{
            logic.touchBlueOrGreenFish()
        }
        XCTAssertEqual(logic.redFishes, redFishes+2)
        XCTAssertEqual(logic.lifes, 7)
    }
    
    func testGetThirdRedFishAndLoseLife(){
        for _ in 0...39{
            logic.touchBlueOrGreenFish()
        }
        let expect = expectation(description: "Lose life")
        logic.touchRedFish { gameover in
            self.logic.touchBlueOrGreenFish()
            XCTAssertEqual(self.logic.redFishes, 3)
            XCTAssertEqual(self.logic.lifes, 6)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 0.5)
    }
    
    func testGetThirdFishLoseALifeAndGetNewLife(){
        for _ in 0...39{
            logic.touchBlueOrGreenFish()
        }
        let expect = expectation(description: "Lose life")
        logic.touchRedFish { gameover in
            for _ in 0...9{
                self.logic.touchBlueOrGreenFish()
            }
            XCTAssertEqual(self.logic.redFishes, 3)
            XCTAssertEqual(self.logic.lifes, 7)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 0.5)
    }
    
    func testGameOver(){
        let expect = expectation(description: "Game over")
        for _ in 0...2{
            logic.touchRedFish({ gameover in
                if gameover{
                    XCTAssertEqual(self.logic.lifes, 0)
                    expect.fulfill()
                }
            })
        }
        wait(for: [expect], timeout: 0.5)
    }
    
    func testGainTenPoints(){
        let score = logic.score
        logic.touchBlueOrGreenFish()
        XCTAssertEqual(logic.score, score+10)
    }
    func testGainTwentyPoints(){
        var score = logic.score
        for _ in 0...19{
            score += 10
            logic.touchBlueOrGreenFish()
        }
        XCTAssertEqual(logic.redFishes, 2)
        logic.touchBlueOrGreenFish()
        XCTAssertEqual(logic.score, score+20)
    }
    
    
    func testGainTithtyPoints(){
        var score = logic.score
        for _ in 0...19{
            score += 10
            logic.touchBlueOrGreenFish()
        }
        for _ in 0...19{
            score += 20
            logic.touchBlueOrGreenFish()
        }
        XCTAssertEqual(logic.redFishes, 3)
        logic.touchBlueOrGreenFish()
        XCTAssertEqual(logic.score, score+30)
    }
    
    func testGainTithtyPointsLosingALife(){
        var score = logic.score
        for _ in 0...19{
            score += 10
            logic.touchBlueOrGreenFish()
        }
        for _ in 0...19{
            score += 20
            logic.touchBlueOrGreenFish()
        }
        let expect = expectation(description: "Sum 30 points")
        XCTAssertEqual(logic.redFishes, 3)
        logic.touchBlueOrGreenFish()
        score += 30
        logic.touchRedFish { (gameover) in
            XCTAssertFalse(gameover)
            self.logic.touchBlueOrGreenFish()
            XCTAssertEqual(self.logic.score, score+30)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 0.5)
    }
    
}
