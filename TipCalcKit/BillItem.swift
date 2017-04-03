//
//  BillItem.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/12.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit

class BillItem: NSObject {
    
    var id = 0
    var title = ""
    var date = Date()
    var subtotal = 0.0
    var tipRate = rateList[TipCalcDataManager.defaultTipRateIndex()]
    var taxValue = 0.0
    var taxRate = 0.0
    var ppl = 1
    var taxIncluded = true
    
    var result: (tip: Double, total: Double, tipPpl: Double, totalPpl: Double) {
        get {
            if taxIncluded {
                return TipCalculator.tip(of: subtotal.roundTo(places: 2), rate: tipRate, splitBy: ppl)
            } else {
                let subtotalWithTax = subtotal * (1 + taxRate)
                return TipCalculator.tip(of: subtotalWithTax.roundTo(places: 2), rate: tipRate, splitBy: ppl)
            }
        }
        set {
            // Nothing different
        }
    }
    
    var shareString: String {
        return "\(title)\nTip: $\(result.tip), Total: $\(result.total)\nThe bill is shared with \(ppl) people.\nTip for each: $\(result.tipPpl), Total for each: $\(result.totalPpl)\nGenerated by TipCalc(https://appsto.re/us/GALzib.i)"
    }

}
