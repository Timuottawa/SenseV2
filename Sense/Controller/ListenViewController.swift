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

class ListenViewController: UIViewController, AVAudioPlayerDelegate{
    
    
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
    
    @IBOutlet weak var recIsEnabled: UISwitch!
    
    var audioPlayersRecorded = [AVAudioPlayer?](repeating: nil, count: 10)
    
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
    
    var loopA: Int = 1
    var loopB: Int = 9
    var loopIsEnable = true
    
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
                
                //For loopPlaying  !!!!!!!!!!!!!!!!!!
                if loopIsEnable == true && self.level == self.loopB && self.cellLevel == 9 {
                   _print("looping....!!!!!!!!!!!! - 1 ")

                    self.level = loopA
                    self.cellLevel = loopA
                    StopPlay_and_SetCurrentTime()
                    
                    //"Ugly", just for playing 9 x 9 = 81 for only one time, see Ugly above!
                    if level == 9 {
                        cellLevel = 0
                    }//end of "Ugly"
                    
                    setPlay()
                    
                   _print("looping....!!!!!!!!!!!! - 2 ")
                    return
                }
                //end of loopPlaying
                
                if self.level == 9 && self.cellLevel == 9 { //See "Ugly" below
                    setStop()
                    return
                }
                //
                if level >= 5 && i < 10 {
                    level = _cell[i].0
                    cellLevel = _cell[i].1
                    setLabels()
                   _print("1:", level, cellLevel)
                    
                }
                else {
                    level = cell[i].0
                    cellLevel = cell[i].1
                    setLabels()
                   _print("2:", level, cellLevel)
                }
                
                //tim
                if level == cellLevel {
                    let _level = level
                    DispatchQueue.main.asyncAfter(deadline: .now() ) {
                       _print("starting level x playing...", _level)
                        self.audioPlayersRecorded[_level]?.currentTime = 0.0
                        
                        if !self.recIsEnabled.isOn {
                            self.audioPlayersRecorded[_level]?.volume = 0
                        }
                        else {
                            self.audioPlayersRecorded[_level]?.volume = 3
                        }
                        
                        self.audioPlayersRecorded[_level]?.play()
                    }
                }
                //
                
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
    //Stopping and setting start time points for each tone
    func StopPlay_and_SetCurrentTime()
    {
        var cT = audioPlayer!.currentTime
        let _toneStartingTimeInde: [Int] = [0, 0, 9, 17, 24, 30, 0, 4, 7, 9]
        
        if level <= 0 || level >= 10 || cellLevel <= 0 || cellLevel >= 10 {
            _print("Error in level or cellLevel !!!")
            return
        }
        
        //Stop first and set then
        setStop()
        
        cT = toneTimestamps[ _toneStartingTimeInde[level] + cellLevel - level ]

        audioPlayer!.currentTime = TimeInterval(cT) + 0.05 //Just add 0.05 here to avoid audioPlayer's bugs!!!
        
        toneCurrentIndex = -1 //Init toneCurrentIndex
        
        //tim
        let delta = cT - toneTimestamps[ _toneStartingTimeInde[level] ]
        audioPlayersRecorded[level]?.currentTime = TimeInterval(delta) + 0.05
        //
        
    }
    //Slide pressed
    @IBAction func onSlide(_ sender: UISlider) {
        
       _print("onSlide...")
        
        slider.value = roundf(slider.value)
        level = Int(slider.value)
        cellLevel = level

        StopPlay_and_SetCurrentTime()
    }
    //Starting to play
    func setPlay() {
        playButton.setImage(UIImage(named: "Pause"), for: .normal)
        isPaused = false
        stop = false
        
        audioPlayer?.play()
        
        //tim
        _print("setPlay---level:", level)
        
        if !self.recIsEnabled.isOn {
            self.audioPlayersRecorded[level]?.volume = 0
        }
        else {
            self.audioPlayersRecorded[level]?.volume = 3
        }
        
        audioPlayersRecorded[level]?.play()
        //
        
        createDisplayLinkTimer()
    }
    //Stopping
    func setStop() {
        playButton.setImage(UIImage(named: "Play"), for: .normal)
        isPaused = true
        audioPlayer?.stop()
        
        //tim
        audioPlayersRecorded[level]?.stop()
        
        if level <= 8 { audioPlayersRecorded[level+1]?.stop() }
        if level >= 2 { audioPlayersRecorded[level-1]?.stop() }
        //
        
        stop = true
        
        killDisplayLinkTimer()
        
        setLabels()

    }
    //Play pressed
    @IBAction func playPressed(_ sender: UIButton) {
        if audioPlayer == nil { return }

        if isPaused == true {
            StopPlay_and_SetCurrentTime()
          
            //"Ugly", just for playing 9 x 9 = 81 for only one time, see Ugly above!
            if level == 9 {
                cellLevel = 0
            }
            setPlay()
        }
        else {
            StopPlay_and_SetCurrentTime()
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

            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            //try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)

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
        
         //doubleSlider_viewDidLoad()
        
    }
    func setupAudioPlayer() {
         if let url = Bundle.main.url(forResource: "Sense3", withExtension: "wav"){
             
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 //loop infinitely
            if audioPlayer == nil {
                _print("!!!Error in calling AVAudioPlayer().")
            }
             
            _print("play....")
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 0.7
         }
     }
    
     
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        
         _print("Listen viewDidAppear---\(audioPlayer?.currentTime as Any)")
         setupAudioPlayer()
        
        //
        openRecordedFiles()
     }
     
    func openRecordedFiles() {
        
        for i in 1...9 {
            let url = URL(fileURLWithPath: _file_path! + String(i)+".wav")
            audioPlayersRecorded[i] = try? AVAudioPlayer(contentsOf: url)
            
            audioPlayersRecorded[i]?.numberOfLoops = 0
            audioPlayersRecorded[i]?.volume = 3
            if audioPlayersRecorded[i] == nil {
                _print("null recorded file for Level: ", i)
            }
            audioPlayersRecorded[i]?.prepareToPlay()
            audioPlayersRecorded[i]?.delegate = self
        }
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        _print("Listen: didFinishPlaying?")
        _print("Listen finishPlaying Level: ", level, cellLevel)
        
        player.stop()
        player.currentTime = 0.0
        
    }

     override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         if audioPlayer == nil { return }
         setStop()
         _print("Listen viewDidDisappear---\(audioPlayer?.currentTime as Any)")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        doubleSlider_viewDidLoad()
        _print("Listen viewWillAppear---")
    }
    
    //Loop for only one tone
    func _looperOne() {
       _print("loopOne....")
       _print("loopOne 1:", audioPlayer?.currentTime as Any)
       _print("loopOne 1:", toneCurrentIndex)
        
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
                                   _print("loopOne 2:", audioPlayer?.currentTime as Any)
                                    }
                                }
                            }
                    }
                }
        } //end +++2
        //------------------------------------------------------------
        
       _print("LoopOne end.")
    }//end for func _looperOne()
    
    //
    //Double Sliders
    //https://github.com/anonymity-du/DoubleSliderView-swift/blob/master/DoubleSliderView/DoubleSliderView/ViewController.swift
    //
    //
            var minLevel: Int = 1
            var maxLevel: Int = 9
            var curMinLevel: Int = 1
            var curMaxLevel: Int = 9
            var doubleSliderY: CGFloat = 0
            var doubleSliderX: CGFloat = 0
            let loopButton = UIButton()
            
    
            
        
            
            func doubleSlider_viewDidLoad() {
                
                
                doubleSliderY = playButton.frame.maxY + 40 //???  Should change to relative distance
                doubleSliderX = 52  //???
                
                self.view.addSubview(self.levelLabel)
                self.view.addSubview(self.levelTipsLabel)
                self.view.addSubview(self.doubleSliderView)
                
                self.levelLabel.centerY = doubleSliderY - 20
                self.levelLabel.x = doubleSliderX
                
                self.levelTipsLabel.centerY = self.levelLabel.centerY
                self.levelTipsLabel.x = self.levelLabel.right + 7
          
                self.doubleSliderView.x = doubleSliderX
                self.doubleSliderView.y = doubleSliderY - 10 + 20
                
                // Do any additional setup after loading the view, typically from a nib.
                
                //
                //tim
                loopA = curMinLevel
                loopB = curMaxLevel
                //
                //
                loopButton.setImage(UIImage(named: "Loop"), for: .normal)
                loopButton.frame = CGRect(x: doubleSliderX - 10 , y: levelTipsLabel.y - 21, width: 60, height: 60)
                view.addSubview(loopButton)
                view.bringSubviewToFront(loopButton)
                loopButton.addTarget(self, action: #selector(loopButtonPressed), for: .touchUpInside)
                
            
            }
    
            
            @objc private func loopButtonPressed()
            {
                if loopIsEnable == true {
                    loopIsEnable = false
                    doubleSliderView.isHidden = true
                    levelTipsLabel.text = "  0 "
                }
                else {
                    loopIsEnable = true
                    doubleSliderView.isHidden = false
                    levelTipsLabel.text = "\(self.curMinLevel)~\(self.curMaxLevel)"
                }
            }
    
            
            //MARK: - private func
            //根据值获取整数
            private func fetchInt(from value: CGFloat) -> CGFloat {
                var newValue: CGFloat = floor(value)
                let changeValue = value - newValue
                if changeValue >= 0.5 {
                    newValue = newValue + 1
                }
                return newValue
            }

            private func sliderValueChangeAction(isLeft: Bool, finish: Bool) {
                if isLeft {
                    let _level = CGFloat(self.maxLevel - self.minLevel) * self.doubleSliderView.curMinValue
                    let tmpLevel = self.fetchInt(from: _level)
                    self.curMinLevel = Int(tmpLevel) + self.minLevel
                    self.changeLevelTipsText()
                    //
                    //tim
                    loopA = curMinLevel
                    slider.value = Float(loopA)
                    level = loopA
                    cellLevel = level
                    StopPlay_and_SetCurrentTime()
                    //
                    //
                }else {
                    let _level = CGFloat(self.maxLevel - self.minLevel) * self.doubleSliderView.curMaxValue
                    let tmpLevel = self.fetchInt(from: _level)
                    self.curMaxLevel = Int(tmpLevel) + self.minLevel
                    self.changeLevelTipsText()
                    //
                    //tim
                    loopB = curMaxLevel
                    //
                    loopA = curMinLevel
                    slider.value = Float(loopA)
                    level = loopA
                    cellLevel = level
                    StopPlay_and_SetCurrentTime()
                    //
                    //
                    //
                }
                if finish {
                    self.changeSliderValue()
                }
            }
            //值取整后可能改变了原始的大小，所以需要重新改变滑块的位置
            private func changeSliderValue() {
                let finishMinValue = CGFloat(self.curMinLevel - self.minLevel)/CGFloat(self.maxLevel - self.minLevel)
                let finishMaxValue = CGFloat(self.curMaxLevel - self.minLevel)/CGFloat(self.maxLevel - self.minLevel)
                self.doubleSliderView.curMinValue = finishMinValue
                self.doubleSliderView.curMaxValue = finishMaxValue
                self.doubleSliderView.changeLocationFromValue()
            }
            
            private func changeLevelTipsText() {
                if self.curMinLevel == self.curMaxLevel {
                    self.levelTipsLabel.text = "\(self.curMinLevel)"
                }else {
                    self.levelTipsLabel.text = "\(self.curMinLevel)~\(self.curMaxLevel)"
                }
                self.levelTipsLabel.sizeToFit()
                self.levelTipsLabel.centerY = self.levelLabel.centerY
                self.levelTipsLabel.x = self.levelLabel.right + 7
            }
            
            //MARK:- setter & getter
            private lazy var levelLabel: UILabel = {
                let label = UILabel.init()
                label.textColor = UIColor.white
                label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                label.text = ""
                label.sizeToFit()
                return label
            }()
            
            private lazy var levelTipsLabel: UILabel = {
                let label = UILabel.init()
                label.textColor = UIColor.white
                label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                label.text = "\(self.minLevel)~\(self.maxLevel)"
                label.sizeToFit()
                return label
            }()
            
            private lazy var doubleSliderView: DoubleSliderView = {
                let view = DoubleSliderView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width - 52 * 2, height: 35 + 20))
                view.needAnimation = true
                //if self.maxLevel > self.minLevel {
                //    view.minInterval = 4.0/CGFloat(self.maxLevel - self.minLevel)
                //}
                view.sliderBtnLocationChangeBlock = { [weak self] isLeft,finish in
                    self?.sliderValueChangeAction(isLeft: isLeft, finish: finish)
                }
                return view
            }()
    
}//end for class

