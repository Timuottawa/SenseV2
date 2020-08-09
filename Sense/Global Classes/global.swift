//
//  global.swift
//  Sense
//
//  Created by Bob Yuan on 2020-06-11.
//  Copyright © 2020 Bob Yuan. All rights reserved.
//

import Foundation
import AVFoundation

class globalVariables {
    var level: Int = 1
    var cellLevel: Int = 1
    
    init(level: Int, cellLevel: Int) {
        self.level = level
        self.cellLevel = cellLevel
    }
    
    func soundEffect(filename: String, ext: String) {
        if let url = Bundle.main.url(forResource: filename, withExtension: ext){
            
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            
            if audioPlayer == nil {
                print("!!!Error in calling AVAudioPlayer().")
            }
            
            print("play....")
            audioPlayer?.play()
            
            

        }
    }
}

var gVars = globalVariables(level: 1, cellLevel: 1)

