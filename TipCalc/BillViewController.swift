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

    fileprivate let leftBtn: DynamicButton = {
        let leftBtn = DynamicButton(style: DynamicButtonStyle.close)
        leftBtn.strokeColor = TipCalcDataManager.widgetTintColor()
        leftBtn.bounceButtonOnTouch = false
        return leftBtn
    }()

    fileprivate let rightBtn: DynamicButton = {
        let rightBtn = DynamicButton(style: DynamicButtonStyle.arrowRight)
        rightBtn.strokeColor = TipCalcDataManager.widgetTintColor()
        rightBtn.bounceButtonOnTouch = false
        return rightBtn
    }()

    fileprivate let titleTextField: UITextField = {
        let titleTextField = UITextField(frame: .zero)
        titleTextField.placeholder = "Please input a title"
        titleTextField.font = UIFont.boldSystemFont(ofSize: 24.0)
        titleTextField.textColor = TipCalcDataManager.widgetTintColor()
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.adjustsFontSizeToFitWidth = true
        titleTextField.minimumFontSize = 8.0
        titleTextField.returnKeyType = .next
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidEndEditing), for: .editingDidEndOnExit)
        titleTextField.inputAccessoryView = UIView()
        return titleTextField
    }()
    
    fileprivate let billView: BillView = {
        let billView = BillView()
        billView.backgroundColor = UIColor.clear
        return billView
    }()
    
    fileprivate let saveBtn: UIButton = {
        let saveBtn = UIButton(type: .custom)
        saveBtn.setImage(UIImage(named: "ActionSave"), for: .normal)
        saveBtn.addTarget(self, action: #selector(saveBtnPressed), for: .touchUpInside)
        return saveBtn
    }()
    
    fileprivate let shareBtn: UIButton = {
        let shareBtn = UIButton(type: .custom)
        shareBtn.setImage(UIImage(named: "ActionShare"), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareBtnPressed), for: .touchUpInside)
        return shareBtn
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
            make.width.equalTo(28)
            make.height.equalTo(28)
        })
        leftBtn.addTarget(self, action: #selector(closeBtnPressed), for: .touchDown)
        
        self.view.addSubview(rightBtn)
        rightBtn.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(36)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(28)
            make.height.equalTo(28)
        })
        rightBtn.addTarget(self, action: #selector(nextBtnPressed), for: .touchDown)
        
        self.view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints({ make in
            make.centerY.equalToSuperview().offset(-160)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(28)
        })
        titleTextField.text = billItem.title
        titleTextField.becomeFirstResponder()
        
        self.view.addSubview(billView)
        billView.alpha = 0
        billView.snp.makeConstraints({ make in
            make.centerY.equalToSuperview().offset(-60)
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(240)
            make.left.equalToSuperview().offset(16+viewAnimationXShift)
        })
        
        self.view.addSubview(saveBtn)
        saveBtn.alpha = 0
        saveBtn.snp.makeConstraints({ make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalTo(billView.snp.centerX).offset(-80)
            make.top.equalTo(billView.snp.bottom).offset(80)
        })
        
        self.view.addSubview(shareBtn)
        shareBtn.alpha = 0
        shareBtn.snp.makeConstraints({ make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalTo(billView.snp.centerX).offset(80)
            make.top.equalTo(billView.snp.bottom).offset(80)
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
            self.shareBtn.alpha = 1.0
            self.saveBtn.alpha = 1.0
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
            self.saveBtn.alpha = 0.0
            self.shareBtn.alpha = 0.0
            self.view.layoutIfNeeded()
        })
        
    }
    
    @objc fileprivate func doneBtnPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func saveBtnPressed() {
        UIImageWriteToSavedPhotosAlbum(billView.billImage(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc fileprivate func shareBtnPressed() {
        let shareItems = [billItem.shareString, billView.billImage()] as [Any]
        
        let activityController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityController.modalPresentationStyle = .popover
        activityController.popoverPresentationController?.permittedArrowDirections = .any
        activityController.popoverPresentationController?.sourceView = shareBtn
        activityController.popoverPresentationController?.sourceRect = self.view.frame
        present(activityController, animated: true, completion: nil)
    }
    
    @objc fileprivate func titleTextFieldDidEndEditing() {
        nextBtnPressed()
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved", message: "Bill saved to your photo library.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
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
