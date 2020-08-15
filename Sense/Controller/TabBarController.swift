//
//  TabBarController.swift
//  Sense
//
//  Created by Bob Yuan on 2019/12/4.
//  Copyright © 2019 Bob Yuan. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate{
    
    var _guidedLearningVC: UIViewController?
    var _freeLearningVC: UIViewController?
    
    var kBarHeight: CGFloat = 80
    
    func InitPreLoadVC()
    {
        //Init for Guided and Freestyle
        self._guidedLearningVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GuidedLearningVC")
        //_guidedLearningVC?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //_guidedLearningVC?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //
        
        self._freeLearningVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LearningViewController")
        //_freeLearningVC?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //_freeLearningVC?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        
        self.delegate = self
        self.selectedIndex = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.InitPreLoadVC()
        }
        
        //_print("tabbarVCs---\(self.viewControllers as Any)")
        //_print(self)
        
        //let off = CGSize(width: CGFloat(10), height: CGFloat(10))
        //tabBar.dropShadow(shadowColor: .black, opacity: 1, offset: .zero, radius: 10) //seems problem?
        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    //August 8, 2020 by Tim
    @IBAction func unwindToGuidedLearningVC(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            _print("unwindToGuidedLearningVC...")
            self._guidedLearningVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GuidedLearningVC")
            sourceViewController.dismiss(animated: false, completion: nil)
            
            //Just to invoke viewLoad()
            _ = self._guidedLearningVC?.view
            
            }
        return
    }
    
    //August 8, 2020 by Tim
    @IBAction func unwindToLdearningVC(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            _print("unwindToLearningVC...")
            self._freeLearningVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LearningViewController")
            sourceViewController.dismiss(animated: false, completion: nil)
            
            //Just to invoke viewLoad()
            _ = self._freeLearningVC?.view
        }
        return
        
    }
    
    //August 8, 2020 by Tim
    @IBAction func unwindToOnBoardingVC(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        sourceViewController.dismiss(animated: false, completion: nil)
        
        //to be...
        _print("unwindToOnBardingVC...")
    }
    
    //August 8, 2020 by Tim
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        //Pre-viewLoad() to speed up
        //AsyncDispatch()
    }

    
    //August 8, 2020 by Tim
    func AsyncDispatch()
    {
            
        //August 8, 2020 by Tim
        //Speed quizview up, pre-loadView !
        //_print("Queue quizVC...")
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            //_print("+-+-+-+-+:dispatch quizvc")
            //_ = self.viewControllers?[2].view
        //}
        //DispatchQueue.global(qos: .background).async {
        //   _ = self.viewControllers?[2].view
        //}
        //
        
        //_print("Queue Gvc...")
        //Speed up GuildedLearningCV
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            //_print("+-+-+-+-+:dispatch GuildedLearning")
            //_ = self._guidedLearningVC?.view
        //}
        //DispatchQueue.global(qos: .background).async {
        //    _ = self._guidedLearningVC?.view
        //}
        //
        
        //_print("Queue Fvc...")
        //Speed up GuildedLearningCV
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            //_print("+-+-+-+-+:dispatch freeLearning")
            //_ = self._freeLearningVC?.view
        //}
        //DispatchQueue.global(qos: .background).async {
        //   _ = self._freeLearningVC?.view
        //}
        //
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //Speed up and pre-viewLoad()
        //AsyncDispatch()
        
        //tabBar.frame.size.height = CGFloat(kBarHeight)
        //_print("tabviewHeight: \(view.frame.height) and \(view.frame.size.height) and \(tabBar.frame.size.height) and \(tabBar.frame.size.width)")
        if #available(iOS 11.0, *) {
            if (view.safeAreaLayoutGuide.layoutFrame.size.height - view.frame.height) > 20 {
                tabBar.roundedTop(30)
                //_print(view.safeAreaLayoutGuide.layoutFrame.size.height)
                //_print(view.frame.height)
                // 734, 812
            }
        
        } else {
            // Fallback on earlier versions
            
        }
        
        //_print("batItem height:\(tabBar.frame.height)")

        
        //let off = CGSize(width: CGFloat(10), height: CGFloat(10))
        //tabBar.dropShadow(shadowColor: .black, opacity: 1, offset: .zero, radius: 10)

        
        //tabBar.frame.origin.y = view.frame.height - kBarHeight
        //---------------------Change tabBar Height for iPad only
        //let tabBarH: CGFloat = 83 //same as iPhoneXR
        //var tabFrame = self.Outlet_tabBar.frame
        //tabFrame.size.height = tabBarH
        //tabFrame.origin.y = self.view.frame.height - tabBarH
        //self.Outlet_tabBar.frame = tabFrame
        //---------------------
              
        //---------------------Adjust tabBar image position
        //_print("Tab bar ...Tim")
        let tabBar = self.tabBar
        let tabBarHeight = tabBar.frame.height
        let iH: Int = (Int)(tabBarHeight)
        
        
        for tb in tabBar.items! {

              _print("choose H:\(iH)")
              //_print(tb.tag)
            
            
              if  iH > 60 {
                  tb.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
                  if tb.tag == 3 {
                     tb.imageInsets = UIEdgeInsets(top: 21, left: 0, bottom: -21, right: 0)
                  }
              }
              else {
                  if tb.tag == 3 {
                      //_print("frame.height:\(self.view.frame.height)")
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
            
             //_print(tb.selectedImage as Any)
            
              
             if tabBar.frame.width > 900 || ( _screenHeight == 1024 && _screenWidth == 768 ){ // iPad and ipad2 only

                //tb.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                tb.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
                if tb.tag == 3 {
                    tb.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
                }
              }
        }
 
        //---------------------
    }
    /*
    func configureTabBarItems() {
        let mainVC = ChooseLearningModeVC()
        let quizVC = QuizViewController()
        let listenVC = ListenViewController()
        let window = UIApplication.shared.keyWindow
        
        let viewControllers : Array = [listenVC, mainVC, quizVC]
        
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = viewControllers
        tabBarController.selectedIndex = 1
        
        
        tabBarController.tabBar.frame.size.height = 100
        
        //tabBarController.tabBar.layer.position = CGPoint(x: 10,y: 818)
        
        //let frame = tabBarController.tabBar.frame
        
        tabBarController.tabBar.dropShadow()
        tabBarController.tabBar.barTintColor = .lightGray
        
        
        setTabBarItemImage(vc: mainVC, image: "icons8-mind_map")
        setTabBarItemImage(vc: quizVC, image: "icons8-artificial_intelligence")
        setTabBarItemImage(vc: listenVC, image: "icons8-audio_wave")
        
        for vc in viewControllers {
            vc.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            vc.title = nil
        }
        //
    }
    
    func setTabBarItemImage(vc: UIViewController, image: String) {
        let item = UITabBarItem()
        item.title = "123"
        item.image = UIImage(named: image)
        vc.tabBarItem = item
    }
    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

//---------------------Change tabBar Height for iPad only
//Please change Class TabBar of TabBar Controller to CustomeTabBar in Storyboard
class CustomeTabBar: UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        
        var sizeThatFits = super.sizeThatFits(size)
        
        //_print("sizeThatFites: \(sizeThatFits)")
        
        if sizeThatFits.width > 1000 { //For iPad
            sizeThatFits.height = 83 //same as iPhoneX
        }
        else if _screenHeight == 1024 && sizeThatFits.width == 768 { //iPad2 only
            sizeThatFits.height = 83 //same as iPhoneX
        }
        return sizeThatFits
    }
}

