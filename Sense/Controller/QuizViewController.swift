//
//  QuizViewController.swift
//  Sense
//
//  Created by Bob Yuan on 2020/1/2.
//  Copyright © 2020 Bob Yuan. All rights reserved.
//

import UIKit
import Hero
import ChameleonFramework
import Lottie
import AVFoundation

class QuizViewController: UIViewController {
    
    var top : CGFloat?
    var bottom : CGFloat?
    var half : CGFloat?
    
    var seconds: Int = 0
    var minutes: Int = 0
    
    var screenHeight: CGFloat?
    var screenWidth: CGFloat?
    
    //Final cell height to the scroll view
    let cellH = 70 //Should change to a relative value?
    

    @IBOutlet var stackConstraints: [NSLayoutConstraint]!
    @IBOutlet var congratsConstraints: [NSLayoutConstraint]!
    
    @IBOutlet var proceedConstraints: [NSLayoutConstraint]!
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var stackViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var minuteCounter: UILabel!
    @IBOutlet weak var secondCounter: UILabel!
    
    @IBOutlet weak var secondsTimeLabel: UILabel!
    @IBOutlet weak var congratsView: UIView!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var levelTextLabel: UILabel!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var stackView: UIView!
    
    @IBOutlet weak var littleSymbol: UILabel!
    @IBOutlet weak var quizLabel: UILabel!
    @IBOutlet weak var finalView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropDownView: UIView!
    
    let pulsatingView = AnimationView()
    let largePulsatingView = AnimationView()
    let redPulsatingView = AnimationView()
    
    @IBOutlet var buttons: [UIButton]!
    
    let defaults = UserDefaults.standard
    
    var nTimer = Timer()
    
    var level: Int = 9{
        didSet{
            defaults.setValue(level, forKey: "level")
        }
    }//= gVars.level
    var cellLevel: Int = 9{
        didSet{
            defaults.setValue(cellLevel, forKey: "cellLevel")
        }
    }//= gVars.cellLevel
    var questionsCorrect: Int = 0{
        didSet{
            defaults.setValue(questionsCorrect, forKey: "questionsCorrect")
        }
    }

    var currentView: CellView?
    var latestYCor: CGFloat = 0
    var spacing: CGFloat = 20
    var timesOffsetChanged: CGFloat = 0
    var isWaiting = false
    
    var isFirstClick = true
    
    var snap : UISnapBehavior!
    var animator : UIDynamicAnimator!
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: CGFloat(10*(cellH+20)))
    lazy var normalViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    var pulsatingLayer: CAShapeLayer!
    
    var timer = Timer()
    
    lazy var scrollview: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .white
        //view.frame = self.view.bounds
        // 40 and 80 should be relative values???
        view.frame = CGRect(x:0, y:40, width:self.view.frame.width, height:self.view.frame.height-80)
        
        //print("scrollview origin y and height: \(view.frame.origin.y) and \(view.frame.height)")
        //Just for test
        //view.frame.size.height = 300
        
        view.contentSize = contentViewSize //normalViewSize
        view.contentOffset = CGPoint(x:0, y:20)
        
        return view
    }()
    
    
    
    @objc func revealAnswer(sender: UIButton) {
        
        
        print("yo mama")
        if isWaiting == false {
            largePulsatingView.isHidden = false
            
            largePulsatingView.play(fromProgress: 0, toProgress: 0.3) { (finished) in
                self.largePulsatingView.isHidden = true
            }
        }
        
        
    }
    @IBAction func resetPressed(_ sender: UIButton) {
        print("bruh why is this gay")
        level = 1
        cellLevel = 1
    }
    @IBAction func reloadPressed(_ sender: UIButton) {
        //view.layoutIfNeeded()
        //viewDidLoad()
        
    }
    
    func createNewView() {
        
        print("createNewView")
        //Commented by Tim on July 19, 2020
        /*
        if (Int(self.view.frame.height - latestYCor)) < 90 && timesOffsetChanged != 1 {
            let scrollPoint = CGPoint(x: 0.0, y: 300.0)
            scrollview.contentSize = contentViewSize
            scrollview.setContentOffset(scrollPoint, animated: false)
            timesOffsetChanged += 1
        }
        */
        // 50, 80 ? please use relative values?
        let tempCellView = CellView(frame: CGRect(x:0, y:0, width:self.view.frame.width - 50, height:self.view.frame.height-80))
        
        //let tempCellView = CellView(frame: CGRect(x:0, y:0, width:300, height:10))
        //let tempCellView = CellView(frame: self.view.bounds)
        
        
        tempCellView.tag = Int(String(level)+String(cellLevel))!
        
        cellViewInitialization(CellView: tempCellView, cl: String(cellLevel), ll: String(level))
        
        // !!!
        view.addSubview(tempCellView)
        
        //print("tempcellView orgin.y and height:")
        //print(tempCellView.frame.origin.y)
        //print(tempCellView.frame.height)
        
        currentView = tempCellView

        // update timely
        //self.view.layoutIfNeeded()
        
        //For Stack View...
        configureStackView()
        UIView.animate(withDuration: 0.5, animations: {
            // Height
            self.stackView.alpha = 1
        })
        
        
        //view.bringSubviewToFront(dropDownView)

        // For pulsating animation...
        // bob jul 20 8:40
        view.layoutIfNeeded()
        self.pulsatingConfig()
    }

    
       // Initialize the CellView
       func cellViewInitialization(CellView: CellView,cl: String, ll: String) {
           print(timesOffsetChanged)
           
           //CellView.cellView.backgroundColor = .clear
           let sub = (timesOffsetChanged+1) - (timesOffsetChanged*spacing)
           let y = (self.view.frame.size.height / 2)*sub
           
           
           CellView.center = CGPoint(x: self.view.frame.size.width  / 2, y: y)
           
           CellView.firstLabelCenter.constant -= 80
           CellView.secondLabelCenter.constant -= 80
           CellView.newplyCenter.constant -= 80
           CellView.equalSign.frame.origin.y -= 80
           CellView.ansButton.frame.origin.y -= 80
           //print("ANSBUTTON CONSTRAINTS: \(CellView.ansButton.constraints)")
           /*
            if cellLevel != 1 {
            let aboveViewTag = Int(String(level)+String(Int(cellLevel)-1))
            let aboveView = self.view.viewWithTag(aboveViewTag!) as? CellView
            CellView.translatesAutoresizingMaskIntoConstraints = false
            CellView.topAnchor.constraint(equalTo: aboveView!.bottomAnchor, constant: 20).isActive = true
            }
            */
           CellView.ansButton.addTarget(self, action: #selector(GuidedLearningVC.revealAnswer(sender:)), for: .touchUpInside)
           
           CellView.layer.cornerRadius = 30
           CellView.backgroundColor = UIColor(gradientStyle:UIGradientStyle.leftToRight, withFrame:CellView.frame, andColors:[.flatPowderBlue(), .flatPowderBlueDark()])
           
           
           CellView.layer.shadowColor = UIColor.flatPowderBlueDark().cgColor
           CellView.layer.shadowOffset = CGSize(width: 1, height: 1)
           CellView.layer.shadowOpacity = 0.7
           CellView.layer.shadowRadius = 4.0
           //firstNum.text = "1"
           //secondNum.text = "1"
           CellView.firstLabel.text = ll
           CellView.secondLabel.text = cl
           
           
           
           CellView.ansButton.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
           CellView.ansButton.layer.cornerRadius = 15
           
    
           
           //cellViewConstraints(CellView: CellView)
           let ans_length: Int = String(Int(CellView.firstLabel!.text!)! * Int(CellView.secondLabel!.text!)!).count;
           if ans_length == 1 {
               CellView.ansButton.setTitle("_", for: .normal)
           } else {
               CellView.ansButton.setTitle("__", for: .normal)
           }
           
       }
       
    
    func currentTime() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return (hour*60)+minutes
    }
    
    func finalScoreViewConfig() {
        if defaults.integer(forKey: "highScore") <= questionsCorrect {
            defaults.setValue(questionsCorrect, forKey: "highScore")
        }
        //resetButton.layer.cornerRadius = 25
        
        let displayLink = CADisplayLink(target: self, selector: #selector(updater))
        displayLink.add(to: .main, forMode: .default)
        finalView.isHidden = false
        view.bringSubviewToFront(finalView)
        
        stackView.isHidden = true
        
        correctLabel.text = "0"
        highScoreLabel.text = "0"
        print(questionsCorrect)
        level = 1
        cellLevel = 1
        
        timer.invalidate()
        
        //resetButton.isHidden = false
        view.bringSubviewToFront(dropDownView)
        // #add
    }
    
    @objc func updater() {

        if Int(correctLabel.text!)! < Int(questionsCorrect) {
            correctLabel.text = String(Int(correctLabel!.text!)! + 1)
        }
        else if Int(correctLabel.text!)! == Int(questionsCorrect){
            questionsCorrect = 0
        }
        
        if Int(highScoreLabel.text!)! < Int(defaults.integer(forKey: "highScore")) {
            highScoreLabel.text = String(Int(highScoreLabel!.text!)! + 1)
        }
        
        if Int(timeLabel.text!)! < Int(minuteCounter.text!)! {
            timeLabel.text = String(Int(timeLabel!.text!)! + 1)
        }
        if Int(secondsTimeLabel.text!)! < Int(secondCounter.text!)! {
            secondsTimeLabel.text = String(Int(secondsTimeLabel!.text!)! + 1)
        }

        
    }
    
    @IBAction func proceedButtonPressed(_ sender: UIButton) {
        proceedButton.isHidden = true
        for view in scrollview.subviews {
            view.removeFromSuperview()
        }
        if level == 9 {
            print("floor gang auh")
            finalScoreViewConfig()
        }
        else {
            level += 1
            cellLevel = level
            timesOffsetChanged = 0
            latestYCor = 0
            createNewView()
        }
        
    }
    @IBAction func nextLevelButtonPressed(_ sender: UIButton) {
        congratsView.isHidden = true
        blurEffect.isHidden = true
        for view in scrollview.subviews {
            view.removeFromSuperview()
        }
        if level == 9 {
            print("floor gang auh")
            finalScoreViewConfig()
        }
        else {
            level += 1
            cellLevel = level
            timesOffsetChanged = 0
            latestYCor = 0
            createNewView()
            tabBarController?.tabBar.isHidden = true
        }
        
    }
    
    @IBAction func reviewButtonPressed(_ sender: UIButton) {
        self.view.bringSubviewToFront(self.proceedButton)
        UIView.animate(withDuration: 2, animations: {
            self.congratsView.isHidden = true
            self.proceedButton.isHidden = false
            self.blurEffect.isHidden = true
            
            
        })
        tabBarController?.tabBar.isHidden = true
        
    }
    
    @objc func count() {
        seconds += 1
        if String(seconds).count < 2 {
            secondCounter.text = "0\(seconds)"
        }
        else if seconds < 60 {
            secondCounter.text = "\(seconds)"
        }
        else {
            if seconds == 60 {
                minutes += 1
                seconds = 0
            }
            if String(minutes).count < 2 {
                minuteCounter.text = "0\(minutes)"
            }
            else {
                minuteCounter.text = "\(minutes)"
            }
            if String(seconds).count < 2 {
                secondCounter.text = "0\(seconds%60)"
            }
            else if seconds < 60 {
                secondCounter.text = "\(seconds%60)"
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "reset2quiz") {
            // Pass data to tabBarViewController
            print("Segue: reset2quiz!")
            let tabVC = segue.destination as! TabBarController
            // Automatically select index = 2 to run
            tabVC.selectedIndex = 2
        }
    }
    
    func correctAnswer() {
        if isFirstClick == true {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
            isFirstClick = false
            tabBarController?.tabBar.isHidden = true
        }
        print("correctAnswer")
        print(cellLevel)
        print(level)
        questionsCorrect += 1
        nTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(doStuff), userInfo: nil, repeats: true)
        currentView?.ansButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.currentView?.ansButton.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        
        isWaiting = true
        
    }
    
    func configureButtons() {
        //stackView.translatesAutoresizingMaskIntoConstraints = false
        //stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //stackView.widthAnchor.constraint(equalToConstant: 400)
        view.bringSubviewToFront(stackView)
        stackView.alpha = 1
        //stackView.frame.origin.x = view.frame.width/2
        
        //stackView.frame.origin.y = (currentView?.frame.origin.y)! + 300
        //print("origin: \(stackView.center)")
        //print("size: \(stackView.frame)")
        for (_, button) in buttons.enumerated() {
            if button.tag != 11 && button.tag != 10 {
                button.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                button.layer.cornerRadius = button.frame.size.width / 2

                button.titleLabel?.adjustsFontSizeToFitWidth = true
                
                //July 28 pm, 2020 by Tim
                //print("Tim....height: \(button.frame.size.height)")
                
                button.titleLabel?.font = UIFont(name: "Gill Sans", size: button.frame.size.height*2/4)
                
                
                /*
                if button.tag == 9 {
                    button.center = CGPoint(x: buttons[2].frame.origin.x, y: button.frame.origin.y)
                }
                */
                //button.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }
            else {
                button.contentVerticalAlignment = .fill
                button.contentHorizontalAlignment = .fill
                print(button.frame.size)
            }
        }
        /*
        for c in stackConstraints {
            print(c)
            if c.identifier == "b1" || c.identifier == "b2" {
                print("bruhuhdaufhudhfuhsfhdshf")
                c.constant = buttons[0].frame.size.width - 20
            }
            else if c.identifier == "b1h" || c.identifier == "b2h" {
                c.constant = buttons[0].frame.size.width - 20
            }
        }
         */
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch ended")
        if isWaiting == true {
            isWaiting = false
            nTimer.invalidate()
            pulsatingView.removeFromSuperview()
            let str_result = String(Int(currentView!.firstLabel!.text!)! * Int(currentView!.secondLabel!.text!)!);
            
            currentView!.ansButton.setTitle(str_result, for: .normal);
            currentView!.ansButton.isEnabled = false
            currentView!.ansButton.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            pulsatingLayerConfig(parentView: currentView!.ansButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                // wait for user to dismiss: tap any open area
                print("hi")
                // Animating....
                UIView.animate(withDuration: 0.5, animations: {
                    // Height
                    self.currentView!.frame.size.height = CGFloat(self.cellH) //70
                    // Center
                    self.currentView!.center = CGPoint(x: CGFloat(self.view.frame.width/2), y: CGFloat(CGFloat(self.cellLevel-self.level+1)*(self.spacing + (self.currentView!.frame.height))))
                    
                    self.currentView!.firstLabelCenter.constant += 80
                    self.currentView!.secondLabelCenter.constant += 80
                    self.currentView!.newplyCenter.constant += 80
                    self.currentView!.equalSign.frame.origin.y += 80
                    self.currentView!.ansButton.frame.origin.y += 80
                    
                    // update layout right now if any changes
                    self.view.layoutIfNeeded() // !!! important !!!
                }, completion: { finished in
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        //self.currentView!.center = CGPoint(x: CGFloat(self.view.frame.width/2), y: CGFloat(CGFloat(self.cellLevel)*(self.spacing + (self.currentView!.frame.height))))
                        UIView.performWithoutAnimation {
                            //self.currentView!.center.y = c_y //CGPoint(x: c_x, y: c_y )
                            
                        }
                        
                    }, completion: { finished in
                        
                        self.latestYCor = CGFloat(CGFloat(self.cellLevel)*(self.spacing + (self.currentView!.frame.height)))
                        self.cellLevel += 1
                        print(self.latestYCor)
                        
                        
                        
                        // CellView doesnot belong to scrollview at the beginning
                        self.currentView!.removeFromSuperview()
                        self.scrollview.addSubview(self.currentView!)
                        //print("cellFrame:\(String(describing: self.currentView))")
                        //print("scrollview:\(self.scrollview.subviews)")
                        
                        
                        if self.cellLevel > 9 {
                            print("cellLevel: \(self.cellLevel), level: \(self.level)")
                            self.enterNewLevel()
                            //source
                        }
                        else {
                            self.createNewView()
                        }
                    })
                    
                })
            }
        }
        
    }
    
    @IBAction func changeLanguage(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
        print("changeLanguage")
        
        let ans_length: Int = String(Int(currentView!.firstLabel!.text!)! * Int(currentView!.secondLabel!.text!)!).count;
        if currentView?.ansButton.currentTitle == "_" || currentView?.ansButton.currentTitle == "__" {
            currentView!.ansButton.setTitle("", for: .normal)
            print("removed!!")
        }
        
        switch button.tag {
            case 11:
                
                if currentView!.ansButton.titleLabel?.text == String(Int(currentView!.firstLabel!.text!)! * Int(currentView!.secondLabel!.text!)!) {
                    print("congratulations!")
                    stackView.alpha = 0
                    correctAnswer()
                } else {
                    redPulsatingView.isHidden = false
                    currentView?.ansButton.shake(count: 2, for: 0.25, withTranslation: 5)
                    redPulsatingView.play(fromProgress: 0, toProgress: 0.3) { (finished) in
                        self.redPulsatingView.isHidden = true
                    }
                    print("wrong dumbo")
                }
            
            case 10:
                if currentView?.ansButton.currentTitle?.last == "_" {
                    currentView!.ansButton.setTitle("__", for: .normal)
                }
                else if currentView?.ansButton.currentTitle?.count == ans_length {
                    let tempTitle = currentView!.ansButton.currentTitle!.dropLast()
                    currentView!.ansButton.setTitle(String(tempTitle) + "_", for: .normal)
                }
                else {
                    let tempTitle = currentView!.ansButton.currentTitle!.dropLast()
                    currentView!.ansButton.setTitle(String(tempTitle), for: .normal)
                }
            
            default:
                
                if ans_length == 1 {
                    currentView!.ansButton.setTitle(String(button.tag), for: .normal)
                    print("equal")
                }
                else {
                    if currentView?.ansButton.currentTitle?.count != ans_length && currentView?.ansButton.currentTitle?.last != "_" && currentView?.ansButton.currentTitle == "" {
                        currentView!.ansButton.setTitle((currentView?.ansButton.currentTitle)! + String(button.tag) + "_", for: .normal)
                        print("plus equal")
                        print(currentView?.ansButton.currentTitle as Any)
                    }
                    else {
                        
                        let tempTitle = currentView!.ansButton.currentTitle!.dropLast()
                        currentView!.ansButton.setTitle(tempTitle + String(button.tag), for: .normal)
                    }
                }
                
                print("button.tag:\(button.tag)")
            
        }
    }
    func enterNewLevel() {
        print("level complete")
        if level == 9 {
            nextButton.setTitle("Finish", for: .normal)
        }
        levelTextLabel.text = "You've completed level \(level)!"
        blurEffect.isHidden = false
        self.view.bringSubviewToFront(blurEffect)
        self.view.bringSubviewToFront(congratsView)
        congratsView.isHidden = false
        tabBarController?.tabBar.isHidden = false
        self.view.layoutIfNeeded()
        //print(scrollview.subviews)
    }
    
    func configureCongrats() {
        congratsView.isHidden = true
        reviewButton.layer.cornerRadius = 15
        nextButton.layer.cornerRadius = 15
        congratsView.layer.cornerRadius = 5
        shadow(view: congratsView)
        
    }
    //Configure the DropdownView
    func configureDropDownView() {
        top = view.frame.height
        bottom = top!-100
        half = top! - ((top! - bottom!)/10)
        dropDownView.layer.cornerRadius = 10
        
        //dropDownView.backgroundColor = .clear
        dropDownView.backgroundColor = #colorLiteral(red: 0.4737529713, green: 0.4780024131, blue: 0.7423659581, alpha: 1)
        
        //resetButton.isHidden = true
        //reloadButton.isHidden = true

        //littleSymbol.isHidden = true
        //secondCounter.isHidden = true
        //minuteCounter.isHidden = true
        //quizLabel.isHidden = true
        
        //view.bringSubviewToFront(dropDownView)
    }
    
    func shadow(view: UIView) {
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        view.isHidden = true
    }
    
    
    func pulsatingLayerConfig(parentView: UIView) {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
        pulsatingLayer.fillColor = UIColor.yellow.cgColor
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        pulsatingLayer.position = parentView.center
        parentView.layer.addSublayer(pulsatingLayer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        gVars.level = level
        gVars.cellLevel = cellLevel
        print("levels \(gVars.level) \(gVars.cellLevel)")
    }
    
    /*
    override func viewDidLayoutSubviews() {
        //Aug. 1st, 2020 by Tim. I don't why an imageview will be added in the scrollview automatically?
        for view in scrollview.subviews {
            view.removeFromSuperview()
        }
        print("viewDidLayoutSubviews")
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // jul 27 bob:
        screenHeight = view.frame.height
        screenWidth = view.frame.width
        dynamicAutolayout()
        

        
        configureDropDownView()
        dropDownView.isHidden = true
        
        fetchFromDefaults()
        configureCongrats()
        finalView.isHidden = true
        view.addSubview(scrollview)
        createNewView()
        //shadow(view: backButton)
        proceedButton.isHidden = true
        proceedButton.layer.cornerRadius = 25
        shadow(view: proceedButton)
        blurEffect.isHidden = true
        self.view.bringSubviewToFront(blurEffect)
        
        //Move the below to the func configureDropDownView()
        //dropDownView.backgroundColor = .clear
        //resetButton.isHidden = true
        //reloadButton.isHidden = true
        
        configureButtons()
        
        //stackView.isHidden = true
        pulsatingConfig()
        
        self.view.isUserInteractionEnabled = true
   
        //Move the below to the func configureDropDownView()
        //self.view.addGestureRecognizer(resetTimer)
        //view.bringSubviewToFront(dropDownView)
        //drawerView.insetAdjustmentBehavior = .superviewSafeArea
        //drawerView.position = .open
        //littleSymbol.isHidden = true
        //secondCounter.isHidden = true
        //minuteCounter.isHidden = true
        //quizLabel.isHidden = true
        /*
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Sense", ofType: "mp3")!))
        }
        catch {
            print(error)
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
 */
        print("GL")
        
        
    }
    @objc func doStuff() {
        // perform any action you wish to
        print("User inactive for more than 5 seconds .")
        nTimer.invalidate()
    }
    
    func pulsatingConfig() {
        /*
        pulsatingView.frame = CGRect(x: ((currentView?.ansButton.frame.origin.x)!), y: ((currentView?.ansButton.frame.origin.y)!), width: 100, height: 100)
        pulsatingView.center = (currentView?.ansButton.center)!
        pulsatingView.animation = Animation.named("Pulsating")
        pulsatingView.loopMode = .loop
        pulsatingView.contentMode = .scaleAspectFit
        pulsatingView.play(fromProgress: 0, toProgress: 0.3)
        currentView!.addSubview(pulsatingView)
        currentView?.sendSubviewToBack(pulsatingView)
         */
        
        redPulsatingView.frame = CGRect(x: ((currentView?.ansButton.frame.origin.x)!), y: ((currentView?.ansButton.frame.origin.y)!), width: 100, height: 100)
        redPulsatingView.center = (currentView?.ansButton.center)!
        redPulsatingView.animation = Animation.named("red_pulsating")
        redPulsatingView.loopMode = .playOnce
        redPulsatingView.contentMode = .scaleAspectFit
        currentView!.addSubview(redPulsatingView)
        currentView?.sendSubviewToBack(redPulsatingView)
        redPulsatingView.isHidden = true
        
        largePulsatingView.frame = CGRect(x: stackView.frame.origin.x, y: stackView.frame.origin.y, width: 370, height: 400)
        largePulsatingView.center = stackView.center
        largePulsatingView.animation = Animation.named("large_pulsating")
        largePulsatingView.loopMode = .playOnce
        largePulsatingView.contentMode = .scaleAspectFit
        largePulsatingView.play(fromProgress: 0, toProgress: 0.3)
        view.addSubview(largePulsatingView)
        
        largePulsatingView.isHidden = true
    }
    
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        
        view.bringSubviewToFront(dropDownView)
        dropDownView.isHidden = false
        
        //dropDownView.backgroundColor = #colorLiteral(red: 0.4737529713, green: 0.4780024131, blue: 0.7423659581, alpha: 1)
        //resetButton.isHidden = false
        //reloadButton.isHidden = false
        //littleSymbol.isHidden = false
        //secondCounter.isHidden = false
        //minuteCounter.isHidden = false
        //quizLabel.isHidden = false
        
        guard let recognizerView = recognizer.view else {
            return
            
        }
        if recognizer.state == .ended {
            if heightConstraint.constant > half! {
                print("less")
                //resetButton.isHidden = true
                //reloadButton.isHidden = true
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
                    self.heightConstraint.constant = CGFloat(self.view.frame.height)
                    self.view.layoutIfNeeded()
                }) { (complete) in
                    
                }
            }
            else {
                print("greater")
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
                    self.heightConstraint.constant = self.bottom!
                    //
                    self.view.layoutIfNeeded()
                    
                }) { (complete) in
                    self.dropDownView.smooth(count: 1, for: 0.2, withTranslation: 2)
                }
            }
        }
        let translation = recognizer.translation(in: view)
        
        if heightConstraint.constant - translation.y > bottom! {
            heightConstraint.constant -= translation.y
            
        }
        recognizer.setTranslation(.zero, in: view)
    }
    
    func fetchFromDefaults() {
        latestYCor = 0
        level = 1
        cellLevel = 1
        if let _ = defaults.integer(forKey: "highScore") as? Int {
            //
        } else {
            defaults.setValue(0, forKey: "highScore")
        }
        
        if let plevel = defaults.integer(forKey: "level") as? Int {
            level = plevel
        }
        if let pcellLevel = defaults.integer(forKey: "cellLevel") as? Int {
            cellLevel = pcellLevel
        }

    }
    
    //Confgiure the StackView
    func configureStackView() {
        //print("DEBUG_BUTTONS: \(buttons)")
        stackView.layer.cornerRadius = 15
        
        // update timely
        //self.view.layoutIfNeeded()
        stackView.layer.zPosition = .greatestFiniteMagnitude
        stackView.isHidden = false

         
        //By Tim
        print("configureStackView screenHeight: \(String(describing: screenHeight))")
        print("configureStackView constant: \(stackViewCenterY.constant)")
        
        if screenHeight! > 1000 { //for iPad?
            stackViewCenterY.constant = screenHeight! * 1/5 //should caculate for it?
        }
        else {
            stackViewCenterY.constant = screenHeight! * 1/7 //should caculate for it?
        }
        
        //Update timely. Tim@9:15am, July, 20, 2020.
        //It's important! Otherwise the stackview coordinations will be got wrongly.
        view.layoutIfNeeded()
            
        view.bringSubviewToFront(stackView)
        
    }
    

    
    func cellViewConstraints(CellView: CellView) {
        CellView.translatesAutoresizingMaskIntoConstraints = false
        
        //CellView.cellView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //CellView.cellView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        //CellView.cellView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //CellView.frame.size.height = self.view.frame.height
        
        CellView.center = CGPoint(x: self.view.frame.size.width  / 2, y: (self.view.frame.size.height / 2)*(timesOffsetChanged+1) - (timesOffsetChanged*spacing))
        
        //print(CGPoint(x: CGFloat(self.view.frame.width/2), y: CGFloat(self.view.frame.height/2)))
        //CellView.cellView.frame.size.height = self.view.frame.height / 2
        
        CellView.cellView.center = CGPoint(x: CellView.cellView.frame.size.width  / 2, y: (self.view.frame.size.height / 2)*(timesOffsetChanged+1) - (timesOffsetChanged*spacing))
        
        //print(CellView.center)
        //CellView.cellView.center = CGPoint(x: CGFloat(self.view.frame.width/2), y: CGFloat(self.view.frame.height/2))
        //print(CellView.cellView.center)
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func dynamicAutolayout() {
        print("YO MAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMAMA")
        
        print(screenHeight!)
        print(screenWidth!)
        for c in congratsConstraints {
            //print(c.identifier)
            switch c.identifier {
                case "height":
                    c.constant = screenHeight! * 2/3
                case "width":
                    c.constant = screenWidth! * 6/7
                case "nButtonWidth":
                    c.constant = screenWidth! * 1/5
                case "nButtonHeight":
                    c.constant = screenHeight! * 1/10
                case "rButtonWidth":
                    c.constant = screenWidth! * 1/5
                case "rButtonHeight":
                    c.constant = screenHeight! * 1/10
                default: break
                    
            }
            
        }
        
        //print(proceedConstraints)
        for c in proceedConstraints {
        
            switch c.identifier {
                case "height":
                    c.constant = screenHeight! * 1/10
                case "width":
                    c.constant = screenHeight! * 1/10
                default: break
            }
        }
        
        for c in stackConstraints {
            
            switch c.identifier {
                case "stackWidth":
                    c.constant = screenWidth! * 2/3
                case "stackHeight":
                    c.constant = screenHeight! * 1/3
                default: break
            }
        }
    }
    
    
    //Aug., 2nd, 2020 by Tim
    override func viewWillLayoutSubviews() {
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        let iH: Int = (Int)(tabBarHeight!)
        
        if  iH > 60 {
           tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
        }
        else {
            tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
        }
    }
        
}

public extension UIButton {
    
    func shake(count : Float = 4,for duration : TimeInterval = 0.5,withTranslation translation : Float = 5) {
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
    }
    
    
}
