//
//  TodayActualViewController.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/8.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import TipCalcKit

class TodayActualViewController: UIViewController {
    
    @IBOutlet weak var subtotalField: UITextField!
    @IBOutlet weak var rateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    fileprivate let rateList = [0.1, 0.12, 0.15, 0.18, 0.2]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mainTintColor = TipCalcDataManager.widgetTintColor()
        
        rateSegmentedControl.tintColor = mainTintColor
        
        tipLabel.textColor = mainTintColor
        totalLabel.textColor = mainTintColor
        
        subtotalField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        subtotalField.tintColor = mainTintColor
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        toolBar.barStyle = .default
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let clearBtnItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearTextField))
        let doneBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideKeyboard))
        toolBar.setItems([clearBtnItem, flexibleItem, doneBtnItem], animated: true)
        toolBar.tintColor = mainTintColor
        subtotalField.inputAccessoryView = toolBar
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
        updateTips()
    }
    
    fileprivate func updateTips() {
        if let subtotal = subtotalField.text {
            if let subtotalDouble = Double(subtotal) {
                let (tip, total) = TipCalculator.tip(of: subtotalDouble, rate: rateList[rateSegmentedControl.selectedSegmentIndex])
                DispatchQueue.main.async {
                    self.tipLabel.text = String(tip)
                    self.totalLabel.text = String(total)
                }
            } else {
                DispatchQueue.main.async {
                    self.tipLabel.text = "$0.0"
                    self.totalLabel.text = "$0.0"
                }
            }
        }
    }
    
    @IBAction func segmentedControlIndexChanged() {
        updateTips()
    }

    @objc fileprivate func textDidChange() {
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
