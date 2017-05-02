//
//  RecordsTableViewController.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/4/1.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import Hero
import DZNEmptyDataSet

class RecordsTableViewController: UITableViewController {
    
    var dataArr: [BillItem] = []
    var searchResults: [BillItem] = []
    
    fileprivate let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = true
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        self.tableView.register(UINib(nibName: "RecordsTableViewCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.estimatedRowHeight = 74
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        self.tableView.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataArr = DatabaseUtility.shared.getBillItems()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.searchController.isActive {
            self.searchController.isActive = false
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

//        var insets = self.tableView.contentInset
//        insets.top = (self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height
//        insets.bottom = (self.tabBarController?.tabBar.bounds.size.height)!
//        self.tableView.contentInset = insets
//        self.tableView.scrollIndicatorInsets = insets
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return searchResults.count
        } else {
            return dataArr.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! RecordsTableViewCell
        
        let item: BillItem = {
            if searchController.isActive && searchController.searchBar.text != "" {
                return searchResults[indexPath.row]
            } else {
                return dataArr[indexPath.row]
            }
        }()
        
        cell.setItem(item: item)
        cell.titleLabel.heroID = "titleLabel_\(item.id)"
        cell.priceLabel.heroID = "totalPplLabel_\(item.id)"
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { action, indexPath in
            if self.searchController.isActive && self.searchController.searchBar.text != "" {
                _ = DatabaseUtility.shared.remove(billItem: self.searchResults[indexPath.row])
                self.searchResults.remove(at: indexPath.row)
            } else {
                _ = DatabaseUtility.shared.remove(billItem: self.dataArr[indexPath.row])
                self.dataArr.remove(at: indexPath.row)
            }
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        })
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recordDetailViewController = RecordDetailViewController()
        if searchController.isActive && searchController.searchBar.text != "" {
            recordDetailViewController.billItem = self.searchResults[indexPath.row]
        } else {
            recordDetailViewController.billItem = self.dataArr[indexPath.row]
        }
        recordDetailViewController.heroModalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        self.tabBarController?.present(recordDetailViewController, animated: true, completion: {
            
        })
    }

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


    // MARK: - Navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    */

}

extension RecordsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        searchResults = dataArr.filter({ $0.title.lowercased().contains(searchBar.text!.lowercased()) })
        self.tableView.reloadData()
    }
    
}

extension RecordsTableViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataArr = DatabaseUtility.shared.getBillItems()
        self.tableView.reloadData()
    }
    
}

extension RecordsTableViewController: DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var str = ""
        if searchController.isActive && searchController.searchBar.text != "" {
            str = "Nothing Found"
        } else {
            str = "No Data"
        }
        
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0),
                          NSForegroundColorAttributeName: UIColor.darkGray]
        let attrStr = NSAttributedString(string: str, attributes: attributes)
        return attrStr
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var str = ""
        if searchController.isActive && searchController.searchBar.text != "" {
            str = "Please enter another keyword and retry."
        } else {
            str = "You can save some bills from the main view."
        }
        
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0),
                          NSForegroundColorAttributeName: UIColor.lightGray]
        let attrStr = NSAttributedString(string: str, attributes: attributes)
        return attrStr
    }
    
}

extension RecordsTableViewController: DZNEmptyDataSetDelegate {
    
}
