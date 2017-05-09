//
//  AppDelegate.swift
//  AC3.2-Final
//
//  Created by Jason Gresh on 2/14/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        let tabBarController = UITabBarController()
        //let loginVC = ViewController()
        let galleryVC = GalleryViewController()
        let uploadVC = UploadViewController()
        
        //let navController1 = UINavigationController(rootViewController: loginVC)
        let navControllerLeft = UINavigationController(rootViewController: galleryVC)
        let navControllerRight = UINavigationController(rootViewController: uploadVC)
        tabBarController.viewControllers = [navControllerLeft, navControllerRight]
        //UITabBar.appearance().tintColor = EyeVoteColor.accentColor
        //loginVC.tabBarItem = UITabBarItem(title: "Enter", image: #imageLiteral(resourceName: "upload"), tag: 0)
        galleryVC.tabBarItem = UITabBarItem(title: "Feed", image: #imageLiteral(resourceName: "chickenleg"), tag: 1)
        uploadVC.tabBarItem = UITabBarItem(title: "Gallery", image: #imageLiteral(resourceName: "camera_icon"), tag: 2)
        
        //tabBarController.tabBar.barTintColor = EyeVoteColor.lightPrimaryColor
        
        //navControllerLeft.navigationBar.barTintColor = UIColor.white
        //navControllerLeft.navigationBar.topItem?.title = "LOG IN / REGISTER"
        
        navControllerLeft.navigationBar.barTintColor = UIColor.white
        navControllerLeft.navigationBar.topItem?.title = "Unit6Final-stagram"
        
        
        navControllerRight.navigationBar.barTintColor = UIColor.white
        navControllerRight.navigationBar.topItem?.title = "Unit6Final-stagram"
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGray]
        
        let navigationBar = UINavigationController()
        navigationBar.setToolbarHidden(false, animated: false)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

