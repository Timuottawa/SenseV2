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
        
        //Storyboard
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        //App version and build number
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! String
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]! as! String
        
        _print("App version:\(version), build:\(build)")
        
        // August 12, 2020 by Tim
        let initVC = sb.instantiateViewController(withIdentifier: "TabBarVC")
        
        //Set rootViewController, so don't set Entry Point in Storyboard.
        //In the app's setting, go to your target and the Info tab. There clear the value of Main storyboard file base name. This will remove the following warning: Failed to instantiate the default view controller for UIMainStoryboardFile 'Main' - perhaps the designated entry point is not set? Be caureful, sometime happen with a black screen.
        window?.rootViewController = initVC
        
        //if #available(iOS 10.0, *) {
        //window?.makeKeyAndVisible()  //??? will crash on iPad2 as of an entry defined in SB
        //}
        
        //Make the window visible
        window?.makeKeyAndVisible() //It's ok now, as no entry defined in SB, only here.
        
        //Running onBoarding for the first time or different version/build number
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "didPerformOnboarding") == false || userDefaults.string(forKey: "version") != version || userDefaults.string(forKey: "build") != build { // August 12, 2020 by Tim
            
            let obVC = sb.instantiateViewController(withIdentifier: "OnBoardingVC")
            obVC.modalPresentationStyle = .fullScreen
            window?.rootViewController?.present(obVC, animated: false, completion: nil)
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

