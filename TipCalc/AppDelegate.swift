//
//  AppDelegate.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/7.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import TipCalcKit
import IQKeyboardManagerSwift
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIShare.setTintColors()
        window?.tintColor = TipCalcDataManager.widgetTintColor()
        
        IQKeyboardManager.sharedManager().enable = true
        
        window?.backgroundColor = UIColor.white
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let _ = url.scheme, let query = url.query {
            let queryDic = query.queryDictionary()
            
            let tabBarController = self.window?.rootViewController as! UITabBarController
            tabBarController.selectedIndex = 0
            let tipCalcVC = tabBarController.viewControllers?[0] as! TipCalcViewController
            
            let item = BillItem()
            item.tipRate = Double(queryDic["tiprate"]!)!
            item.subtotal = Double(queryDic["subtotal"]!)!
            item.ppl = Int(queryDic["ppl"]!)!
            
            tipCalcVC.setBillItem(item: item)
        }
        
        return true
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message["cmd"] as! String == "update" {
            if session.isPaired && session.isWatchAppInstalled && session.activationState == .activated {
                replyHandler([
                    SETTING_WATCH_FEEDBACK: TipCalcDataManager.shared.watchFeedback,
                    SETTING_DEFAULT_TIP_RATE_INDEX: TipCalcDataManager.defaultTipRateIndex()
                ])
            }
        }
    }
}

extension String {
    
    func queryDictionary() -> [String: String] {
        var dic: [String: String] = [:]
        let kvPairList = self.components(separatedBy: "&")
        for kvPair in kvPairList {
            let kv = kvPair.components(separatedBy: "=")
            if kv.count == 2 {
                let key = kv[0]
                let value = kv[1]
                dic[key] = value
            }
        }
        return dic
    }
    
}

