//
//  ChooseLearningModeVC.swift
//  Sense
//
//  Created by Bob Yuan on 2020-03-18.
//  Copyright © 2020 Bob Yuan. All rights reserved.
//

import UIKit
import Lottie

class ChooseLearningModeVC: UIViewController {
    
    let c1 = UIColor(hex: "463730")
    let easterEggAnimation = AnimationView()
    var time = 0
    
    @IBOutlet weak var guidedButton: UIButton!
    @IBOutlet weak var freeButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func guidedPressed(_ sender: UIButton) {
    }
    
    @IBAction func freePressed(_ sender: Any) {
    }
    @IBAction func sunPressed(_ sender: UIButton) {
        if time == 0{
            easterEggAnimation.play(fromProgress: 0, toProgress: 0.15)  { (finished) in
                self.time = 1
                self.label.textColor = .white
            }
            
        }
        else {
            easterEggAnimation.play(fromProgress: 0.3, toProgress: 0.5) { (finished) in
                self.time = 0
                self.label.textColor = .black
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guidedButton.layer.cornerRadius = 13
        freeButton.layer.cornerRadius = 13
        configureEasterEgg()
        //popupView.hero.modifiers = [.translate(y:100)]
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        let currentMin = formatter.string(from: Date())
        formatter.dateFormat = "HH"
        let currentHour = formatter.string(from: Date())
        //print("currenttime: ")
        if Int(currentHour)! > 18 {
            easterEggAnimation.play(fromProgress: 0, toProgress: 0.15)  { (finished) in
                self.time = 1
                self.label.textColor = .white
            }
        }
        else if Int(currentHour)! == 18 && Int(currentMin)! > 0 {
            easterEggAnimation.play(fromProgress: 0, toProgress: 0.15)  { (finished) in
                self.time = 1
                self.label.textColor = .white
            }
        }
        
    }
    
    //Aug., 2nd, 2020 by Tim
    //Adjust positions for tabBarItems
    //The following was Moved to TabBarController.swift
    override func viewDidLayoutSubviews() {
        /*
        let tabBar = self.tabBarController?.tabBar
        let tabBarHeight = tabBar!.frame.height
        let iH: Int = (Int)(tabBarHeight)
        
        for tb in tabBar!.items! {

            print("choose H:\(iH)")
            print(tb.tag)
            if  iH > 60 {
                tb.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
            }
            else {
                if tb.tag == 3 {
                    print("frame.height:\(self.view.frame.height)")
                    if(self.view.frame.height > 1000){ //for iPad only
                        tb.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
                    }
                    else
                    {
                        tb.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
                    }
                }
                else {
                    tb.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }
            }

        }*/
    }

    
    
    func configureEasterEgg() {
        easterEggAnimation.frame = view.bounds
        easterEggAnimation.animation = Animation.named("globe_rotation")
        easterEggAnimation.loopMode = .playOnce
        
        easterEggAnimation.contentMode = .scaleAspectFit
        
        view.addSubview(easterEggAnimation)
        view.sendSubviewToBack(easterEggAnimation)
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        

        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])
        
        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
                
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                self.init(red: r, green: g, blue: b, alpha: a)
                
            }
        }
        
        
        return nil
    }
}
