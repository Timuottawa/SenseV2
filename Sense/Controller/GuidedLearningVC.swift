//
//  GuidedLearningVC.swift
//  Sense
//
//  Created by Bob Yuan on 2020-03-19.
//  Copyright © 2020 Bob Yuan. All rights reserved.
//

// Main logic without changes, just for animation function
// By Tim on April 5th, 2020

import UIKit
import ChameleonFramework
import Lottie

class GuidedLearningVC: UIViewController {
    
    @IBOutlet weak var congratsView: UIView!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var levelTextLabel: UILabel!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet var congratsConstraints: [NSLayoutConstraint]!
    var level: Int = 1
    var cellLevel: Int = 1
    var currentView: CellView?
    var latestYCor: CGFloat = 0
    var spacing: CGFloat = 20
    var timesOffsetChanged: CGFloat = 0
    var isWaiting: Bool = false
    var screenHeight: CGFloat?
    var screenWidth: CGFloat?
    let pulsatingView = AnimationView()
    var finished = false
    
    var snap : UISnapBehavior!
    var animator : UIDynamicAnimator!
    var cellH = 0
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: CGFloat(10*(cellH+20)))
    lazy var normalViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height-80)
    
    var pulsatingLayer: CAShapeLayer!
    
    
    lazy var scrollview: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        
        //_print("scrollview creating...")
        view.backgroundColor = .white
        //view.frame = self.view.bounds
        view.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        
        //_print(self.view.bounds)
        //Just for test
        //view.frame.size.height = 300
        view.contentSize = normalViewSize
        view.isScrollEnabled = true
        //view.contentOffset = CGPoint(x:0, y:100)
        return view
    }()
    
    //August 8, 2020 by Tim
    init() {
        _print("g:init()---\(Date().timeIntervalSince1970)")
        super.init(nibName: nil, bundle: nil)
        
        _print(self)
        _print("g:init()+++\(Date().timeIntervalSince1970)")
    }
    override func awakeFromNib() {
        _print("g:afNib()---\(Date().timeIntervalSince1970)")
        super.awakeFromNib()
        
        _print(self)
        _print("g:afNib()+++\(Date().timeIntervalSince1970)")
    }
    required init?(coder aDecoder: NSCoder) {
        _print("g:init?()---\(Date().timeIntervalSince1970)")
        super.init(coder: aDecoder)
        
        _print(self)
        _print("g:init?()+++\(Date().timeIntervalSince1970)")
    }
    override func loadView() {
        _print("g:loadView()---\(Date().timeIntervalSince1970)")
        super.loadView()
        
        _print(self)
        _print("g:loadView()+++\(Date().timeIntervalSince1970)")
    }
    
    deinit {
        _print(self)
        _print("!!!!!!!!!!!!!!!!!!!Guided view controller Deinit...!!!!!!!!!!")
    }
    
    override func viewDidLoad() {
        
        _print("g:vdld()---\(Date().timeIntervalSince1970)")
        _print(self)
        
        super.viewDidLoad()
        
        _print("g:vdld()-++\(Date().timeIntervalSince1970)")
        
    

        
        cellH = _cellH
        
        _print("cellH:\(cellH)")
        _print("contentViewSize:\(contentViewSize)")
        _print("normalViewSize:\(normalViewSize)")
        
        // Just for test
        level = 1
        cellLevel = 1
        
        
        screenHeight = _screenHeight
        screenWidth = _screenWidth
        
        dynamicAutoLayout()
        
        configureCongrats()
        view.addSubview(scrollview)
        createNewView()
        backButton.layer.cornerRadius = 25
        
        //shadow(view: backButton)
        proceedButton.isHidden = true
        proceedButton.layer.cornerRadius = 25
        shadow(view: proceedButton)
        blurEffect.isHidden = true
        self.view.bringSubviewToFront(blurEffect)
        _print("GL")
        self.view.bringSubviewToFront(backButton)

        _print("g:vdld()+++\(Date().timeIntervalSince1970)")
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isWaiting == true {
            isWaiting = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                // wait for user to dismiss: tap any open area
                _print("hi")
                // Animating....
                UIView.animate(withDuration: 0.5, animations: {
                    // Height
                    self.currentView!.frame.size.height = CGFloat(self.cellH)
                    // Center
                    self.currentView!.center = CGPoint(x: CGFloat(self.view.frame.width/2), y: CGFloat(CGFloat(self.cellLevel-self.level+1)*(self.spacing + (self.currentView!.frame.height))))
                    
                    
                    // update layout right now if any changes
                    self.view.layoutIfNeeded() // !!! important !!!
                }, completion: { finished in
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        //self.currentView!.center = CGPoint(x: CGFloat(self.view.frame.width/2), y: CGFloat(CGFloat(self.cellLevel)*(self.spacing + (self.currentView!.frame.height))))
                        UIView.performWithoutAnimation {
                            //self.currentView!.center.y = c_y //CGPoint(x: c_x, y: c_y )
                            
                        }
                        
                    }, completion: { finished in
                        
                        //self.latestYCor = CGFloat(CGFloat(self.cellLevel)*(self.spacing + (self.currentView!.frame.height)))
                        //August 6, 2020 by Tim
                        self.latestYCor = CGFloat(CGFloat(self.cellLevel-self.level+1)*(self.spacing + (self.currentView!.frame.height)))
                                              
                        
                        self.cellLevel += 1
                        _print(self.latestYCor)
                        
                        
                        
                        // CellView doesnot belong to scrollview at the beginning
                        self.currentView!.removeFromSuperview()
                        self.scrollview.addSubview(self.currentView!)
                        
                        
                        if self.cellLevel > 9 {
                            _print("cellLevel: \(self.cellLevel), level: \(self.level)")
                            self.enterNewLevel()
                            //source
                        }
                        else {
                            //temp commented
                            self.createNewView()
                        }
                    })
                    
                })
            }

        }
    }
    
    @objc func revealAnswer(sender: UIButton) {
        if isWaiting == false {
            isWaiting = true
            _print(cellLevel)
            _print(level)
            let str_result = String(Int(currentView!.firstLabel!.text!)! * Int(currentView!.secondLabel!.text!)!);
            pulsatingView.removeFromSuperview()
            currentView!.ansButton.setTitle(str_result, for: .normal);
            currentView!.ansButton.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            
            UIView.animate(withDuration: 2.0,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.20),
                           initialSpringVelocity: CGFloat(6.0),
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: {
                            sender.transform = CGAffineTransform.identity
            },
                           completion: { Void in()  }
            )
        }
    }
    
    

    func pulsatingConfig() {

        pulsatingView.frame = CGRect(x: ((currentView?.ansButton.frame.origin.x)!), y: ((currentView?.ansButton.frame.origin.y)!), width: (currentView?.ansButton.frame.width)!*2.5, height: (currentView?.ansButton.frame.height)!*2.5)
         pulsatingView.center = (currentView?.ansButton.center)!
        
        //let c = NSLayoutConstraint(item: pulsatingView, attribute: .centerX, relatedBy: .equal, toItem: currentView!.ansButton, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        
         pulsatingView.animation = Animation.named("Pulsating")
         pulsatingView.loopMode = .loop
         pulsatingView.contentMode = .scaleAspectFit
         pulsatingView.play(fromProgress: 0, toProgress: 0.3)
         currentView!.addSubview(pulsatingView)
         currentView!.sendSubviewToBack(pulsatingView)
         //view.addConstraint(c)
         currentView!.layoutIfNeeded()
        
   
    }
    
    func createNewView() {
        
        if cellLevel == 9 {
            //_print("createNewView")
            //_print( Int(self.view.frame.height - latestYCor) )
            //_print(timesOffsetChanged)
        }
        
        //_print("createNewView")'
        
        //Commented by Tim on July 19, 2020
        //Uncomented by Tim on August 3nd, 2020
        // changed by Tim from "120" to "2*cellH" August 6, 2020
        if ((cellLevel == 9) && (Int(self.view.frame.height - latestYCor)) < (2 * cellH)) && (timesOffsetChanged != 1) {
            //let scrollPoint = CGPoint(x: 0.0, y: 300.0)
            //_print("contentViewSize:\(contentViewSize)")
            
            scrollview.contentSize = contentViewSize
            
            //scrollview.setContentOffset(scrollPoint, animated: false)
            //timesOffsetChanged += 1
        }
        else{
             //_print("normalViewSize:\(normalViewSize)")
             scrollview.contentSize = normalViewSize
            
        }
        
        //
        let tempCellView = CellView(frame: CGRect(x:0, y:0, width:self.view.frame.width - 50, height:self.view.frame.height-80))
        
        //let tempCellView = CellView(frame: CGRect(x:0, y:0, width:300, height:10))

        //let tempCellView = CellView(frame: self.view.bounds)
 
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                //self.scrollview.addSubview(tempCellView)
            }, completion: nil)

    
        tempCellView.tag = Int(String(level)+String(cellLevel))!
        
        cellViewInitialization(CellView: tempCellView, cl: String(cellLevel), ll: String(level))
        
        // !!!
        view.addSubview(tempCellView)
        
        currentView = tempCellView
        
        // update timely
        self.view.layoutIfNeeded()
        
        if #available(iOS 10.0, *) {
            pulsatingConfig()  //will crash on iPad2
        }
        self.view.bringSubviewToFront(backButton)
    }
    
    // Ugly codes for iPad by Tim August 3rd.
    override func viewDidLayoutSubviews() { //for iPad only
        if let cv = currentView {
            if cv.subviews.count >= 2 {
                cv.subviews[0].center = cv.ansButton.center
            }
        }
    }
    
    @IBAction func proceedButtonPressed(_ sender: UIButton) {
        proceedButton.isHidden = true
        
        for view in scrollview.subviews {
            view.removeFromSuperview()
        }
        scrollview.contentOffset = CGPoint(x:0, y:0)
        level += 1
        cellLevel = level
        timesOffsetChanged = 0
        latestYCor = 0
        createNewView()
    }
    @IBAction func nextLevelButtonPressed(_ sender: UIButton) {
        congratsView.isHidden = true
        blurEffect.isHidden = true
        
        
        scrollview.contentOffset = CGPoint(x:0, y:0)
        
        if finished != true {
            
            for view in scrollview.subviews {
                view.removeFromSuperview()
            }
            level += 1
            cellLevel = level
            timesOffsetChanged = 0
            latestYCor = 0
            
            createNewView()
        }
    }
    
    @IBAction func reviewButtonPressed(_ sender: UIButton) {
        self.view.bringSubviewToFront(self.proceedButton)
        UIView.animate(withDuration: 2, animations: {
            self.congratsView.isHidden = true
            if self.finished != true {
                _print("finished!!!!")
                self.proceedButton.isHidden = false
            }
            self.blurEffect.isHidden = true
            
        })
        
    }
    
    func enterNewLevel() {
        _print("level complete")
        gVars.soundEffect(filename: "congrats", ext: "mp3")
        levelTextLabel.text = "You've completed level \(level) !"
        blurEffect.isHidden = false
        self.view.bringSubviewToFront(blurEffect)
        self.view.bringSubviewToFront(congratsView)
        congratsView.isHidden = false
        if level == 9 {
            nextButton.setTitle("Finish", for: .normal)
            finished = true
        }
        self.view.layoutIfNeeded()
        //_print(scrollview.subviews)
    }
    
    func configureCongrats() {
        congratsView.isHidden = true
        reviewButton.layer.cornerRadius = 15
        nextButton.layer.cornerRadius = 15
        congratsView.layer.cornerRadius = 5
        shadow(view: congratsView)
        
    }
    
    func shadow(view: UIView) {
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        view.isHidden = true
    }
    
    //------Obsoleted------
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
    
    
    func dynamicAutoLayout() {
        for c in congratsConstraints {
            //_print(c.identifier)
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
    }
    
    func cellViewInitialization(CellView: CellView,cl: String, ll: String) {
        _print(timesOffsetChanged)

        //CellView.cellView.backgroundColor = .clear
        CellView.center = CGPoint(x: self.view.frame.size.width  / 2, y: (self.view.frame.size.height / 2)*(timesOffsetChanged+1) - (timesOffsetChanged*spacing))
        
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
        
        // update timely
        self.view.layoutIfNeeded()

        //cellViewConstraints(CellView: CellView)
        
    }
    
    //------Obsoleted------
    func cellViewConstraints(CellView: CellView) {
        CellView.translatesAutoresizingMaskIntoConstraints = false
        
        //CellView.cellView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //CellView.cellView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        //CellView.cellView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        CellView.frame.size.height = self.view.frame.height
        CellView.center = CGPoint(x: self.view.frame.size.width  / 2, y: (self.view.frame.size.height / 2)*(timesOffsetChanged+1) - (timesOffsetChanged*spacing))
        _print(CGPoint(x: CGFloat(self.view.frame.width/2), y: CGFloat(self.view.frame.height/2)))
        //CellView.cellView.frame.size.height = self.view.frame.height / 2
        CellView.cellView.center = CGPoint(x: CellView.cellView.frame.size.width  / 2, y: (self.view.frame.size.height / 2)*(timesOffsetChanged+1) - (timesOffsetChanged*spacing))
        _print(CellView.center)
        //CellView.cellView.center = CGPoint(x: CGFloat(self.view.frame.width/2), y: CGFloat(self.view.frame.height/2))
        _print(CellView.cellView.center)
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

/*
class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
     }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setupViews() {
        
    }
    
    let contentView: UIView = {
        let view = UIView
    }
}

*/


