//
//  global.swift
//  Sense
//
//  Created by Bob Yuan on 2020-06-11.
//  Copyright © 2020 Bob Yuan. All rights reserved.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer? = AVAudioPlayer()

var gVars = globalVariables(level: 1, cellLevel: 1)

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
                _print("!!!Error in calling AVAudioPlayer().")
            }
            
            _print("play....")
            audioPlayer?.play()
  
        }
    }
}


