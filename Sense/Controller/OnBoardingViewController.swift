//
//  OnBoardingViewController.swift
//  Sense
//
//  Created by Lucinha7 Liu on 2020-08-04.
//  Copyright © 2020 Bob Yuan. All rights reserved.
//

import UIKit
import paper_onboarding

class OnBoardingViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    
    
    
    func onboardingConfigurationItem(item: OnboardingContentViewItem, index _: Int) {
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 2 {
            if self.continueButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.continueButton.alpha = 0
                })
            
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 3 {
            _print("trasns")
            self.view.bringSubviewToFront(continueButton)
            UIView.animate(withDuration: 0.4, animations: {
                self.continueButton.alpha = 1
            })
        }
    }
    @IBOutlet weak var onBoardingView: OnBoardV!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func continuePressed(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(true, forKey: "didPerformOnboarding")
        
        userDefaults.synchronize()
    }
    
    var isiPad: Bool = false
    var dFontSize : CGFloat = 18
    var tFontSize : CGFloat = 24
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _print("obVC.viewDidLoad()")
        
        //if view.frame.width > 900 { isiPad  = true; dFontSize = 30; tFontSize = 36 }
        if _screenHeight > 1000 { isiPad  = true; dFontSize = 30; tFontSize = 36 }
        
        
        onBoardingView.dataSource = self
        onBoardingView.delegate = self
        
        continueButton.layer.cornerRadius = 10
        continueButton.alpha = 0
        continueButton.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        continueButton.setTitle("I'm Ready!", for: .normal)
        continueButton.frame = CGRect(x: self.view.frame.width/2, y: self.view.frame.height * 3/4 + 20, width: 165, height: 60)
        continueButton.center.x = self.view.center.x
    }
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return [
         OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Car"),
                                       title: "Completely Offline",
                                 description: "Sense is designed to help kids memorize the multiplication table with the help of their parents. You can use it anytime, anywhere; during car rides, on the plane, or even free time at home. It is recommended that parents guide their child through this experience.",
                                    pageIcon:  UIImage(),
                                       color: #colorLiteral(red: 0.01607623696, green: 0.8369068503, blue: 0.7562904954, alpha: 1),
                                       titleColor: .white,
                                       descriptionColor: .white,
                                   titleFont: UIFont(name: "AvenirNext-Bold", size: tFontSize)!,
                             descriptionFont: UIFont(name: "AvenirNext-Regular", size: dFontSize)!),

         OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Bulb"),
                                        title: "Intuitive Learning Modes",
                                  description: "There are two learning modes: Guided and Freestyle. Guided is a step by step learning process, whereas in Freestyle you can skip to any column in the multiplication table.",
                                     pageIcon: UIImage(),
                                        color: #colorLiteral(red: 0.5523438454, green: 0.4015442133, blue: 0.9572374225, alpha: 1),
                                        titleColor: .white,
                                        descriptionColor: .white,
                                    titleFont: UIFont(name: "AvenirNext-Bold", size: tFontSize)!,
                                    descriptionFont: UIFont(name: "AvenirNext-Regular", size: dFontSize)!),

        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Music"),
                                     title: "Memorize Faster With Music",
                               description: "Sense provides a template rhythm and melody to help memorization, parents are encouraged to find a suitable multiplication song; many can be found on youtube.",
                                  pageIcon: UIImage(),
                                     color: #colorLiteral(red: 0.9586718678, green: 0.4633653164, blue: 0.4460003972, alpha: 1),
                                     titleColor: .white,
                                     descriptionColor: .white,
                                 titleFont: UIFont(name: "AvenirNext-Bold", size: tFontSize)!,
                           descriptionFont: UIFont(name: "AvenirNext-Regular", size: dFontSize)!),
                                
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Clock"),
                                      title: "Practice!",
                                description: "You can test your skills with the Quiz mode. It offers two types of input: voice and touch. Should you have any questions or comments, please let me know by email: bobycx@outlook.com.",
                                   pageIcon: UIImage(),
                                      color: #colorLiteral(red: 0.5057775974, green: 0.6187750697, blue: 0.8372532725, alpha: 1),
                                      titleColor: .white,
                                      descriptionColor: .white,
                                  titleFont: UIFont(name: "AvenirNext-Bold", size: tFontSize)!,
                            descriptionFont: UIFont(name: "AvenirNext-Regular", size: dFontSize)!)
            
         ][index]
    }
    
    deinit {
        _print(self)
        _print("!!!!!!!!!!!!!!!!!!! OB view controller Deinit...!!!!!!!!!!")
    }
    
}


