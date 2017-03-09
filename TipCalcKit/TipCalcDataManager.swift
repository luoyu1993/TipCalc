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

class TipCalcDataManager: NSObject {
    
    class func widgetTintColor() -> UIColor {
        let userDefault = UserDefaults(suiteName: APP_GROUP_NAME)
        if let widgetTintColor = userDefault?.object(forKey: SETTING_WIDGET_TINT_COLOR) {
            return widgetTintColor as! UIColor
        } else {
            return UIColor.flatSkyBlue
        }
    }

}
