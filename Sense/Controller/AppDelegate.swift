//
//  AppDelegate.swift
//  Sense
//
//  Created by Bob Yuan on 2019/10/31.
//  Copyright © 2019 Bob Yuan. All rights reserved.
//

import UIKit

//August 9, 2020 by Tim
//Wrapper for print()
#if DEBUG //DEBUG is defined by Swift Compiler (Xcode)
//func _print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
func _print(_ items: Any...) {
    print(items)
}
#else
func _print(_ items: Any...) {
    return
}
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var initVC = sb.instantiateViewController(withIdentifier: "OnBoardingVC")
        
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "didPerformOnboarding") {
            initVC = sb.instantiateViewController(withIdentifier: "TabBarVC")
        }
        
        //Set rootViewController, so don't set Entry Point in Storyboard.
        //In the app's setting, go to your target and the Info tab. There clear the value of Main storyboard file base name. This will remove the following warning: Failed to instantiate the default view controller for UIMainStoryboardFile 'Main' - perhaps the designated entry point is not set? Be caureful, sometime happen with a black screen.
        window?.rootViewController = initVC
        
        if #available(iOS 10.0, *) {
            window?.makeKeyAndVisible()  //??? will crash on iPad2
        }
        
        _print("plocal storage ldata: \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)")
        
        
        return true
    }
    
    //August 9, 2020 by Tim
    //Set screen to portrait only
    var interfaceOrientations: UIInterfaceOrientationMask = .portrait /*{
        
        didSet {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }*/
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return interfaceOrientations
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //print("applicationDidEnterBackground: \(gVars.level) \(gVars.cellLevel)")
        let defaults = UserDefaults.standard
        let cL = defaults.integer(forKey: "cellLevel") 
        _print(cL)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        _print("applicationWillTerminate")
    }


}

extension UIView {
    func roundedTop(_ radius: CGFloat) {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight, .topLeft],
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func dropShadow(shadowColor: UIColor = UIColor.black,
                    fillColor: UIColor = UIColor.white,
                    opacity: Float = 0.2,
                    offset: CGSize = CGSize(width: 0.0, height: 5.0),
                    radius: CGFloat = 10) -> CAShapeLayer {
        
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        layer.insertSublayer(shadowLayer, at: 0)
        return shadowLayer
    }
}

// Defined by Tim on August 6, 2020
public var _screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
public var _screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}
