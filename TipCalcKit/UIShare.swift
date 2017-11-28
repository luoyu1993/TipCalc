//
//  UIShare.swift
//  TipCalc
//
//  Created by Yubo Qin on 2017/11/28.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit

class UIShare {
    
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
        UIButton.appearance().tintColor = mainTintColor
        UINavigationBar.appearance().tintColor = mainTintColor
    }

}
