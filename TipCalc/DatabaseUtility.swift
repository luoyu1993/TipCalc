//
//  DatabaseUtility.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/31.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import FMDB

class DatabaseUtility: NSObject {
    
    class fileprivate func createDatabase() -> FMDatabase? {
        let dbURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("bills.sqlite")
        guard let database = FMDatabase(path: dbURL.path) else {
            return nil
        }
        return database
    }
    
    class func createTable() {
        guard let database = createDatabase() else {
            return
        }
        
        guard database.open() else {
            return
        }
        
        do {
            try database.executeUpdate("CREATE TABLE bills(id integer primary key autoincrement, title text, date datetime, subtotal double, tipRate double, taxValue double, taxRate double, ppl integer, taxIncluded bool, tip double, total double, tipPpl double, totalPpl double)", values: nil)
        } catch {
            print(error.localizedDescription)
        }
        
        database.close()
    }
    
    class func itemsCount() -> Int {
        guard let database = createDatabase() else {
            return 0
        }
        
        guard database.open() else {
            return 0
        }
        
        var count = 0
        
        let rs = try! database.executeQuery("SELECT COUNT(*) FROM bills", values: nil)
        if rs.next() {
            count = Int(rs.int(forColumnIndex: 0))
        }
        database.close()
        return count
    }
    
    class func getBillItems() -> [BillItem] {
        var billItems: [BillItem] = []
        
        guard let database = createDatabase() else {
            return []
        }
        
        guard database.open() else {
            return []
        }
        
        do {
            let rs = try database.executeQuery("SELECT * FROM bills", values: nil)
            while rs.next() {
                let item = BillItem()
                
                item.title = rs.string(forColumn: "title")
                item.date = rs.date(forColumn: "date")
                item.subtotal = rs.double(forColumn: "subtotal")
                item.tipRate = rs.double(forColumn: "tipRate")
                item.taxValue = rs.double(forColumn: "taxValue")
                item.taxRate = rs.double(forColumn: "taxRate")
                item.ppl = Int(rs.int(forColumn: "ppl"))
                item.taxIncluded = rs.bool(forColumn: "taxIncluded")
                item.id = Int(rs.int(forColumn: "id"))
                
                let result = (rs.double(forColumn: "tip"), rs.double(forColumn: "total"), rs.double(forColumn: "tipPpl"), rs.double(forColumn: "totalPpl"))
                item.result = result
                
                billItems.append(item)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        database.close()
        return billItems
    }
    
    
    /// Get saved bill items for one specific page.
    ///
    /// - Parameter page: the index of page, start from 0
    /// - Returns: the array of bill item objects
    class func getBillItems(forPage page: Int) -> [BillItem] {
        let itemsPerPage = 20
        
        var billItems: [BillItem] = []
        
        guard let database = createDatabase() else {
            return []
        }
        
        guard database.open() else {
            return []
        }
        
        do {
            let rs = try database.executeQuery("SELECT * FROM bills LIMIT \(page * itemsPerPage),\(itemsPerPage)", values: nil)
            while rs.next() {
                let item = BillItem()
                
                item.title = rs.string(forColumn: "title")
                item.date = rs.date(forColumn: "date")
                item.subtotal = rs.double(forColumn: "subtotal")
                item.tipRate = rs.double(forColumn: "tipRate")
                item.taxValue = rs.double(forColumn: "taxValue")
                item.taxRate = rs.double(forColumn: "taxRate")
                item.ppl = Int(rs.int(forColumn: "ppl"))
                item.taxIncluded = rs.bool(forColumn: "taxIncluded")
                item.id = Int(rs.int(forColumn: "id"))
                
                let result = (rs.double(forColumn: "tip"), rs.double(forColumn: "total"), rs.double(forColumn: "tipPpl"), rs.double(forColumn: "totalPpl"))
                item.result = result
                
                billItems.append(item)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        database.close()
        return billItems
    }
    
    class func save(billItem: BillItem) -> Bool {
        guard let database = createDatabase() else {
            return false
        }
        
        guard database.open() else {
            return false
        }
        
        do {
            try database.executeUpdate("INSERT INTO bills (title, date, subtotal, tipRate, taxValue, taxRate, ppl, taxIncluded, tip, total, tipPpl, totalPpl) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", values: [billItem.title, billItem.date, billItem.subtotal, billItem.tipRate, billItem.taxValue, billItem.taxRate, billItem.ppl, billItem.taxIncluded, billItem.result.tip, billItem.result.total, billItem.result.tipPpl, billItem.result.totalPpl])
        } catch {
            print(error.localizedDescription)
            database.close()
            return false
        }
        
        database.close()
        return true
    }
    
    class func remove(billItem: BillItem) -> Bool {
        guard let database = createDatabase() else {
            return false
        }
        
        guard database.open() else {
            return false
        }
        
        do {
            try database.executeUpdate("DELETE FROM bills WHERE id=?", values: [billItem.id])
        } catch {
            print(error.localizedDescription)
            database.close()
            return false
        }
        
        database.close()
        return true
    }

}
