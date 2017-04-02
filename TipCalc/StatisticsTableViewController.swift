//
//  StatisticsTableViewController.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/4/1.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class StatisticsTableViewController: UITableViewController {
    
    fileprivate let recentBarView: BarChartView = {
        let recentBarView = BarChartView()
        recentBarView.setScaleEnabled(false)
        recentBarView.highlightPerTapEnabled = false
        recentBarView.dragEnabled = false
        
        recentBarView.xAxis.drawGridLinesEnabled = false
        recentBarView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        recentBarView.xAxis.granularity = 1.0
        recentBarView.xAxis.drawLabelsEnabled = false
        
        recentBarView.leftAxis.drawGridLinesEnabled = false
        recentBarView.leftAxis.axisMinimum = 0.0
        
        recentBarView.rightAxis.enabled = false
        
        recentBarView.chartDescription?.text = ""
        recentBarView.noDataText = "You need to save several bills before getting statistics."
        return recentBarView
    }()
    
    fileprivate let recentLineView: LineChartView = {
        let lineView = LineChartView()
        lineView.setScaleEnabled(false)
        lineView.dragEnabled = false
        lineView.highlightPerTapEnabled = false
        lineView.chartDescription?.text = ""
        
        lineView.noDataText = "You need to save several bills before getting statistics."
        
        lineView.xAxis.drawGridLinesEnabled = false
        lineView.xAxis.labelPosition = .bottom
        lineView.xAxis.granularity = 1.0
        lineView.xAxis.drawLabelsEnabled = false
        
        lineView.leftAxis.drawGridLinesEnabled = false
        lineView.leftAxis.axisMinimum = 0.0
        
        lineView.rightAxis.enabled = false
        
        return lineView
    }()
    
    fileprivate let tipRatePieView: PieChartView = {
        let tipRatePieView = PieChartView()
        
        tipRatePieView.chartDescription?.text = ""
        tipRatePieView.highlightPerTapEnabled = false
        
        tipRatePieView.drawEntryLabelsEnabled = false
        tipRatePieView.noDataText = "You need to save several bills before getting statistics."
        
        return tipRatePieView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        var insets = self.tableView.contentInset
        insets.top = (self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height
        insets.bottom = (self.tabBarController?.tabBar.bounds.size.height)!
        self.tableView.contentInset = insets
        self.tableView.scrollIndicatorInsets = insets
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setData() {
        let stat = DatabaseUtility.getStatistics()
        
        // recent line view
//        StatisticsUtility.setLineData(lineView: recentLineView, values: [11.4, 26.4, 18.1, 25.2, 37.5, 8.4], label: "Recent bills")
        if stat.recentBills.count > 0 {
            StatisticsUtility.setLineData(lineView: recentLineView, values: stat.recentBills, label: "Recent bills")
        }
        
        // tip rate pie view
        //        StatisticsUtility.setPieData(pieView: tipRatePieView, labels: ["10%", "12%", "15%", "18%", "20%", "Others"], values: [15, 23, 64, 25, 11, 4])
        if stat.tipRatesFrequency.count > 0 {
            StatisticsUtility.setPieData(pieView: tipRatePieView, labels: ["10%", "12%", "15%", "18%", "20%", "Others"], values: stat.tipRatesFrequency)
        }
        
        // recent bar view
//        StatisticsUtility.setBarData(barView: recentBarView, xLabels: [], values: [0, 0, 11.4, 26.4, 18.1, 25.2, 37.5, 8.4], title: "Recent 10 weeks")
        if stat.recent10Weeks.count > 0 {
            StatisticsUtility.setBarData(barView: recentBarView, xLabels: [], values: stat.recent10Weeks, title: "Recent 10 weeks")
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headers = ["Recent bills", "Tip rates", "Recent 10 weeks"]
        return headers[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.darkGray
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heights: [CGFloat] = [280.0, 320.0, 280.0]
        return heights[indexPath.section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            cell.addSubview(recentLineView)
            recentLineView.snp.makeConstraints({ make in
                make.edges.equalToSuperview().inset(8)
            })
        case 1:
            cell.addSubview(tipRatePieView)
            tipRatePieView.snp.makeConstraints({ make in
                make.edges.equalToSuperview().inset(8)
            })
        case 2:
            cell.addSubview(recentBarView)
            recentBarView.snp.makeConstraints({ make in
                make.edges.equalToSuperview().inset(8)
            })
        default:
            break
        }

        return cell
    }

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
