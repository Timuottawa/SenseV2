//
//  LearnViewController.swift
//  Sense
//
//  Created by Bob Yuan on 2019/10/31.
//  Copyright © 2019 Bob Yuan. All rights reserved.
//
//  Changed by Tim on Dec. 1st, 2019

import UIKit

import AVFoundation
//import MediaPlayer
import ChameleonFramework

class LearnViewController:UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource, AVSpeechSynthesizerDelegate{
    
    //Define vars for voice eviroment
    var synth: AVSpeechSynthesizer?; //TTS对象
    //let audioSession = AVAudioSession.sharedInstance(); //语音引擎
    var learningMode = "" 
    
    var num1 : Int?
    var num2 : Int?
    
    var guidedLearning : Bool?
    
    @IBOutlet weak var dynamicScrollView: UIScrollView!
    @IBOutlet weak var backToChooseButton: UIButton!
    
    let testArray = ["1","2","3","4","5","6","7","8","9"]
    
    var pageNumber : Int = 1
    
    
    @IBAction func backPressed(_ sender: Any) {
    }
    
    //August 9, 2020 by Tim
    init() {
          _print("f:init()---\(Date().timeIntervalSince1970)")
          super.init(nibName: nil, bundle: nil)
          
          _print(self)
          _print("f:init()+++\(Date().timeIntervalSince1970)")
      }
    override func awakeFromNib() {
          _print("f:afNib()---\(Date().timeIntervalSince1970)")
          super.awakeFromNib()
          
          _print(self)
          _print("f:afNib()+++\(Date().timeIntervalSince1970)")
      }
    required init?(coder aDecoder: NSCoder) {
          _print("f:init?()---\(Date().timeIntervalSince1970)")
          super.init(coder: aDecoder)
          
          _print(self)
          _print("f:init?()+++\(Date().timeIntervalSince1970)")
      }
    override func loadView() {
          _print("f:loadView()---\(Date().timeIntervalSince1970)")
          super.loadView()
          
          _print(self)
          _print("f:loadView()+++\(Date().timeIntervalSince1970)")
      }
    
    deinit {
        _print(self)
        _print("!!!!!!!!!!!!!!!!!!!Free view controller Deinit...!!!!!!!!!!")
    }
    
    override func viewDidLoad() {
          
        _print("f:vdld()---\(Date().timeIntervalSince1970)")
        print(self)
          
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
          
          _print("f:vdld()-++\(Date().timeIntervalSince1970)")
   
        // Aug 3, Bob add:
        //cellH = CGFloat(Int(view.frame.height * 0.078125))
        // Aug 6, Tim add:
        //cellH = CGFloat(Int(_screenHeight * 0.078125))
        cellH = CGFloat(_cellH)
        
        backToChooseButton.layer.cornerRadius = 25
        view.bringSubviewToFront(backToChooseButton)

        synth = AVSpeechSynthesizer()
        //Init voice eviroment
        synth?.delegate = self;
        
        //_print("viewDidLoad width: \(self.view.frame.width)")
        //_print(self.dynamicScrollView.frame.size.width)
        
        //dynamicScroll()
        
        _print("f:vdld()---\(Date().timeIntervalSince1970)")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _print("viewDidAppear:\(self.dynamicScrollView.frame.size.width)")
        
        //I don't know why StoryBoard added some view in for a blank scroll view? Junly 31, 2020 by Tim
        _print("%%%%:\(dynamicScrollView.subviews)")
        for _view in self.dynamicScrollView.subviews {
            _view.removeFromSuperview()
        }
        _print("%%%%:\(dynamicScrollView.subviews)")
        
        //If put in viewDidLoad(), will get wrong dynamicScrollView.frame.size.width.
        dynamicScroll()
    }

    
    @IBAction func backToChoose(_ sender: UIButton) {
        
    }
    

    
    //To caculate the number of rows in the current table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        //self.pageNumber = Int(tableView.frame.minX/self.dynamicScrollView.frame.size.width) + 1;
        //_print("\n tablebview page#=\(pageNumber)")
        
        //tableView.reloadData()
        
        return (10 - self.dynamicScrollView.currentPage)
    }
    
    //The content of a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //To caculate the number of page of current table view
        
        //self.pageNumber = Int(tableView.frame.minX/self.dynamicScrollView.frame.size.width) + 1;
        //_print("width:")
        //_print(tableView.frame.width)
        //_print("view: \(view.frame.size)")
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTVCell", for: indexPath) as! CustomQuestionCell
        //_print("cellwidth:\(cell.frame.width)")
        //cell.layer.cornerRadius = cell.frame.width * 1/15
        //cell.contentView.frame.size.width = CGFloat(tableView.bounds.width - 100)
        //cell.center.x = view.center.x
        
        let numberTwoNumber = Int(testArray[indexPath.row])! + (pageNumber - 1)
        if numberTwoNumber < 10 {
            cell.numberOne.text = String(pageNumber)
            cell.numberTwo.text = String(numberTwoNumber)
        }
        
        return cell
    }
    //var gtView = UITableView();
    let N_VIEWS:Int = 9; //Total number of the table views in the scroll view
    var cellH: CGFloat = 0 //should be replaced by a relative value!
    
    
    func dynamicScroll()
    {
        // normal iphone width
        let tableW:CGFloat = dynamicScrollView.frame.size.width - self.view.frame.width*1/7;
        let tableH:CGFloat = CGFloat(cellH * CGFloat(N_VIEWS)) //dynamicScrollView.frame.height;
        
        
        //Tim
        let scrollW:CGFloat = dynamicScrollView.frame.size.width;
        
        _print("dynamicScroll:")
        _print(tableW)
        _print(tableH)
        _print(view.frame.width)
        _print(view.frame.height)
        
        let tableY:CGFloat = 0;
        let totalCount:NSInteger = N_VIEWS;//# of table views；
        
        
        
        let tView: UITableView = UITableView();

        // 9 x the normal width
        //Tim August 2nd
        tView.frame = CGRect(x: CGFloat(0) * scrollW, y: tableY, width: tableW, height: tableH);
        
        // Aug 3, Bob add:
        tView.center.x = dynamicScrollView.center.x + CGFloat(0) * scrollW
        //tView.frame = CGRect(x: CGFloat(0) * tableW, y: tableY, width: tableW, height: tableH);

        tView.center.y += CGFloat(cellH/2)

        tView.delegate = self;
        tView.dataSource = self;
        tView.tableFooterView = UIView();
        tView.backgroundColor = UIColor.clear;
        tView.separatorStyle = .none;
        tView.allowsSelection = false;
        
    
        tView.estimatedRowHeight = 100.0
        tView.rowHeight = UITableView.automaticDimension
        tView.rowHeight = CGFloat(cellH) //should be replaced by a relative value!
        
        tView.backgroundColor = .clear
        tView.isScrollEnabled = false
        tView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionTVCell");

        //_print("dynamicSubviews!!!:\(dynamicScrollView.subviews)")
        dynamicScrollView.addSubview(tView);
        
        //_print("dynamicSubviews--:\(dynamicScrollView.subviews.count)")
        //_print("dynamicSubviews--:\(dynamicScrollView.subviews)")
    
        //let contentW:CGFloat = tableW * CGFloat(totalCount);//這個表示整個ScrollView的長度；
        //Tim August 2nd
        let contentW:CGFloat = scrollW * CGFloat(totalCount);//這個表示整個ScrollView的長度；
        //Tim August 2nd
        dynamicScrollView.contentSize = CGSize(width: contentW, height: tView.contentSize.height*1.5);
        
        //dynamicScrollView.contentSize = CGSize(width: contentW, height: 0);
        dynamicScrollView.isPagingEnabled = true;
        dynamicScrollView.delegate = self;
        
    }
    /*
    func screateTableView()
    {
        //
    }*/
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // July 31, 2020 by Tim
        // If others such as tableview, view..., but not dynamicScrollView, just return.
        if scrollView != dynamicScrollView {
            //_print("!!!scrollView != dynamicScrollView")
            return
        }
        
        _print("didScrolled")
        _print(scrollView.currentPage)
        //探测page是否变没变
        if pageNumber == scrollView.currentPage {
            pageNumber = scrollView.currentPage
            _print("continue...")
        }
        else {
            pageNumber = scrollView.currentPage
            //("c")
            _print("current page \(scrollView.currentPage)")
            _print("changed")
            // 防止创建多余的tableviews
            //Tim August 2nd
            //if dynamicScrollView.subviews.count < scrollView.currentPage+2{
            if dynamicScrollView.subviews.count < scrollView.currentPage{
                _print("is empty page")
                let tableW:CGFloat = dynamicScrollView.frame.size.width - self.view.frame.width*1/7;
                let tableH:CGFloat = CGFloat(cellH * CGFloat((10-pageNumber))) //self.dynamicScrollView.frame.size.height;
                
                //Tim August 2nd
                let scrollW:CGFloat = dynamicScrollView.frame.size.width;
                
                _print("didScroll: \(tableW) \(tableH)")
                
                let tableY:CGFloat = 0;
                //let totalCount:NSInteger = N_VIEWS;//# of table views；
                
                var tView: UITableView;
                tView = UITableView();

                // 9 x the normal width
                //tView.frame = CGRect(x: CGFloat(scrollView.currentPage-1) * tableW, y: tableY, width: tableW, height: tableH);
                
                //Tim August 2nd
                tView.frame = CGRect(x: CGFloat(scrollView.currentPage-1) * scrollW, y: tableY, width: tableW, height: tableH);
                tView.center.x = dynamicScrollView.center.x + CGFloat(scrollView.currentPage-1) * scrollW
                tView.center.y = dynamicScrollView.center.y - CGFloat(cellH/2)
                
                tView.delegate = self;
                tView.dataSource = self;
                tView.tableFooterView = UIView();
                tView.backgroundColor = UIColor.clear;
                tView.separatorStyle = .none;
                tView.allowsSelection = false;
                tView.rowHeight = UITableView.automaticDimension
                tView.estimatedRowHeight = 120.0
                tView.rowHeight = CGFloat(cellH) //should be replaced by a relative value!
                tView.backgroundColor = .clear
                tView.isScrollEnabled = false
                tView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionTVCell");
                
                dynamicScrollView.addSubview(tView)
                //_print("added one table view!")
                
                //_print("subviews--:\(scrollView.subviews.count)")
                //_print("subviews--:\(scrollView.subviews)")
                //let prevView = scrollView.subviews[scrollView.currentPage-2]
                //prevView.removeFromSuperview()
            }
            else {
                _print("tableview already exists")
                _print("subviews: \(dynamicScrollView.subviews.count)")
            }
        }
    }
    /*
    func createTableView()
    {
        
    }*/
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        //Just for testing....
        //Might be used later.
        //currentPage presents the number of current table view
        
        //if pageNumber == scrollView        // Do something with your page update
        //_print("scrollViewDidEndDecelerating: \(currentPage)")
        
        
        //_print(pageNumber)
        //let currentPage:Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //_print("scrollView Page: \(currentPage)");
        
        
        //if currentPage == 0 {
        //    self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(numberOfItems), y: scrollView.contentOffset.y)
        //}
        //else if currentPage == numberOfItems {
        //    self.scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        //}
    }
    
    //To speak out a message
    //Please see https://www.cnblogs.com/qian-gu-ling/archive/2017/03/22/6600993.html
    func speechMessage(message:String){
        let audioSession = AVAudioSession.sharedInstance(); //语音引擎
        //First, stop the current speaking
        synth?.stopSpeaking(at: AVSpeechBoundary.immediate);
        
        if !message.isEmpty {
            do {
                // 设置语音环境，保证能朗读出声音（特别是刚做过语音识别，这句话必加，不然没声音）
                //try audioSession.setCategory(AVAudioSession.Category.ambient)
                try audioSession.setCategory(AVAudioSession.Category.playback)
            }catch let error as NSError{
                _print("!!!error.code!!!\n")
                _print(error.code)
            }
            //需要转的文本
            let utterance = AVSpeechUtterance.init(string: message)
            //设置语言，这里是English
            utterance.voice = AVSpeechSynthesisVoice.init(language: "us_EN")
            //设置声音大小
            utterance.volume = 1.0
            //设置音频
            utterance.pitchMultiplier = 1.1
            //开始朗读
            synth?.speak(utterance)
            
        }
    }
    //
    //

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        
        UIView.animate(
            withDuration: 1,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
        
        //Just for a demo
        /*
        if (indexPath.row == 5){
            //Please see https://stackoverflow.com/questions/34438889/how-to-do-transforms-on-a-calayer
            
            //Please see https://my.oschina.net/ozawa4865/blog/714906

            let degrees = 90.0
            let radians = CGFloat(degrees * Double.pi / 180)
            
            // translate
            var transform = CATransform3DMakeTranslation(190,610, 0)
            
            // rotate 设置旋转
            transform = CATransform3DRotate(transform, radians, 0.0, 0.0, 1.0)
            
            // scale 设置大小缩放
            transform = CATransform3DScale(transform, 0.1, 0.1, 0.1)
            
            // apply the transforms
            cell.layer.transform = transform
        
            UIView.animate(withDuration: 2) { () -> Void in
                // 动画实现将cell的layer复原
                cell.layer.transform = CATransform3DIdentity
            }
            

        // 最后复原cell的frame
        cell.frame = CGRect(x: 0, y: cell.frame.origin.y, width: cell.frame.size.width, height: cell.frame.size.height);
            
        }
         */
    }
    //
    //
}

//get ViewController for current View
//Please see https://stackoverflow.com/questions/1372977/given-a-view-how-do-i-get-its-viewcontroller

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}

extension UIScrollView {
    var currentPage: Int {
        //_print("$currentPage$:\(self.contentOffset.x)")
        return Int((self.contentOffset.x + (0.5 * self.frame.size.width))/self.frame.width)+1
    }
}


