//
//  SettingViewController.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/8.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import TipCalcKit
import StoreKit

class SettingViewController: UITableViewController {
    
    @IBOutlet weak var roundSwitch: UISwitch!
    @IBOutlet weak var roundSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tintColorView: UIView!
    @IBOutlet weak var animatedSwitch: UISwitch!
    @IBOutlet weak var defaultTipRateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var shakeToClearSwitch: UISwitch!
    @IBOutlet weak var shakeToClearOptionSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        reloadSettings(animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enterForegroundReload), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func enterForegroundReload() {
        reloadSettings(animated: false)
    }
    
    fileprivate func reloadSettings(animated: Bool) {
        roundSwitch.isOn = UserDefaults(suiteName: APP_GROUP_NAME)?.bool(forKey: SETTING_ROUND_TOTAL) ?? false
        roundSegmentedControl.selectedSegmentIndex = (UserDefaults(suiteName: APP_GROUP_NAME)?.integer(forKey: SETTING_ROUND_TYPE))!
        animatedSwitch.isOn = TipCalcDataManager.animatedLabel()
        defaultTipRateSegmentedControl.selectedSegmentIndex = TipCalcDataManager.defaultTipRateIndex()
        shakeToClearSwitch.isOn = TipCalcDataManager.shakeToClear()
        shakeToClearOptionSegmentedControl.selectedSegmentIndex = TipCalcDataManager.shakeToClearOption()
        
        let mainTintColor = TipCalcDataManager.widgetTintColor()
        
        var interval = 0.0
        if animated {
            interval = 0.5
        }
        UIView.animate(withDuration: interval, animations: {
            self.tintColorView.backgroundColor = mainTintColor
            self.roundSwitch.tintColor = mainTintColor
            self.roundSwitch.onTintColor = mainTintColor
            self.roundSegmentedControl.tintColor = mainTintColor
            self.animatedSwitch.tintColor = mainTintColor
            self.animatedSwitch.onTintColor = mainTintColor
            self.defaultTipRateSegmentedControl.tintColor = mainTintColor
            self.navigationController!.tabBarController!.tabBar.tintColor = mainTintColor
            self.navigationController!.navigationBar.tintColor = mainTintColor
            self.shakeToClearSwitch.tintColor = mainTintColor
            self.shakeToClearSwitch.onTintColor = mainTintColor
            self.shakeToClearOptionSegmentedControl.tintColor = mainTintColor
        })
        
        TipCalcDataManager.setTintColors()
    }
    
    @IBAction func roundSwitchChanged() {
        UserDefaults(suiteName: APP_GROUP_NAME)?.set(roundSwitch.isOn, forKey: SETTING_ROUND_TOTAL)
    }
    
    @IBAction func roundSegmentedControlValueChanged() {
        UserDefaults(suiteName: APP_GROUP_NAME)?.set(roundSegmentedControl.selectedSegmentIndex, forKey: SETTING_ROUND_TYPE)
    }
    
    @IBAction func animatedSwitchChanged() {
        UserDefaults(suiteName: APP_GROUP_NAME)?.set(animatedSwitch.isOn, forKey: SETTING_ANIMATED_LABEL)
    }
    
    @IBAction func defaultTipRateSegmentedControlValueChanged() {
        UserDefaults(suiteName: APP_GROUP_NAME)?.set(defaultTipRateSegmentedControl.selectedSegmentIndex, forKey: SETTING_DEFAULT_TIP_RATE_INDEX)
    }
    
    @IBAction func shakeToClearSwitchChanged() {
        UserDefaults(suiteName: APP_GROUP_NAME)?.set(shakeToClearSwitch.isOn, forKey: SETTING_SHAKE_TO_CLEAR)
    }
    
    @IBAction func shakeToClearSegmentedControlChanged() {
        UserDefaults(suiteName: APP_GROUP_NAME)?.set(shakeToClearOptionSegmentedControl.selectedSegmentIndex, forKey: SETTING_SHAKE_TO_CLEAR_OPTION)
    }
    
    fileprivate func selectMainTintColor() {
        let alertController = UIAlertController(title: "Tint color", message: "Select the main tint color of the application", preferredStyle: .actionSheet)
        let colors = [
            ("Red", UIColor.flatRed),
            ("Orange", UIColor.flatOrange),
            ("Yellow", UIColor.flatYellow),
            ("Green", UIColor.flatGreen),
            ("Mint", UIColor.flatMint),
            ("Sky Blue", UIColor.flatSkyBlue),
            ("Magenta", UIColor.flatMagenta),
            ("Pink", UIColor.flatPink),
        ]
        for (colorName, color) in colors {
            let tmpAction = UIAlertAction(title: colorName, style: .default, handler: { action in
                UserDefaults(suiteName: APP_GROUP_NAME)?.set(NSKeyedArchiver.archivedData(withRootObject: color), forKey: SETTING_WIDGET_TINT_COLOR)
                self.reloadSettings(animated: true)
            })
            let tmpView = UIView(frame: CGRect(x: 0, y: 0, width: 27, height: 27))
            tmpView.backgroundColor = color
            let img = getImage(fromView: tmpView)
            tmpAction.setValue(img, forKey: "image")
            alertController.addAction(tmpAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.permittedArrowDirections = .any
        alertController.popoverPresentationController?.sourceView = self.tableView.cellForRow(at: IndexPath(row: 0, section: 2))
        alertController.popoverPresentationController?.sourceRect = self.view.frame
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func getImage(fromView view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { context in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image.withRenderingMode(.alwaysOriginal)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 0:
                tableView.deselectRow(at: indexPath, animated: false)
                selectMainTintColor()
            default:
                break
            }
        case 4:
            switch indexPath.row {
            case 1:
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                } else {
                    let url = URL(string: "itms-apps://itunes.apple.com/us/app/tipcalc-quick-tip-calculator-and-bill-splitter/id1214666400")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
            default:
                break
            }
        default:
            break
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
