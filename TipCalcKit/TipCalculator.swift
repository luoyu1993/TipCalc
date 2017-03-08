//
//  TipCalculator.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/7.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit

class TipCalculator: NSObject {
    
    class func tip(of subtotal: Double, rate: Double) -> (Double, Double) {
        let tip = Double(subtotal * rate).roundTo(places: 2)
        let total = Double(subtotal * (1 + rate)).roundTo(places: 2)
        return (tip, total)
    }

}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
