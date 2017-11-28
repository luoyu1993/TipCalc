//
//  TipCalculator.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/7.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit

let rateList = [0.1, 0.12, 0.15, 0.18, 0.2]

class TipCalculator: NSObject {
    
    enum RoundRule: Int {
        case standard
        case down
        case up
        
        var rawValue: Int {
            switch self {
            case .standard:
                return 0
            case .down:
                return 1
            case .up:
                return 2
            }
        }
    }
    
    class func tip(of subtotal: Double, rate: Double, splitBy ppl: Int, round: Bool, roundRule: RoundRule) -> (tip: Double, total: Double, tipPpl: Double, totalPpl: Double) {
        var tip = Double(subtotal * rate).roundTo(places: 2)
        var total = 0.0
        var tipPpl = 0.0
        var totalPpl = 0.0
        
        if round == false {
            total = Double(subtotal * (1 + rate)).roundTo(places: 2)
        } else {
            total = Double(subtotal * (1 + rate))
            switch roundRule {
            case .standard:
                total.round(.toNearestOrEven)
            case .down:
                total.round(.down)
            case .up:
                total.round(.up)
            }
            tip = total - subtotal
            if tip < 0 {
                tip += 1
                total += 1
            }
        }
        
        tipPpl = (tip / Double(ppl)).roundTo(places: 2)
        totalPpl = (total / Double(ppl)).roundTo(places: 2)
        return (tip, total, tipPpl, totalPpl)
    }
    
    class func tip(of subtotal: Double, rate: Double, splitBy ppl: Int) -> (tip: Double, total: Double, tipPpl: Double, totalPpl: Double) {
        let round = UserDefaults(suiteName: APP_GROUP_NAME)?.bool(forKey: SETTING_ROUND_TOTAL)
        let roundRule = RoundRule(rawValue: UserDefaults(suiteName: APP_GROUP_NAME)!.integer(forKey: SETTING_ROUND_TYPE))
        return tip(of: subtotal, rate: rate, splitBy: ppl, round: round!, roundRule: roundRule!)
    }
    
    class func tip(of subtotal: Double, rate: Double) -> (tip: Double, total: Double) {
        let tuple = tip(of: subtotal, rate: rate, splitBy: 1)
        return (tuple.tip, tuple.total)
    }

}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
