//
//  MsgDisplay.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/4/1.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import Toaster

class MsgDisplay: NSObject {
    
    class func show(message: String) {
        let toast = Toast(text: message, duration: Delay.short)
        toast.view.backgroundColor = UIColor.darkText
        toast.view.cornerRadius = 15.0
        toast.view.textInsets = UIEdgeInsetsMake(8, 16, 8, 16)
        toast.view.font = UIFont.systemFont(ofSize: 16.0)
        toast.view.bottomOffsetPortrait = 54
        toast.view.bottomOffsetLandscape = 54
        toast.show()
    }
    
    class func removeCurrentMessage() {
        if let currentToast = ToastCenter.default.currentToast {
            currentToast.cancel()
        }
    }
    
    class func removeAllMessage() {
        ToastCenter.default.cancelAll()
    }

}
