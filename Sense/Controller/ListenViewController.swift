//
//  ListenViewController.swift
//  Sense
//
//  Created by Bob Yuan on 2020/1/2.
//  Copyright © 2020 Bob Yuan. All rights reserved.
//

import UIKit
import AVFoundation


class ListenViewController: UIViewController {
    
    
    @IBOutlet var autoLayout: [NSLayoutConstraint]!
    
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var secondLabelH: NSLayoutConstraint!
    @IBOutlet weak var ansLabelH: NSLayoutConstraint!
    @IBOutlet weak var firstLabelH: NSLayoutConstraint!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var ansLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var numLabel1: UILabel!
    @IBOutlet weak var numLabel2: UILabel!
    @IBOutlet weak var numLabel3: UILabel!
    
    var hopH: CGFloat = 20 //Hiphop Height
    
    var isPaused = true
    var level: Int = 1
    var stop: Bool = false
    var cellLevel: Int = 1
    
    let prefix = "progression"
    let progressions = ["1_1", "1_2", "1_3", "2_1", "2_2", "2_3"]
    
    var bigIndex = 0
    var index = 0
    let timestamps = [0.0000, 2.0443, 4.0907+0.3, 6.1350+0.4, 8.1814+0.4, 10.2258+0.6, 13.0221+0.1, 15.0665+0.2, 17.1129+0.2, 19.1572+0.4, 21.2036]
    
    let customFont = UIFont(name: "DK Cool Crayon", size: UIFont.labelFontSize)
    
    // Only for iPad by Tim on August 6, 2020
    func _autoLayout()
    {
        _print("_autoLayout:\(_screenHeight)")
        
        if _screenHeight < 1000 { return } //iPad only
        
        for c in autoLayout {
            _print(c.identifier as Any)
            _print(c.constant)
            switch c.identifier {
                case "$dS1nListen$": //100
                    if _screenHeight > 1000 { c.constant = 30 }
                    if _screenHeight > 1200 { c.constant = 80 }
                    if _screenHeight > 1300 { c.constant = 100 }
                    //c.constant = CGFloat(Int(_screenHeight * (50/1366)))
                    _print(c.constant)
                case "$dSnSlider$": //-10
                    c.constant = -10
                    _print(c.constant)
                case "$1label$": //61
                    c.constant = hopH + 1
                    _print(c.constant)
                case "$2label$": //61
                    c.constant = hopH + 1
                    _print(c.constant)
                case "$3label$": //61
                    c.constant = hopH + 1
                    _print(c.constant)
                default: break
            }
        }
    }
    
    @IBAction func onSlide(_ sender: UISlider) {
        slider.value = roundf(slider.value)
        level = Int(slider.value)
        cellLevel = level
        firstLabel.text = level.asWord
        secondLabel.text = cellLevel.asWord
        ansLabel.text = (level*cellLevel).asWord
        
        playButton.setImage(UIImage(named: "Play"), for: .normal)
        isPaused = true
        audioPlayer?.stop()
        //_print("---\(audioPlayer.currentTime)")
        audioPlayer?.currentTime = TimeInterval(self.timestamps[self.index] + Double(bigIndex))
        //_print("time: \(audioPlayer.currentTime) and bigIndex:\(Double(bigIndex))")
        stop = true
        firstLabel.layer.removeAllAnimations()
        secondLabel.layer.removeAllAnimations()
        ansLabel.layer.removeAllAnimations()
    }
    
    
    @IBAction func playPressed(_ sender: UIButton) {
        
        if audioPlayer == nil { return }
        
        if isPaused == true {
            playButton.setImage(UIImage(named: "Pause"), for: .normal)
            isPaused = false
            stop = false
            //_print("CURRENT: \(audioPlayer.currentTime)")
            audioPlayer?.play()
            looper()
        }
        else {
            playButton.setImage(UIImage(named: "Play"), for: .normal)
            isPaused = true
            audioPlayer?.stop()
            //_print("---\(audioPlayer.currentTime)")
            audioPlayer?.currentTime = TimeInterval(self.timestamps[self.index] + Double(bigIndex))
            //_print("time: \(audioPlayer.currentTime) and bigIndex:\(Double(bigIndex))")
            stop = true
            firstLabel.layer.removeAllAnimations()
            secondLabel.layer.removeAllAnimations()
            ansLabel.layer.removeAllAnimations()
            
        }
        
    }
    
    
    func looper() {
        //while level < 9 {
            if isPaused == false { //To be playing...
                
                if cellLevel > 9 && level > 8 {
                    audioPlayer?.stop()
                    
                    audioPlayer?.currentTime = 0
                    slider.value = 1
                    level = 1
                    cellLevel = 1
                    bigIndex = 0
                    index = 0
                    stop = true
                }

                if cellLevel > 9 {
                    level += 1
                    cellLevel = level
                    slider.value = Float(level)
                }
                if level > 9 {
                    _print("done")
                }
                        
                firstLabel.text = level.asWord
                secondLabel.text = cellLevel.asWord
                ansLabel.text = (level*cellLevel).asWord
                numLabel1.text = String(level)
                numLabel2.text = String(cellLevel)
                numLabel3.text = String(level*cellLevel)
                
                cellLevel += 1
                index += 1
                
                if index == 11 {
                    switch bigIndex {
                    case 0:
                        bigIndex = 24
                    case 24:
                        bigIndex = 48
                    case 48:
                        bigIndex = 72
                    case 72:
                        bigIndex = 96
                    case 96:
                        bigIndex = 0
                    default: break
                        
                    }
                    index = 0
                }
                
                if stop == false {
                    
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
                     
                        self.firstLabelH.constant -= self.hopH //20
                        self.view.layoutIfNeeded()
                        
                        //_print(self.firstLabel.constraints) //don't print here?
                        
                        //self.firstLabel.frame = CGRect(x: self.firstLabel.frame.origin.x, y: self.firstLabel.frame.origin.y - 20, width: self.firstLabel.frame.width, height: self.firstLabel.frame.height)
                        
                            }) { (complete) in
                                

                                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
                                    
                                    //self.firstLabel.frame = CGRect(x: self.firstLabel.frame.origin.x, y: self.firstLabel.frame.origin.y + 20, width: self.firstLabel.frame.width, height: self.firstLabel.frame.height)
                                    
                                    self.firstLabelH.constant += self.hopH //20
                                    self.view.layoutIfNeeded()
                                    
                                })
                            }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if self.stop == false{
                        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
                                //self.secondLabel.frame = CGRect(x: self.secondLabel.frame.origin.x, y: self.secondLabel.frame.origin.y - 20, width: self.secondLabel.frame.width, height: self.secondLabel.frame.height)
                            self.secondLabelH.constant -= self.hopH //20
                            self.view.layoutIfNeeded()
                                
                            }) { (complete) in
                                
                                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
                                    //self.secondLabel.frame = CGRect(x: self.secondLabel.frame.origin.x, y: self.secondLabel.frame.origin.y + 20, width: self.secondLabel.frame.width, height: self.secondLabel.frame.height)
                                    self.secondLabelH.constant += self.hopH //20
                                    self.view.layoutIfNeeded()
                                })
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    if self.stop == false {
                                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
                                        //self.ansLabel.frame = CGRect(x: self.ansLabel.frame.origin.x, y: self.ansLabel.frame.origin.y - 20, width: self.ansLabel.frame.width, height: self.ansLabel.frame.height)
                                        self.ansLabelH.constant -= self.hopH //20
                                        self.view.layoutIfNeeded()
                                        
                                    }) { (complete) in
                                            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
                                                //self.ansLabel.frame = CGRect(x: self.ansLabel.frame.origin.x, y: self.ansLabel.frame.origin.y + 20, width: self.ansLabel.frame.width, height: self.ansLabel.frame.height)
                                                self.ansLabelH.constant += self.hopH //20
                                                self.view.layoutIfNeeded()
                                            
                                        })
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.15) {
                                                
                                                if self.level < 9 {
                                                    self.looper()
                                                }
                                                else { //if self.level > 9 {
                                                    
                                                    audioPlayer?.stop()
                                                
                                                    audioPlayer?.currentTime = TimeInterval(self.timestamps[self.index] + Double(self.bigIndex))
                                                    _print(self.level)
                                                    _print(self.cellLevel)
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                    }
                }
            }
        //}
    }
    override func viewWillLayoutSubviews() {
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }

        /*
        firstLabel.font = UIFontMetrics.default.scaledFont(for: customFont!)
        secondLabel.font = UIFontMetrics.default.scaledFont(for: customFont!)
         */
   
        //Tim
        //_print("Listen viewDidLoad:")
        //_print(stackView.frame.origin.y)
        //_print(firstLabel.frame.origin.y)
        //_print("Listen viewDidLoad constraints: \(stackView.constraints)")
        
        
        //firstLabel.adjustsFontForContentSizeCategory = true
        //secondLabel.adjustsFontForContentSizeCategory = true
        //ansLabel.adjustsFontForContentSizeCategory = true
        
        if _screenHeight > 1000 { //iPad only
            hopH = CGFloat(Int(_screenHeight * (60/1366)))
            _print("hopH:\(hopH)")
            _autoLayout()
        }
        else {
            hopH = 30
        }
            
        
        firstLabel.text = "one"
        secondLabel.text = "one"
        ansLabel.text = "one"
        numLabel1.text = "1"
        numLabel2.text = "1"
        numLabel3.text = "1"
        slider.value = 1
         
    }
    override func viewDidAppear(_ animated: Bool) {
        if let url = Bundle.main.url(forResource: "Sense1", withExtension: "wav"){
            
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            
            if audioPlayer == nil {
                _print("!!!Error in calling AVAudioPlayer().")
            }
            
            _print("play....")
            audioPlayer?.prepareToPlay()
            

        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if audioPlayer == nil { return }
        
        playButton.setImage(UIImage(named: "Play"), for: .normal)
        isPaused = true
        audioPlayer?.stop()
        //_print("viewDidDisappear---\(audioPlayer.currentTime)")
        audioPlayer?.currentTime = TimeInterval(self.timestamps[self.index] + Double(bigIndex))
        //_print("viewDidDisappear time: \(audioPlayer.currentTime) and bigIndex:\(Double(bigIndex))")
        stop = true
        firstLabel.layer.removeAllAnimations()
        secondLabel.layer.removeAllAnimations()
        ansLabel.layer.removeAllAnimations()
        
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
