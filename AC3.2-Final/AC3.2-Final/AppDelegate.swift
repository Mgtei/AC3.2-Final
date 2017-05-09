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
        FIRApp.configure()
        
        let tabBarController = UITabBarController()
        let galleryVC = GalleryViewController()
        let uploadVC = UploadViewController()
        
        let navControllerLeft = UINavigationController(rootViewController: galleryVC)
        let navControllerRight = UINavigationController(rootViewController: uploadVC)
        tabBarController.viewControllers = [navControllerLeft, navControllerRight]
        
        galleryVC.tabBarItem = UITabBarItem(title: "Feed", image: #imageLiteral(resourceName: "chickenleg"), tag: 1)
        uploadVC.tabBarItem = UITabBarItem(title: "Gallery", image: #imageLiteral(resourceName: "camera_icon"), tag: 2)
        
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

}
