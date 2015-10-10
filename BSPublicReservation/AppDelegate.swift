//
//  AppDelegate.swift
//  BSPublicReservation
//
//  Created by IT on 2015. 4. 28..
//  Copyright (c) 2015년 KimDaeho. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //내부 저장소에 저장하는 기능 initPlist를 통하여 아이폰 내부에 저장함
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        initPlist()
        return true
    }
    func initPlist(){
        let fileManager = NSFileManager()
        var path = NSString()
        path = getPlistPath()
        let success = fileManager.fileExistsAtPath(path as String)
        
        //myFavorite.plist 파일이 없는 경우, success = false 이므로 메인번들에서 myFavortie.plist 붙여 복사한다.
        if(!success){
            let defalutPath = NSBundle.mainBundle().resourcePath?.stringByAppendingString("/myFavorite.plist")
            //let defalutPath =
            //let resultPath = NSURL.URLByAppendingPathComponent(NSURL(fileURLWithPath: "/myFavorite.plist"))
            do {
                try fileManager.copyItemAtPath(defalutPath!, toPath: path as String)
            } catch _ {
            }
        }
        
    }
    //Plist파일을 가져오는 기능
    func getPlistPath() -> String {
        var docsDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docPath = docsDir[0] 
        let fullName = docPath.stringByAppendingString("/myFavorite.plist")
        
        return fullName
    
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

