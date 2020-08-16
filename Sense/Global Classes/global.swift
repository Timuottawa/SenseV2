//
//  global.swift
//  Sense
//
//  Created by Bob Yuan on 2020-06-11.
//  Copyright © 2020 Bob Yuan. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer? //= AVAudioPlayer()


var gVars = globalVariables(level: 1, cellLevel: 1)

class globalVariables {
    var level: Int = 1
    var cellLevel: Int = 1
    
    init(level: Int, cellLevel: Int) {
        self.level = level
        self.cellLevel = cellLevel
    }
    
    func soundEffect(filename: String, ext: String) {
        
        //Voice settings
        do {
            //try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            //audioPlayer = AVAudioPlayer()
            //_print(audioPlayer as Any)
        } catch {
            _print("Voice setting error:\(error.localizedDescription) and \(error)")
        }
        //
        
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


extension UIView {
    func roundedTop(_ radius: CGFloat) {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight, .topLeft],
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func dropShadow(shadowColor: UIColor = UIColor.black,
                    fillColor: UIColor = UIColor.white,
                    opacity: Float = 0.2,
                    offset: CGSize = CGSize(width: 0.0, height: 5.0),
                    radius: CGFloat = 10) -> CAShapeLayer {
        
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        layer.insertSublayer(shadowLayer, at: 0)
        return shadowLayer
    }
}

// Defined by Tim on August 6, 2020
public var _screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
public var _screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

extension UIViewController {
    func popupAlert(msg: String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in
            print("OK")
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) {
            (action: UIAlertAction) in
            print("Cancel")
        }
        //alert.addAction(action1)
        alert.addAction(action1)
        self.present(alert, animated: true, completion: nil)
    }
}


