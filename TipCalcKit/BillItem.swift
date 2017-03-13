//
//  BillItem.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/12.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit

class BillItem: NSObject {
    
    var tip = 0.0
    var total = 0.0
    var tipPpl = 0.0
    var totalPpl = 0.0
    var subtotal = 0.0
    var tipRate = rateList[TipCalcDataManager.defaultTipRateIndex()]
    var taxValue = 0.0
    var taxRate = 0.0
    var ppl = 1

}
