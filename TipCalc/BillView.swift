//
//  BillView.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/13.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import SnapKit
import TipCalcKit

class BillView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPplLabel: UILabel!
    @IBOutlet weak var totalPplLabel: UILabel!
    
    fileprivate var billItem = BillItem()
    
    fileprivate let colorBackgroundView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        bgView.layer.cornerRadius = 15
        bgView.layer.masksToBounds = true
        return bgView
    }()
    
    fileprivate let shadowLayerView: UIView = {
        let shadowView = UIView()
        shadowView.layer.shadowColor = UIColor(white: 0.2, alpha: 1.0).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 5)
        shadowView.layer.shadowRadius = 30
        shadowView.layer.shadowOpacity = 0.5
        return shadowView
    }()

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.addSubview(shadowLayerView)
        shadowLayerView.snp.makeConstraints({ make in
            make.edges.equalToSuperview().inset(2)
        })
        
        shadowLayerView.addSubview(colorBackgroundView)
        colorBackgroundView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        let contentView: UIView = Bundle.main.loadNibNamed("BillContentView", owner: self, options: nil)![0] as! UIView
        colorBackgroundView.addSubview(contentView)
        contentView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        let mainTintColor = TipCalcDataManager.widgetTintColor()
        titleLabel.textColor = mainTintColor
        tipLabel.textColor = mainTintColor
        totalLabel.textColor = mainTintColor
        tipPplLabel.textColor = mainTintColor
        totalPplLabel.textColor = mainTintColor
    }
    
    func setBillItem(item: BillItem) {
        billItem = item
        
        titleLabel.text = billItem.title
        tipLabel.text = "$\(billItem.result.tip)"
        totalLabel.text = "$\(billItem.result.total)"
        tipPplLabel.text = "$\(billItem.result.tipPpl)"
        totalPplLabel.text = "$\(billItem.result.totalPpl)"
    }
    
    func billImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { context in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        return image.withRenderingMode(.alwaysOriginal)
    }

}
