//
//  BillViewController.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/13.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import DynamicButton
import SnapKit

class BillViewController: UIViewController {
    
    var billItem: BillItem!

    fileprivate var leftBtn: DynamicButton = {
        let leftBtn = DynamicButton(style: DynamicButtonStyle.close)
        leftBtn.strokeColor = TipCalcDataManager.widgetTintColor()
        leftBtn.bounceButtonOnTouch = false
        return leftBtn
    }()

    fileprivate var rightBtn: DynamicButton = {
        let rightBtn = DynamicButton(style: DynamicButtonStyle.arrowRight)
        rightBtn.strokeColor = TipCalcDataManager.widgetTintColor()
        rightBtn.bounceButtonOnTouch = false
        return rightBtn
    }()

    fileprivate var titleTextField: UITextField = {
        let titleTextField = UITextField(frame: .zero)
        titleTextField.placeholder = "Please input a name"
        titleTextField.font = UIFont.boldSystemFont(ofSize: 24.0)
        titleTextField.textColor = TipCalcDataManager.widgetTintColor()
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.adjustsFontSizeToFitWidth = true
        titleTextField.minimumFontSize = 8.0
        return titleTextField
    }()
    
    fileprivate var billView: BillView = {
        let billView = BillView()
        billView.backgroundColor = UIColor.clear
        return billView
    }()
    
    fileprivate let dynamicButtonDelayInterval = 0.03
    fileprivate let viewAnimationXShift: Float = 240

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(leftBtn)
        leftBtn.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(24)
            make.height.equalTo(24)
        })
        leftBtn.addTarget(self, action: #selector(closeBtnPressed), for: .touchDown)
        
        self.view.addSubview(rightBtn)
        rightBtn.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(36)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(24)
            make.height.equalTo(24)
        })
        rightBtn.addTarget(self, action: #selector(nextBtnPressed), for: .touchDown)
        
        self.view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(120)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(28)
        })
        titleTextField.becomeFirstResponder()
        
        self.view.addSubview(billView)
        billView.alpha = 0
        billView.snp.makeConstraints({ make in
            make.centerY.equalToSuperview().offset(-60)
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(240)
            make.left.equalToSuperview().offset(16+viewAnimationXShift)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func closeBtnPressed() {
        titleTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func nextBtnPressed() {
        // Left: close -> previous
        
        leftBtn.isUserInteractionEnabled = false
        leftBtn.removeTarget(self, action: #selector(closeBtnPressed), for: .touchDown)
        leftBtn.addTarget(self, action: #selector(prevBtnPressed), for: .touchDown)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dynamicButtonDelayInterval, execute: {
            self.leftBtn.setStyle(DynamicButtonStyle.arrowLeft, animated: true)
            self.leftBtn.isUserInteractionEnabled = true
        })
        
        // Right: next -> done
        
        rightBtn.isUserInteractionEnabled = false
        self.rightBtn.removeTarget(self, action: #selector(self.nextBtnPressed), for: .touchDown)
        self.rightBtn.addTarget(self, action: #selector(self.doneBtnPressed), for: .touchDown)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dynamicButtonDelayInterval, execute: {
            self.rightBtn.setStyle(DynamicButtonStyle.checkMark, animated: true)
            self.rightBtn.isUserInteractionEnabled = true
        })
        
        billItem.title = titleTextField.text!
        
        titleTextField.snp.updateConstraints({ make in
            make.left.equalToSuperview().offset(16-viewAnimationXShift)
            make.right.equalToSuperview().offset(-16-viewAnimationXShift)
        })
        billView.snp.updateConstraints({ make in
            make.left.equalToSuperview().offset(16)
        })
        billView.setBillItem(item: billItem)
        UIView.animate(withDuration: 0.4, animations: {
            self.titleTextField.alpha = 0.0
            self.billView.alpha = 1.0
            self.view.layoutIfNeeded()
        })
        
        titleTextField.resignFirstResponder()
    }
    
    @objc fileprivate func prevBtnPressed() {
        
        titleTextField.becomeFirstResponder()
        
        // Left: prev -> close
        
        leftBtn.isUserInteractionEnabled = false
        leftBtn.removeTarget(self, action: #selector(prevBtnPressed), for: .touchDown)
        leftBtn.addTarget(self, action: #selector(closeBtnPressed), for: .touchDown)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dynamicButtonDelayInterval, execute: {
            self.leftBtn.setStyle(DynamicButtonStyle.close, animated: true)
            self.leftBtn.isUserInteractionEnabled = true
        })
        
        // Right: done -> next
        
        rightBtn.isUserInteractionEnabled = false
        rightBtn.removeTarget(self, action: #selector(doneBtnPressed), for: .touchDown)
        rightBtn.addTarget(self, action: #selector(nextBtnPressed), for: .touchDown)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dynamicButtonDelayInterval, execute: {
            self.rightBtn.setStyle(DynamicButtonStyle.arrowRight, animated: true)
            self.rightBtn.isUserInteractionEnabled = true
        })
        
        titleTextField.snp.updateConstraints({ make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        })
        billView.snp.updateConstraints({ make in
            make.left.equalToSuperview().offset(16+viewAnimationXShift)
        })
        UIView.animate(withDuration: 0.4, animations: {
            self.titleTextField.alpha = 1.0
            self.billView.alpha = 0.0
            self.view.layoutIfNeeded()
        })
        
    }
    
    @objc fileprivate func doneBtnPressed() {
        dismiss(animated: true, completion: nil)
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
