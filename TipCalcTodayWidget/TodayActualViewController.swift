//
//  TodayActualViewController.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/8.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import TipCalcKit
import LTMorphingLabel

class TodayActualViewController: UIViewController {
    
    @IBOutlet weak var subtotalField: UITextField!
    @IBOutlet weak var rateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tipLabel: LTMorphingLabel!
    @IBOutlet weak var totalLabel: LTMorphingLabel!
    @IBOutlet weak var tipPplLabel: LTMorphingLabel!
    @IBOutlet weak var totalPplLabel: LTMorphingLabel!
    @IBOutlet weak var pplField: UITextField!
    @IBOutlet weak var pplStepper: UIStepper!
    fileprivate var toolBar: UIToolbar!
    fileprivate var pplToolBar: UIToolbar!
    
    fileprivate var billItem = BillItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let defaultTipRateIndex = TipCalcDataManager.defaultTipRateIndex()
        rateSegmentedControl.selectedSegmentIndex = defaultTipRateIndex
        
        subtotalField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        pplField.addTarget(self, action: #selector(pplFieldTextDidChange), for: .editingChanged)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        toolBar.barStyle = .default
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let clearBtnItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearTextField))
        let doneBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideKeyboard))
        toolBar.setItems([clearBtnItem, flexibleItem, doneBtnItem], animated: true)
        subtotalField.inputAccessoryView = toolBar
        
        pplToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        pplToolBar.barStyle = .default
        let resetPplBtnItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetPplField))
        let donePplBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hidePplKeyboard))
        pplToolBar.setItems([resetPplBtnItem, flexibleItem, donePplBtnItem], animated: true)
        pplField.inputAccessoryView = pplToolBar
        
        setColors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func hideKeyboard() {
        subtotalField.resignFirstResponder()
    }
    
    @objc fileprivate func clearTextField() {
        subtotalField.text = ""
        billItem.subtotal = 0
        updateTips()
    }
    
    @objc fileprivate func hidePplKeyboard() {
        pplField.resignFirstResponder()
    }
    
    @objc fileprivate func resetPplField() {
        pplField.text = ""
        pplStepper.value = 1.0
        billItem.ppl = 1
        updateTips()
    }
    
    fileprivate func setColors() {
        let mainTintColor = TipCalcDataManager.widgetTintColor()
        
        TipCalcDataManager.setTintColors()
        
        let animatedEnabled = TipCalcDataManager.animatedLabel()
        
        tipLabel.textColor = mainTintColor
        tipLabel.morphingEffect = .evaporate
        tipLabel.morphingDuration = ANIMATION_DURATION
        tipLabel.morphingEnabled = animatedEnabled
        
        totalLabel.textColor = mainTintColor
        totalLabel.morphingEffect = .evaporate
        totalLabel.morphingDuration = ANIMATION_DURATION
        totalLabel.morphingEnabled = animatedEnabled
        
        tipPplLabel.textColor = mainTintColor
        tipPplLabel.morphingEffect = .evaporate
        tipPplLabel.morphingDuration = ANIMATION_DURATION
        tipPplLabel.morphingEnabled = animatedEnabled
        
        totalPplLabel.textColor = mainTintColor
        totalPplLabel.morphingEffect = .evaporate
        totalPplLabel.morphingDuration = ANIMATION_DURATION
        totalPplLabel.morphingEnabled = animatedEnabled
    }
    
    fileprivate func updateTips() {
        DispatchQueue.main.async {
            self.tipLabel.text = "$" + String(self.billItem.result.tip)
            self.totalLabel.text = "$" + String(self.billItem.result.total)
            self.tipPplLabel.text = "$" + String(self.billItem.result.tipPpl)
            self.totalPplLabel.text = "$" + String(self.billItem.result.totalPpl)
        }
    }
    
    @IBAction func segmentedControlIndexChanged() {
        billItem.tipRate = rateList[rateSegmentedControl.selectedSegmentIndex]
        updateTips()
    }
    
    @IBAction func stepperValueChanged() {
        pplField.text = String(Int(pplStepper.value))
        billItem.ppl = Int(pplStepper.value)
        updateTips()
    }

    @objc fileprivate func textDidChange() {
        if let subtotalDouble = Double(subtotalField.text!) {
            billItem.subtotal = subtotalDouble
        } else {
            billItem.subtotal = 0.0
        }
        updateTips()
    }
    
    @objc fileprivate func pplFieldTextDidChange() {
        if let pplInt = Int(pplField.text!) {
            pplStepper.value = Double(pplInt)
            billItem.ppl = pplInt
        } else {
            pplStepper.value = 1.0
            billItem.ppl = 1
        }
        updateTips()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
