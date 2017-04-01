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
        
        recentBarView.xAxis.drawGridLinesEnabled = false
        recentBarView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        recentBarView.xAxis.granularity = 1.0
        recentBarView.xAxis.drawLabelsEnabled = false
        
        recentBarView.leftAxis.drawGridLinesEnabled = false
        recentBarView.leftAxis.axisMinimum = 0.0
        
        recentBarView.rightAxis.enabled = false
        
        recentBarView.chartDescription?.text = ""
        return recentBarView
    }()
    
    fileprivate let tipRatePieView: PieChartView = {
        let tipRatePieView = PieChartView()
        
        tipRatePieView.chartDescription?.text = ""
        tipRatePieView.highlightPerTapEnabled = false
        
        return tipRatePieView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
        
        self.tableView.layoutIfNeeded()
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
        // recent bar view
        setBarData(barView: recentBarView, xLabels: [], values: [11.4, 26.4, 18.1, 25.2, 37.5, 8.4])
        
        // tip rate pie view
        setPieData(pieView: tipRatePieView, labels: ["10%", "12%", "15%", "18%", "20%", "Others"], values: [15, 23, 64, 25, 11, 4])
    }
    
    fileprivate func setBarData(barView: BarChartView, xLabels: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0 ..< values.count {
            let dataEntry = BarChartDataEntry(x: Double(i + 1), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Recent bills")
        chartDataSet.colors = [TipCalcDataManager.widgetTintColor()]
        let chartData = BarChartData(dataSets: [chartDataSet])
        
        barView.data = chartData
        
    }
    
    fileprivate func setPieData(pieView: PieChartView, labels: [String], values: [Double]) {
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0 ..< labels.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: labels[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = [UIColor.flatRed, UIColor.flatYellow, UIColor.flatGreen, UIColor.flatSkyBlue, UIColor.flatMagenta, UIColor.flatPink]
        let chartData = PieChartData(dataSets: [chartDataSet])
        
        pieView.data = chartData
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headers = ["Recent bills", "Tip rates"]
        return headers[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.darkGray
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heights: [CGFloat] = [280.0, 320.0]
        return heights[indexPath.section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            cell.addSubview(recentBarView)
            recentBarView.snp.makeConstraints({ make in
                make.edges.equalToSuperview().inset(8)
            })
        case 1:
            cell.addSubview(tipRatePieView)
            tipRatePieView.snp.makeConstraints({ make in
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
