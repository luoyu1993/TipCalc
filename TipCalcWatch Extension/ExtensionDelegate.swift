//
//  ExtensionDelegate.swift
//  TipCalcWatch Extension
//
//  Created by Yubo Qin on 2017/11/28.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import WatchKit
import WatchConnectivity

let NOTIFICATION_SETTINGS_UPDATED = "NOTIFICATION_SETTINGS_UPDATED"

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        WCSession.default.delegate = self
        WCSession.default.activate()
        WCSession.default.sendMessage(["cmd": "update"], replyHandler: { dict in
            TipCalcDataManager.shared.watchFeedback = dict[SETTING_WATCH_FEEDBACK] as! Bool
            TipCalcDataManager.shared.defaults.set(dict[SETTING_DEFAULT_TIP_RATE_INDEX], forKey: SETTING_DEFAULT_TIP_RATE_INDEX)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_SETTINGS_UPDATED), object: nil)
        }, errorHandler: { error in
            print(error)
        })
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        if message["cmd"] as! String == "update" {
//            TipCalcDataManager.shared.watchFeedback = message[SETTING_WATCH_FEEDBACK] as! Bool
//            TipCalcDataManager.shared.defaults.set(message[SETTING_DEFAULT_TIP_RATE_INDEX], forKey: SETTING_DEFAULT_TIP_RATE_INDEX)
//        }
    }

}
