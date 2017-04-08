//
//  BillsContainerViewController.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/4/1.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit

let XAxisShift: CGFloat = 60.0

class BillsContainerViewController: UIViewController {
    
    // Parameters
    // Firstly set this to 0 and modify it in ViewDidLoad
    // therefore animation won't load at the first time of launch
    fileprivate var transitionInterval = 0.0
    
    @IBOutlet weak var switchControllerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    var currentViewController: UIViewController?
    
    fileprivate let recordsViewController: RecordsTableViewController = {
        let recordsViewController = RecordsTableViewController(style: .plain)
        return recordsViewController
    }()
    
    fileprivate let statisticsViewController: StatisticsTableViewController = {
        let statisticsViewController = StatisticsTableViewController(style: .grouped)
        return statisticsViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayCurrentSegmented(index: 0)
        transitionInterval = 0.3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Find the proper view controller for segmented control's index
    ///
    /// - Parameter index: selected index of segmented control
    /// - Returns: proper view controller
    fileprivate func viewControllerForIndex(index: Int) -> UIViewController {
        if index == 0 {
            return recordsViewController
        } else {
            return statisticsViewController
        }
    }
    
    fileprivate func displayCurrentSegmented(index: Int) {
        let viewController = viewControllerForIndex(index: index)
        
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        viewController.view.frame = self.contentView.bounds
        viewController.view.alpha = 0.0
        if switchControllerSegmentedControl.selectedSegmentIndex == 0 {
            viewController.view.frame.origin.x = 0 - XAxisShift
        } else {
            viewController.view.frame.origin.x = XAxisShift
        }
        self.contentView.addSubview(viewController.view)
        UIView.animate(withDuration: transitionInterval, animations: {
            viewController.view.alpha = 1.0
            viewController.view.frame.origin.x = 0
        })
        self.currentViewController = viewController
    }
    
    @IBAction func switchSegmentedControlChanged() {
        if let currentViewController = self.currentViewController {
            UIView.animate(withDuration: transitionInterval, animations: {
                if self.switchControllerSegmentedControl.selectedSegmentIndex == 0 {
                    currentViewController.view.frame.origin.x = XAxisShift
                } else {
                    currentViewController.view.frame.origin.x = 0 - XAxisShift
                }
                currentViewController.view.alpha = 0.0
            }, completion: { finished in
                if finished {
                    // Use the former controller instead of currentViewController
                    // If use currentViewController, while switching before the animation finishes,
                    // here 'currentViewController.view.removeFromSuperview()' will be executed,
                    // where 'currentViewController' actually is the new viewController which is
                    // expected to be displayed. Therefore the app would display a blank view
                    let formerController = self.viewControllerForIndex(index: 1 - self.switchControllerSegmentedControl.selectedSegmentIndex)
                    
                    formerController.view.removeFromSuperview()
                    formerController.removeFromParentViewController()
                }
            })
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
