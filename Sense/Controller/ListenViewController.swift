//
//  ListenViewController.swift
//  Sense
//
//  Created by Bob Yuan on 2020/1/2.
//  Modified by Tim on 2020/08/19
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
    var level: Int = 0
    var stop: Bool = false
    var cellLevel: Int = 1
    
    let prefix = "progression"
    let progressions = ["1_1", "1_2", "1_3", "2_1", "2_2", "2_3"]
    
    let timestamps = [0.0000, 2.0443, 4.0907+0.3, 6.1350+0.4, 8.1814+0.4, 10.2258+0.6, 13.0221+0.1, 15.0665+0.2, 17.1129+0.2, 19.1572+0.4, 21.2036]
    
    let customFont = UIFont(name: "DK Cool Crayon", size: UIFont.labelFontSize)
 
    //---------------------------------
    var toneCurrentIndex: Int = -1
    let toneTimestamps = [
                            0.0, 2.0, 4.21, 6.33, 8.48, 10.6, 12.9, 15.012, 17.27,
                            19.42, 21.48, 23.66, 26.06, 28.00, 30.33, 32.45, 34.66,
                            37.00, 39.015, 41.027, 43.42, 45.54, 47.69, 50.066,
                            52.021001, 54.33, 56.48, 58.63, 61.00, 63.039,
                            65.022, 67.42, 69.57, 71.69, 74.066,
                            76
                         ]
    
    let cell = [
                    (1,1), (1,2), (1,3), (1,4), (1,5), (1,6), (1,7), (1,8), (1,9),
                    (2,2), (2,3), (2,4), (2,5), (2,6), (2,7), (2,8), (2,9),
                    (3,3), (3,4), (3,5), (3,6), (3,7), (3,8), (3,9),
                    (4,4), (4,5), (4,6), (4,7), (4,8), (4,9),
                    (5,5), (5,6), (5,7), (5,8), (5,9)
               ]
    
    let _cell = [
                    (6,6), (6,7), (6,8), (6,9),
                    (7,7), (7,8), (7,9),
                    (8,8), (8,9),
                    (9,9)
                ]
    //---------------------------------
    
    //Setting all Labels inlcuding slider's, and stop all animations
    func setLabels(){
        slider.value = Float(level)
        firstLabel.text = level.asWord
        secondLabel.text = cellLevel.asWord
        ansLabel.text = (level*cellLevel).asWord
        numLabel1.text = String(level)
        numLabel2.text = String(cellLevel)
        numLabel3.text = String(level*cellLevel)
        
        firstLabel.layer.removeAllAnimations()
        secondLabel.layer.removeAllAnimations()
        ansLabel.layer.removeAllAnimations()
        self.view.layoutIfNeeded()
        
    }
    
    //Setting each Tone, for example, 1 x 1 = 1 for one tone.
    func setCurrentTone() {
        //print("setCurrentTone:", audioPlayer?.currentTime as Any )
        let cT = audioPlayer!.currentTime as Double
        //print("setCurrentTone cT: ", cT )
        
        for i in 0...(toneTimestamps.count-2) {
            // Init  toneCurrentIndex in  func setCurrentTime()
            if toneCurrentIndex != i && cT >= toneTimestamps[i] && cT < toneTimestamps[i+1] {
                toneCurrentIndex = i;
                
                //print("setCurrentTone cT: ", cT )
                
                if self.level == 9 && self.cellLevel == 9 { //See Ugly below
                    setStop()
                    return
                }
                //
                if level >= 5 && i < 10 {
                    level = _cell[i].0
                    cellLevel = _cell[i].1
                    setLabels()
                    //print("1:", level, cellLevel)
                    
                }
                else {
                    level = cell[i].0
                    cellLevel = cell[i].1
                    setLabels()
                    //print("2:", level, cellLevel)
                }
                
                //Loop for only one tone
                _looperOne()
                
                return
            }
        }//end for
    }
    
    //A timer for sync each tone
    var displayLinkTimer: CADisplayLink?
    @objc func _dL_update(sender: CADisplayLink) {
        
        if audioPlayer != nil && stop == false && isPaused == false  && audioPlayer?.isPlaying == true{
            setCurrentTone()
        }

    }
    func createDisplayLinkTimer() {
        displayLinkTimer = CADisplayLink(target: self, selector: #selector(_dL_update))
        displayLinkTimer?.add(to: .main, forMode: .default)
    }
    func killDisplayLinkTimer() {
        displayLinkTimer?.invalidate()
    }
         

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
    //Setting start time points for each tone
    func setCurrentTime()
    {
        var cT = audioPlayer!.currentTime

        //Need change to swich...case... or a formula?
        if level == 1 {
            cT = toneTimestamps[0+cellLevel-level]
        }
        else if level == 2 {
            cT = toneTimestamps[9+cellLevel-level]
        }
        else if level == 3 {
            cT = toneTimestamps[17+cellLevel-level]
        }
        else if level == 4 {
            cT = toneTimestamps[24+cellLevel-level]
        }
        else if level == 5 {
            cT = toneTimestamps[30+cellLevel-level]
        }
        else if level == 6 {
            cT = toneTimestamps[0+cellLevel-level]
        }
        else if level == 7 {
            cT = toneTimestamps[4+cellLevel-level]
        }
        else if level == 8 {
            cT = toneTimestamps[7+cellLevel-level]
        }
        else if level == 9 {
            cT = toneTimestamps[9+cellLevel-level]
        }
        
        audioPlayer!.currentTime = TimeInterval(cT) + 0.05 //Just add 0.05 here to avoid audioPlayer's bugs!!!
        
        toneCurrentIndex = -1 //Init toneCurrentIndex
        
    }
    //Slide pressed
    @IBAction func onSlide(_ sender: UISlider) {
        
        print("onSlide...")
        
        slider.value = roundf(slider.value)
        level = Int(slider.value)
        cellLevel = level

        setCurrentTime()
        
        setStop()

    }
    //Starting to play
    func setPlay() {
        playButton.setImage(UIImage(named: "Pause"), for: .normal)
        isPaused = false
        stop = false
        
        audioPlayer?.play()
        createDisplayLinkTimer()
    }
    //Stopping
    func setStop() {
        playButton.setImage(UIImage(named: "Play"), for: .normal)
        isPaused = true
        audioPlayer?.stop()
        stop = true
        
        killDisplayLinkTimer()
        
        setLabels()
    }
    //Play pressed
    @IBAction func playPressed(_ sender: UIButton) {
        if audioPlayer == nil { return }

        if isPaused == true {
            setCurrentTime()
          
            //Ugly, just for playing 9 x 9 = 81 for only one time, see Ugly above!
            if level == 9 {
                cellLevel = 0
            }
            setPlay()
        }
        else {
            setCurrentTime()
            setStop()
        }
    }
    override func viewDidLoad() {
         super.viewDidLoad()
         if #available(iOS 13.0, *) {
             overrideUserInterfaceStyle = .light
         } else {
             // Fallback on earlier versions
         }
         
         //Voice settings
         do {

             try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
             try AVAudioSession.sharedInstance().setActive(true)

         } catch {
             _print("Voice setting error:\(error.localizedDescription) and \(error)")
         }
         //
        
         if _screenHeight > 1000 { //iPad only
             hopH = CGFloat(Int(_screenHeight * (60/1366)))
             _print("hopH:\(hopH)")
             _autoLayout()
         }
         else {
             hopH = 30
         }
             
         level = 1
         cellLevel = 1
         setLabels()
    }
    func setupAudioPlayer() {
         if let url = Bundle.main.url(forResource: "Sense3", withExtension: "wav"){
             
             audioPlayer = try? AVAudioPlayer(contentsOf: url)
             audioPlayer?.numberOfLoops = 2
             if audioPlayer == nil {
                 _print("!!!Error in calling AVAudioPlayer().")
             }
             
             _print("play....")
             audioPlayer?.prepareToPlay()
         }
     }
     
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         setupAudioPlayer()
     }
     

     override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         if audioPlayer == nil { return }
         setStop()
         _print("viewDidDisappear---\(audioPlayer?.currentTime as Any)")
    }
    
    //Loop for only one tone
    func _looperOne() {
        print("loopOne....")
        print("loopOne 1:", audioPlayer?.currentTime as Any)
        print("loopOne 1:", toneCurrentIndex)
        
        firstLabel.layer.removeAllAnimations()
        secondLabel.layer.removeAllAnimations()
        ansLabel.layer.removeAllAnimations()
        //------------------------------------------------------------
        if stop == false { // 1---
               
               UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
                
                   self.firstLabelH.constant -= self.hopH //20
                   self.view.layoutIfNeeded()
    
                       }) { (complete) in
                           UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
                               self.firstLabelH.constant += self.hopH //20
                               self.view.layoutIfNeeded()
                               
                           })
                       }
           } //end +++1
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // 2---
                if self.stop == false{
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {

                        self.secondLabelH.constant -= self.hopH //20
                        self.view.layoutIfNeeded()
                            
                        }) { (complete) in
                            
                            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {

                                self.secondLabelH.constant += self.hopH //20
                                self.view.layoutIfNeeded()
                            })
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if self.stop == false {
                                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {

                                    self.ansLabelH.constant -= self.hopH //20
                                    self.view.layoutIfNeeded()
                                    
                                }) { (complete) in
                                        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {

                                            self.ansLabelH.constant += self.hopH //20
                                            self.view.layoutIfNeeded()
                                        
                                    })
                                   //Just do nothing!
                                    print("loopOne 2:", audioPlayer?.currentTime as Any)
                                    }
                                }
                            }
                    }
                }
        } //end +++2
        //------------------------------------------------------------
        
        print("LoopOne end.")
    }//end for func _looperOne()
    
}//end for class



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
