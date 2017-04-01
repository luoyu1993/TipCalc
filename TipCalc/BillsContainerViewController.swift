//
//  BillsContainerViewController.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/4/1.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit

class BillsContainerViewController: UIViewController {
    
    @IBOutlet weak var switchControllerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    var currentViewController: UIViewController?
    
    fileprivate let recordsViewController: RecordsTableViewController = {
        let recordsViewController = RecordsTableViewController(style: .plain)
        return recordsViewController
    }()
    
    fileprivate let statisticsViewController: StatisticsTableViewController = {
        let statisticsViewController = StatisticsTableViewController(style: .plain)
        return statisticsViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayCurrentSegmented(index: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func displayCurrentSegmented(index: Int) {
        let viewController: UIViewController = {
            if index == 0 {
                return recordsViewController
            } else {
                return statisticsViewController
            }
        }()
        
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        viewController.view.frame = self.contentView.bounds
        self.contentView.addSubview(viewController.view)
        self.currentViewController = viewController
    }
    
    @IBAction func switchSegmentedControlChanged() {
        if let currentViewController = self.currentViewController {
            currentViewController.view.removeFromSuperview()
            currentViewController.removeFromParentViewController()
        }
        displayCurrentSegmented(index: switchControllerSegmentedControl.selectedSegmentIndex)
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
