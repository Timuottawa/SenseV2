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


let _file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,                true).first?.appending("/_sense_record_")


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
        //alert.addAction(action2)
        alert.addAction(action1)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    
    func smooth(count : Float = 4,for duration : TimeInterval = 0.5,withTranslation translation : Float = 5) {
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
    }
}

public extension Int {
  var asWord: String   {
    let numberValue = NSNumber(value: self)
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    return formatter.string(from: numberValue)!
  }
}

//From https://github.com/anonymity-du/DoubleSliderView-swift/blob/master/DoubleSliderView/DoubleSliderView/UIView%2BExtension.swift

enum OscillatoryAnimationType {
    case bigger
    case smaller
}

extension UIView{
    var x : CGFloat {
        get {
            return frame.origin.x
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    var y : CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    var width : CGFloat {
        get {
            return frame.size.width
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    var height : CGFloat {
        get {
            return frame.size.height
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    
    var centerX : CGFloat {
        get {
            return center.x
        }
        set {
            var tempCenter : CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    var centerY : CGFloat {
        get {
            return center.y
        }
        set {
            var tempCenter : CGPoint = center
            tempCenter.y = newValue
            center = tempCenter
        }
    }
    var size : CGSize {
        get {
            return frame.size
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    var right : CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.x = newValue - frame.size.width
            frame = tempFrame
        }
    }
    
    var bottom : CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.y = newValue - frame.size.height
            frame = tempFrame
        }
    }
}

