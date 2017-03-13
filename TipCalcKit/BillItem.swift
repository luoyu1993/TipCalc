//
//  BillItem.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/12.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit

class BillItem: NSObject {
    
    var title = ""
    var date = NSDate()
    var subtotal = 0.0
    var tipRate = rateList[TipCalcDataManager.defaultTipRateIndex()]
    var taxValue = 0.0
    var taxRate = 0.0
    var ppl = 1
    var taxIncluded = true
    
    var result: (tip: Double, total: Double, tipPpl: Double, totalPpl: Double) {
        if taxIncluded {
            return TipCalculator.tip(of: subtotal.roundTo(places: 2), rate: tipRate, splitBy: ppl)
        } else {
            let subtotalWithTax = subtotal * (1 + taxRate)
            return TipCalculator.tip(of: subtotalWithTax.roundTo(places: 2), rate: tipRate, splitBy: ppl)
        }
    }
    
    func reset() {
        subtotal = 0.0
        tipRate = rateList[TipCalcDataManager.defaultTipRateIndex()]
        taxValue = 0.0
        taxRate = 0.0
        ppl = 1
        taxIncluded = true
    }

}