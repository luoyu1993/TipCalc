//
//  TodayViewController.swift
//  TipCalcTodayWidget
//
//  Created by Qin Yubo on 2017/3/7.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import SnapKit
import NotificationCenter
import TipCalcKit
import TipCalcKit.Swift

class TodayViewController: UIViewController, NCWidgetProviding {
    
    fileprivate let actualViewController: TodayActualViewController = {
        let actualViewController = TodayActualViewController(nibName: "TodayActualViewController", bundle: nil)
        actualViewController.modalTransitionStyle = .crossDissolve
        return actualViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
//        showActualController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showActualController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        actualViewController.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0.0, height: 220.0)
        } else if activeDisplayMode == .compact {
            preferredContentSize = maxSize
        }
    }
    
    fileprivate func showActualController() {
        actualViewController.rootController = self
        present(actualViewController, animated: false, completion: nil)
    }
    
    func openOutsideURL(url: URL) {
        extensionContext?.open(url, completionHandler: nil)
    }
    
}
