//
//  InterfaceController.swift
//  TipCalcWatch Extension
//
//  Created by Yubo Qin on 2017/11/28.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var subtotalLabel: WKInterfaceLabel!
    @IBOutlet weak var tipLabel: WKInterfaceLabel!
    
    var subtotalString = "0"
    var dotFlag = false
    var tipRate = rateList[TipCalcDataManager.defaultTipRateIndex()]
    var shouldFeedback = TipCalcDataManager.shared.watchFeedback

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        NotificationCenter.default.addObserver(self, selector: #selector(updateSettings), name: NSNotification.Name(rawValue: NOTIFICATION_SETTINGS_UPDATED), object: nil)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @objc private func updateSettings() {
        tipRate = rateList[TipCalcDataManager.defaultTipRateIndex()]
        shouldFeedback = TipCalcDataManager.shared.watchFeedback
        updateTip()
    }
    
    @IBAction func numPressed1() {
        numPressed(num: 1)
    }
    
    @IBAction func numPressed2() {
        numPressed(num: 2)
    }
    
    @IBAction func numPressed3() {
        numPressed(num: 3)
    }
    
    @IBAction func numPressed4() {
        numPressed(num: 4)
    }
    
    @IBAction func numPressed5() {
        numPressed(num: 5)
    }
    
    @IBAction func numPressed6() {
        numPressed(num: 6)
    }
    
    @IBAction func numPressed7() {
        numPressed(num: 7)
    }
    
    @IBAction func numPressed8() {
        numPressed(num: 8)
    }
    
    @IBAction func numPressed9() {
        numPressed(num: 9)
    }
    
    @IBAction func numPressed0() {
        numPressed(num: 0)
    }
    
    @IBAction func dotPressed() {
        if shouldFeedback {
            WKInterfaceDevice.current().play(.click)
        }
        if !dotFlag {
            dotFlag = true
            subtotalString = "\(subtotalString)."
            subtotalLabel.setText(subtotalString)
        }
    }
    
    @IBAction func clearPressed() {
        if shouldFeedback {
            WKInterfaceDevice.current().play(.click)
        }
        subtotalString = "0"
        dotFlag = false
        subtotalLabel.setText("0")
        tipLabel.setText("0")
    }
    
    @IBAction func delPressed() {
        if shouldFeedback {
            WKInterfaceDevice.current().play(.click)
        }
        if subtotalString == "0" {
            return
        }
        if subtotalString.count == 1 {
            subtotalString = "0"
        } else {
            subtotalString.removeLast()
        }
        subtotalLabel.setText(subtotalString)
        updateTip()
    }
    
    @IBAction func rateSelected12() {
        tipRate = 0.12
        updateTip()
    }
    
    @IBAction func rateSelected15() {
        tipRate = 0.15
        updateTip()
    }
    
    @IBAction func rateSelected18() {
        tipRate = 0.18
        updateTip()
    }
    
    @IBAction func rateSelected20() {
        tipRate = 0.20
        updateTip()
    }
    
    private func numPressed(num: Int) {
        if shouldFeedback {
            WKInterfaceDevice.current().play(.click)
        }
        if subtotalString == "0" {
            subtotalString = "\(num)"
        } else {
            subtotalString = "\(subtotalString)\(num)"
        }
        subtotalLabel.setText(subtotalString)
        updateTip()
    }
    
    private func updateTip() {
        if let subtotal = Double(subtotalString) {
            let tuple = TipCalculator.tip(of: subtotal, rate: tipRate)
            tipLabel.setText("\(tuple.tip)")
        }
    }

}
