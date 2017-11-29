//
//  TipCalcDataManager.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/8.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit

let APP_GROUP_NAME = "group.cmu.yuboqin.tipcalc"

let SETTING_WIDGET_TINT_COLOR = "widgetTintColor"
let SETTING_ROUND_TOTAL = "roundTotal"
let SETTING_ROUND_TYPE = "roundType" // 0: standard, 1: down, 2: up
let SETTING_ANIMATED_LABEL = "animatedLabel"
let SETTING_DEFAULT_TIP_RATE_INDEX = "defaultTipRateIndex"
let SETTING_SHAKE_TO_CLEAR = "shakeToClear"
let SETTING_SHAKE_TO_CLEAR_OPTION = "shakeToClearOption" // 0: clear all, 1: save and clear
let SETTING_WATCH_FEEDBACK = "watchFeedback"

//let SHARED_BILL_ITEM = "sharedBillItem"

let ANIMATION_DURATION: Float = 0.25

class TipCalcDataManager: NSObject {
    
    static let shared = TipCalcDataManager()
    
    let defaults = UserDefaults(suiteName: APP_GROUP_NAME)!
    
    var watchFeedback: Bool {
        get {
            if defaults.object(forKey: SETTING_WATCH_FEEDBACK) == nil {
                defaults.set(true, forKey: SETTING_WATCH_FEEDBACK)
            }
            return defaults.bool(forKey: SETTING_WATCH_FEEDBACK)
        }
        set {
            defaults.set(newValue, forKey: SETTING_WATCH_FEEDBACK)
        }
    }
    
    var roundTotal: Bool {
        get {
            if defaults.object(forKey: SETTING_ROUND_TOTAL) == nil {
                defaults.set(false, forKey: SETTING_ROUND_TOTAL)
            }
            return defaults.bool(forKey: SETTING_ROUND_TOTAL)
        }
        set {
            defaults.set(newValue, forKey: SETTING_ROUND_TOTAL)
        }
    }
    
    var roundType: Int {
        get {
            if defaults.object(forKey: SETTING_ROUND_TYPE) == nil {
                defaults.set(0, forKey: SETTING_ROUND_TYPE)
            }
            return defaults.integer(forKey: SETTING_ROUND_TYPE)
        }
        set {
            defaults.set(newValue, forKey: SETTING_ROUND_TYPE)
        }
    }
    
    class func widgetTintColor() -> UIColor {
        let userDefault = UserDefaults(suiteName: APP_GROUP_NAME)
        if let widgetTintColorArchieve = userDefault?.object(forKey: SETTING_WIDGET_TINT_COLOR) {
            let widgetTintColor = NSKeyedUnarchiver.unarchiveObject(with: widgetTintColorArchieve as! Data)
            return widgetTintColor as! UIColor
        } else {
            return UIColor.flatSkyBlue
        }
    }
    
    class func animatedLabel() -> Bool {
        let userDefault = UserDefaults(suiteName: APP_GROUP_NAME)
        if userDefault?.object(forKey: SETTING_ANIMATED_LABEL) == nil {
            userDefault?.set(true, forKey: SETTING_ANIMATED_LABEL)
        }
        return userDefault!.bool(forKey: SETTING_ANIMATED_LABEL)
    }
    
    class func defaultTipRateIndex() -> Int {
        let userDefault = UserDefaults(suiteName: APP_GROUP_NAME)
        if userDefault?.object(forKey: SETTING_DEFAULT_TIP_RATE_INDEX) == nil {
            userDefault?.set(0, forKey: SETTING_DEFAULT_TIP_RATE_INDEX)
        }
        return userDefault!.integer(forKey: SETTING_DEFAULT_TIP_RATE_INDEX)
    }
    
    class func shakeToClear() -> Bool {
        let userDefault = UserDefaults(suiteName: APP_GROUP_NAME)
        if userDefault?.object(forKey: SETTING_SHAKE_TO_CLEAR) == nil {
            userDefault?.set(true, forKey: SETTING_SHAKE_TO_CLEAR)
        }
        return userDefault!.bool(forKey: SETTING_SHAKE_TO_CLEAR)
    }
    
    class func shakeToClearOption() -> Int {
        let userDefault = UserDefaults(suiteName: APP_GROUP_NAME)
        if userDefault?.object(forKey: SETTING_SHAKE_TO_CLEAR_OPTION) == nil {
            userDefault?.set(0, forKey: SETTING_SHAKE_TO_CLEAR_OPTION)
        }
        return userDefault!.integer(forKey: SETTING_SHAKE_TO_CLEAR_OPTION)
    }
    
    /*
    class func setSharedBillItem(item: BillItem) {
        let userDefault = UserDefaults(suiteName: APP_GROUP_NAME)
        let itemData = NSKeyedArchiver.archivedData(withRootObject: item)
        userDefault?.set(itemData, forKey: SHARED_BILL_ITEM)
    }
    
    class func removeSharedBillItem() {
        let userDefault = UserDefaults(suiteName: APP_GROUP_NAME)
        userDefault?.removeObject(forKey: SHARED_BILL_ITEM)
    }
    
    class func sharedBillItem() -> BillItem {
        let userDefault = UserDefaults(suiteName: APP_GROUP_NAME)
        let itemData = userDefault?.object(forKey: SHARED_BILL_ITEM)
        let item = NSKeyedUnarchiver.unarchiveObject(with: itemData as! Data)
        return item as! BillItem
    }
    */

}
