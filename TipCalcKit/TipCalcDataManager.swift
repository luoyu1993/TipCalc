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

class TipCalcDataManager: NSObject {
    
    class func widgetTintColor() -> UIColor {
        let userDefault = UserDefaults(suiteName: APP_GROUP_NAME)
        if let widgetTintColorArchieve = userDefault?.object(forKey: SETTING_WIDGET_TINT_COLOR) {
            let widgetTintColor = NSKeyedUnarchiver.unarchiveObject(with: widgetTintColorArchieve as! Data)
            return widgetTintColor as! UIColor
        } else {
            return UIColor.flatSkyBlue
        }
    }
    
    class func setTintColors() {
        let mainTintColor = TipCalcDataManager.widgetTintColor()
        
        UISegmentedControl.appearance().tintColor = mainTintColor
        UIToolbar.appearance().tintColor = mainTintColor
        UIStepper.appearance().tintColor = mainTintColor
        UITextField.appearance().tintColor = mainTintColor
        UITabBar.appearance().tintColor = mainTintColor
        UISwitch.appearance().tintColor = mainTintColor
        UISwitch.appearance().onTintColor = mainTintColor
        UISlider.appearance().tintColor = mainTintColor
    }

}
