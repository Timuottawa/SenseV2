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


class RecordViewController: UIViewController, AVAudioPlayerDelegate {
    
    
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
    
    var audioPlayersRecording = [AVAudioPlayer?](repeating: nil, count: 10)
    
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
                
                //if self.level == 9 && self.cellLevel == 9 { //See "Ugly" below
                if self.cellLevel == 9 { //See "Ugly" below
                    if let _player = player {
                        if _player.isPlaying == true {
                            _print("!!!!!!! Waiting to playing finished !!!!!!");
                            //In order to run audioPlayDidFinished() to save voice just recorded.
                            return
                        }
                    }
                    _print("!!!!!!! Playing finished !!!!!!")
                    slider.value = roundf(slider.value)
                    level = Int(slider.value)
                    cellLevel = level
                    StopPlay_and_SetCurrentTime()
                    //
                    if isRecording == true {
                        //正常：录音完成后停止
                        isRecordingSucess = true
                        stopRecord()
                        isRecordingSucess = false
                    }
                    //
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
        player?.currentTime = TimeInterval(delta) + 0.05
        //
        
    }
    //Slide pressed
    @IBAction func onSlide(_ sender: UISlider) {
        
       _print("onSlide...")
        
        slider.value = roundf(slider.value)
        level = Int(slider.value)
        cellLevel = level

        StopPlay_and_SetCurrentTime()
        
        if isRecording == true {
            stopRecord()
        }
    }
    //Starting to play
    func setPlay() {
        playButton.setImage(UIImage(named: "Pause"), for: .normal)
        isPaused = false
        stop = false
        
        audioPlayer?.play()
        //tim
        player?.play()
        //
        
        createDisplayLinkTimer()
    }
    //Stopping
    func setStop() {
        playButton.setImage(UIImage(named: "Play"), for: .normal)
 
        audioPlayer?.stop()
        
        //tim
        player?.stop()
        
        isPaused = true
        stop = true
        
        killDisplayLinkTimer()
        
        setLabels()
    }
    func playBackgroundMusic() {
        if audioPlayer == nil { return }

        if isPaused == true {
            StopPlay_and_SetCurrentTime()
          
            //"Ugly", just for playing 9 x 9 = 81 for only one time, see Ugly above!
            if level == 9 {
                cellLevel = 0
            }
            isPaused = false
            stop = false
             
            audioPlayer?.play()
            createDisplayLinkTimer()
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

            //try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
            //try AVAudioSession.sharedInstance().setActive(true)
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
             audioPlayer?.volume = 0.5
         }
     }
     
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        
         _print("RecordviewDidAppear---\(audioPlayer?.currentTime as Any)")
         setupAudioPlayer()
     }
     

     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
        
        if audioPlayer == nil { return }
        if isRecording == true {
            isSaved[level] = true //正在录音中退出界面不用提醒保存
            stopRecord()
        }
        setStop()
         
        _print("RecordviewWillDisappear---\(audioPlayer?.currentTime as Any)")
        
        
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
    
    
    var rRightStatus: AVAuthorizationStatus?
    func checkAuthoriztion(){
        
        rRightStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)

        if rRightStatus == .notDetermined {
            _print("Not determined")
        }
        if rRightStatus == .restricted
        {
            _print("Restricted")
        }
        if rRightStatus == .denied {
            _print("Denied")
        }
        if rRightStatus == .authorized {
            _print("Authorized")
            return
        }
        // 获取麦克风权限
        AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted: Bool) -> Void in
            if(!granted){
                //没有授权
                self.rRightStatus  = AVAuthorizationStatus.restricted
                _print("Restricted!")
            }
            else {
                self.rRightStatus = AVAuthorizationStatus.authorized
                _print("Granted!")
            }
        })

    }
    
    //开始录音
    @IBOutlet weak var recordButton: UIButton!
    var recorder: AVAudioRecorder?
    var isRecording: Bool = false
    
    @IBAction func startRecord(_ sender: UIButton) {

        if isRecording == true {
            stopRecord()
            return
        }
        checkAuthoriztion()
        
        /*
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            //, options: AVAudioSession.CategoryOptions.mixWithOthers)
            
        } catch let err{
           _print("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
           _print("初始化动作失败:\(err.localizedDescription)")
        }*/
        
        if isPaused == false {
            isSaved[level] = true //no need to save file
            playButton.sendActions(for: .touchUpInside)
        }
        //Go to the beginning of the Level
        slider.value = roundf(slider.value)
        level = Int(slider.value)
        cellLevel = level
        StopPlay_and_SetCurrentTime()
        
        //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因
        let recordSetting: [
            String: Any] = [AVSampleRateKey: NSNumber(value: 44100.0),//采样率
            AVFormatIDKey: kAudioFormatLinearPCM,//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 2),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.max.rawValue) //录音质量
        ];
        //开始录音
        do {
            let url = URL(fileURLWithPath: _file_path! + String(level) + "_.wav")

            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            
            //tim
            playBackgroundMusic(); //playing background music
            recordButton.setImage(UIImage(named: "Record"), for: .normal)
            //
            
            recorder!.record()
            
            isRecording = true
            _print("开始录音")
        } catch let err {
            _print("录音失败:\(err.localizedDescription)")
        }
    }

    //结束录间
    var isRecordingSucess: Bool = false
    func stopRecord() { //_ sender: UIButton) {
        //结束录音
        _print("stopRecord...")
        if let recorder = self.recorder {
            if recorder.isRecording {
               _print("正在录音，马上结束它，文件保存到了：\(_file_path! + String(level) + "_.wav")")
            }else {
               _print("没有录音，但是依然结束它")
            }
            
            recorder.stop()
            recordButton.setImage(UIImage(named: "Voice"), for: .normal)
            //
            slider.value = roundf(slider.value)
            level = Int(slider.value)
            cellLevel = level
            StopPlay_and_SetCurrentTime()
            //
            
            self.isSaved[level] = false
            
            self.recorder = nil
            
            //Trigger play button
            if isRecordingSucess == true {
               _print("Press Play button...")
                isRecording = false
                playButton.sendActions(for: .touchUpInside)
            }
            
        }else {
           _print("没有初始化")
        }
        isRecording = false
    }


    var isSaved = [Bool](repeating: true, count: 10)
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        _print("didFinishPlaying?")
        player.stop()
              
        //
        slider.value = roundf(slider.value)
        level = Int(slider.value)
        cellLevel = level
        StopPlay_and_SetCurrentTime()
        //
        //是否需要保存？
        
        if isSaved[level] == false {
            saveFile(level)
        }
        isSaved[level] = true
    }
    
    
    func saveFile(_ _level: Int)
    {
     
        //if isSaved[_level] == true { return }
        
        let alert = UIAlertController(title: "", message: "Do you need to save the recorded voice of Level " + String(_level) + "?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Save", style: .default) {
                (action: UIAlertAction) in
               _print("Saving...")
                do{
                    try? FileManager.default.removeItem(atPath: _file_path!+String(_level)+".wav")
                    try FileManager.default.moveItem(atPath: _file_path!+String(_level)+"_.wav", toPath: _file_path!+String(_level)+".wav")
                } catch { _print("Save Error!") }
                _print(_file_path!+String(_level)+".wav")
            }
        let action2 = UIAlertAction(title: "Delete", style: .cancel) {
                (action: UIAlertAction) in
               _print("Deleting...")
                do{
                    try FileManager.default.removeItem(atPath: _file_path!+String(_level)+"_.wav")
                } catch { _print("Delete Error!") }
            }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    var player: AVAudioPlayer?  //for playing recorded voice
    //Play
    
    @IBAction func playRecord(_ sender: UIButton) {

        if isRecording == true {
            return
        }
        
        if audioPlayer == nil { return }
        
        if isPaused == true {
            
            //播放
             do {
                 //let url = Bundle.main.url(forResource: "Sense3", withExtension: "wav")
                 let filePath = _file_path! + String(level) + ".wav"
                 let tempfilePath = _file_path! + String(level) + "_.wav"
                 
                _print(filePath)
                _print(tempfilePath)
                 
                 let tempfileExists = FileManager.default.fileExists(atPath: tempfilePath)
                 
                 if tempfileExists == true {
                     player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: tempfilePath))
                 }
                 else {
                     player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
                     _print("Opening the pre-recorded file...")
                 }
                 _print("歌曲长度：\(player?.duration as Any)")
                 player?.volume = 4
                 player?.delegate = self
                 player?.prepareToPlay()

                 //
                 //playPressed()
                 StopPlay_and_SetCurrentTime()
                 //"Ugly", just for playing 9 x 9 = 81 for only one time, see Ugly above!
                 if level == 9 {
                     cellLevel = 0
                 }
                 setPlay()
                 //
                 //

             } catch let err {
                 _print("播放失败:\(err.localizedDescription)")
             }
           }
           else {
                //save file
                //
                if isSaved[level] == false {
                    _print(audioPlayersRecording[level] as Any)
                    saveFile(level)
                }
                isSaved[level] = true
                //
                //
                StopPlay_and_SetCurrentTime()
           }
       }
       
    
}//end for class RecordViewController

