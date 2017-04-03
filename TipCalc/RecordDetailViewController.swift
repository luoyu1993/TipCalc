//
//  RecordDetailViewController.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/4/1.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import SnapKit
import DynamicButton
import Hero

class RecordDetailViewController: UIViewController {
    
    var billItem: BillItem!
    
    fileprivate let backgroundView: UIView = {
//        let blurEffect = UIBlurEffect(style: .light)
//        let visualEffectView = UIVisualEffectView(effect: blurEffect)
//        return visualEffectView
        let bgView = UIControl()
        bgView.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        return bgView
    }()
    
    fileprivate let leftBtn: DynamicButton = {
        let leftBtn = DynamicButton(style: DynamicButtonStyle.close)
        leftBtn.strokeColor = TipCalcDataManager.widgetTintColor()
        leftBtn.bounceButtonOnTouch = false
        return leftBtn
    }()
    
    fileprivate let billView: BillView = {
        let billView = BillView()
        billView.backgroundColor = UIColor.clear
        return billView
    }()
    
    fileprivate let shareBtn: UIButton = {
        let shareBtn = UIButton(type: .custom)
        shareBtn.setImage(UIImage(named: "ActionShare"), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareBtnPressed), for: .touchUpInside)
        return shareBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        self.view.addSubview(leftBtn)
        leftBtn.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(28)
            make.height.equalTo(28)
        })
        leftBtn.addTarget(self, action: #selector(closeBtnPressed), for: .touchDown)
        
        self.view.addSubview(billView)
        billView.snp.makeConstraints({ make in
            make.centerY.equalToSuperview().offset(-60)
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(240)
            make.left.equalToSuperview().offset(16)
        })
        billView.setBillItem(item: billItem)
        billView.titleLabel.heroID = "titleLabel_\(billItem.id)"
        billView.totalPplLabel.heroID = "totalPplLabel_\(billItem.id)"
        
        self.view.addSubview(shareBtn)
        shareBtn.snp.makeConstraints({ make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalTo(billView.snp.centerX)
            make.top.equalTo(billView.snp.bottom).offset(80)
        })
        
        self.isHeroEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func shareBtnPressed() {
        let shareItems = [billItem.shareString, billView.billImage()] as [Any]
        
        let activityController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityController.modalPresentationStyle = .popover
        activityController.popoverPresentationController?.permittedArrowDirections = .any
        activityController.popoverPresentationController?.sourceView = shareBtn
        activityController.popoverPresentationController?.sourceRect = self.view.frame
        present(activityController, animated: true, completion: nil)
    }
    
    @objc fileprivate func closeBtnPressed() {
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
