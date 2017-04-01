//
//  RecordsTableViewCell.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/4/1.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(item: BillItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        titleLabel.text = item.title
        dateLabel.text = dateFormatter.string(from: item.date)
        priceLabel.text = "$\(item.result.totalPpl)"
        
        titleLabel.textColor = TipCalcDataManager.widgetTintColor()
        priceLabel.textColor = TipCalcDataManager.widgetTintColor()
    }
    
}
