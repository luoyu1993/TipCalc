//
//  TipCalculator.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/7.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit

class TipCalculator: NSObject {
    
    class func tip(of subtotal: Double, rate: Double, splitBy ppl: Int) -> (Double, Double, Double, Double) {
        var tip = Double(subtotal * rate).roundTo(places: 2)
        var total = 0.0
        var tipPpl = 0.0
        var totalPpl = 0.0
        
        if UserDefaults(suiteName: APP_GROUP_NAME)?.bool(forKey: SETTING_ROUND_TOTAL) == false {
            total = Double(subtotal * (1 + rate)).roundTo(places: 2)
        } else {
            total = Double(subtotal * (1 + rate))
            switch UserDefaults(suiteName: APP_GROUP_NAME)!.integer(forKey: SETTING_ROUND_TYPE) {
            case 0:
                total.round(.toNearestOrEven)
            case 1:
                total.round(.down)
            case 2:
                total.round(.up)
            default:
                total.round(.toNearestOrEven)
            }
            tip = total - subtotal
        }
        
        tipPpl = (tip / Double(ppl)).roundTo(places: 2)
        totalPpl = (total / Double(ppl)).roundTo(places: 2)
        return (tip, total, tipPpl, totalPpl)
    }

}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
