//
//  CompleteCalcViewController.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/10.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import SnapKit
import TipCalcKit

class CompleteCalcViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var resultsView: UIVisualEffectView!
    
    var subtotalField: UITextField = {
        let subtotalField = UITextField(frame: .zero)
        subtotalField.placeholder = "$0.0"
        subtotalField.font = UIFont.boldSystemFont(ofSize: 24.0)
        subtotalField.keyboardType = .decimalPad
        subtotalField.textAlignment = .right
        subtotalField.clearButtonMode = .whileEditing
        subtotalField.addTarget(self, action: #selector(subtotalFieldChanged), for: .editingChanged)
        return subtotalField
    }()
    var taxIncludedSwitch: UISwitch = {
        let taxIncludedSwitch = UISwitch()
        taxIncludedSwitch.addTarget(self, action: #selector(taxIncludedSwitchChanged), for: .valueChanged)
        taxIncludedSwitch.isOn = true
        return taxIncludedSwitch
    }()
    var taxValueField: UITextField = {
        let taxValueField = UITextField(frame: .zero)
        taxValueField.placeholder = "$0.0"
        taxValueField.keyboardType = .decimalPad
        taxValueField.textAlignment = .right
        taxValueField.clearButtonMode = .whileEditing
        taxValueField.addTarget(self, action: #selector(taxValueFieldChanged), for: .editingChanged)
        return taxValueField
    }()
    var taxRateField: UITextField = {
        let taxRateField = UITextField(frame: .zero)
        taxRateField.placeholder = "0%"
        taxRateField.keyboardType = .decimalPad
        taxRateField.textAlignment = .right
        taxRateField.clearButtonMode = .whileEditing
        taxRateField.addTarget(self, action: #selector(taxRateFieldChanged), for: .editingChanged)
        return taxRateField
    }()
    var tipRateTypeSegmentedControl: UISegmentedControl = {
        let tipRateTypeSegmentedControl = UISegmentedControl(items: ["Common", "Custom"])
        tipRateTypeSegmentedControl.selectedSegmentIndex = 0
        tipRateTypeSegmentedControl.addTarget(self, action: #selector(tipRateTypeSegmentedControlChanged), for: .valueChanged)
        return tipRateTypeSegmentedControl
    }()
    var commonRateSegmentedControl: UISegmentedControl = {
        let commonRateSegmentedControl = UISegmentedControl(items: ["10%", "12%", "15%", "18%", "20%"])
        commonRateSegmentedControl.selectedSegmentIndex = 0
        commonRateSegmentedControl.addTarget(self, action: #selector(commonRateSegmentedControlChanged), for: .valueChanged)
        return commonRateSegmentedControl
    }()
    var customTipRateField: UITextField = {
        let customTipRateField = UITextField(frame: .zero)
        customTipRateField.placeholder = "0%"
        customTipRateField.keyboardType = .decimalPad
        customTipRateField.textAlignment = .right
        customTipRateField.clearButtonMode = .whileEditing
        customTipRateField.addTarget(self, action: #selector(customTipRateFieldChanged), for: .editingChanged)
        return customTipRateField
    }()
    var customTipRateSlider: UISlider = {
        let customTipRateSlider = UISlider(frame: .zero)
        customTipRateSlider.minimumValue = 0.0
        customTipRateSlider.maximumValue = 100.0
        customTipRateSlider.isContinuous = true
        customTipRateSlider.addTarget(self, action: #selector(customTipRateSliderChanged), for: .valueChanged)
        return customTipRateSlider
    }()
    var pplField: UITextField = {
        let pplField = UITextField(frame: .zero)
        pplField.placeholder = "1"
        pplField.keyboardType = .numberPad
        pplField.textAlignment = .right
        pplField.clearButtonMode = .whileEditing
        pplField.addTarget(self, action: #selector(pplFieldChanged), for: .editingChanged)
        return pplField
    }()
    var pplSlider: UISlider = {
        let pplSlider = UISlider(frame: .zero)
        pplSlider.minimumValue = 1
        pplSlider.maximumValue = 10
        pplSlider.isContinuous = true
        pplSlider.addTarget(self, action: #selector(pplSliderChanged), for: .valueChanged)
        return pplSlider
    }()
    var clearBtn: UIButton = {
        let clearBtn = UIButton(type: .system)
        clearBtn.setTitle("Clear all", for: .normal)
        clearBtn.addTarget(self, action: #selector(clearBtnPressed), for: .touchUpInside)
        clearBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return clearBtn
    }()
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPplLabel: UILabel!
    @IBOutlet weak var totalPplLabel: UILabel!
    
    fileprivate var tip = 0.0
    fileprivate var total = 0.0
    fileprivate var tipPpl = 0.0
    fileprivate var totalPpl = 0.0
    fileprivate var subtotal = 0.0
    fileprivate var tipRate = 0.1
    fileprivate var taxValue = 0.0
    fileprivate var taxRate = 0.0
    fileprivate var ppl = 1
    
    fileprivate let rateList = [0.1, 0.12, 0.15, 0.18, 0.2]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.contentInset = UIEdgeInsets(top: 144, left: 0, bottom: 44, right: 0)
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray
        resultsView.addSubview(lineView)
        lineView.snp.makeConstraints({ make in
            make.width.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setColors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setColors() {
        let mainTintColor = TipCalcDataManager.widgetTintColor()
        tipLabel.textColor = mainTintColor
        totalLabel.textColor = mainTintColor
        tipPplLabel.textColor = mainTintColor
        totalPplLabel.textColor = mainTintColor
    }
    
    @objc fileprivate func taxIncludedSwitchChanged() {
        if taxIncludedSwitch.isOn {
            // Change to On
            print("Include tax")
            taxValue = 0.0
            taxRate = 0.0
            if let subtotalValue = Double(subtotalField.text!) {
                subtotal = subtotalValue
            }
        } else {
            if let taxValueDouble = Double(taxRateField.text!) {
                taxValue = taxValueDouble
                taxRate = taxValue / subtotal
            }
        }
        updateValues()
        updateSection(0)
    }
    
    @objc fileprivate func tipRateTypeSegmentedControlChanged() {
        if tipRateTypeSegmentedControl.selectedSegmentIndex == 0 {
            // Change to common
            tipRate = rateList[commonRateSegmentedControl.selectedSegmentIndex]
        } else {
            if let rate = Double(customTipRateField.text!) {
                tipRate = rate / 100
            } else {
                tipRate = 0
            }
        }
        updateValues()
        updateSection(1)
    }
    
    @objc fileprivate func commonRateSegmentedControlChanged() {
        tipRate = rateList[commonRateSegmentedControl.selectedSegmentIndex]
        updateValues()
    }
    
    @objc fileprivate func subtotalFieldChanged() {
        if let subtotalValue = Double(subtotalField.text!) {
            subtotal = subtotalValue
        } else {
            subtotal = 0
        }
        updateValues()
    }
    
    @objc fileprivate func taxValueFieldChanged() {
        if let taxValueDouble = Double(taxValueField.text!) {
            taxValue = taxValueDouble
            taxRate = (taxValue / subtotal).roundTo(places: 4)
            taxRateField.text = String(taxRate * 100)
        } else {
            taxValue = 0
            taxRate = 0
            taxRateField.text = ""
        }
        updateValues()
    }
    
    @objc fileprivate func taxRateFieldChanged() {
        if let taxRateValue = Double(taxRateField.text!) {
            taxRate = taxRateValue / 100
            taxValue = (subtotal * taxRate).roundTo(places: 2)
            taxValueField.text = String(taxValue)
        } else {
            taxRate = 0
            taxValue = 0
            taxValueField.text = ""
        }
        updateValues()
    }
    
    @objc fileprivate func customTipRateFieldChanged() {
        if let tipRateValue = Double(customTipRateField.text!) {
            tipRate = tipRateValue / 100
            if tipRateValue >= 0 && tipRateValue <= 100 {
                customTipRateSlider.setValue(Float(tipRateValue), animated: true)
            } else if tipRateValue > 100 {
                customTipRateSlider.setValue(100.0, animated: true)
            }
        } else {
            tipRate = 0
            customTipRateSlider.setValue(0, animated: true)
        }
        updateValues()
    }
    
    @objc fileprivate func customTipRateSliderChanged() {
        let tipRateValue = Double(customTipRateSlider.value).roundTo(places: 2)
        tipRate = tipRateValue / 100
        customTipRateField.text = String(tipRateValue)
        updateValues()
    }
    
    @objc fileprivate func pplFieldChanged() {
        if let pplValue = Int(pplField.text!) {
            if pplValue > 0 {
                ppl = pplValue
                if ppl >= 1 && ppl <= 10 {
                    pplSlider.setValue(Float(ppl), animated: true)
                }
            }
        } else {
            ppl = 1
            pplSlider.setValue(1.0, animated: true)
        }
        updateValues()
    }
    
    @objc fileprivate func pplSliderChanged() {
        let pplValue = Int(pplSlider.value)
        if pplValue > 0 {
            ppl = pplValue
            pplField.text = String(ppl)
            updateValues()
        }
    }
    
    @objc fileprivate func clearBtnPressed() {
        let alertController = UIAlertController(title: "Clear all fileds?", message: "Your progress will lost.", preferredStyle: .actionSheet)
        let clearAction = UIAlertAction(title: "Clear", style: .destructive, handler: { action in
            self.clearAllValues()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(clearAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func updateValues() {
        var subtotalWithTax = 0.0
        if taxIncludedSwitch.isOn {
            subtotalWithTax = subtotal
        } else {
            subtotalWithTax = subtotal * (1 + taxRate)
        }
        
        let (tip, total, tipPpl, totalPpl) = TipCalculator.tip(of: subtotalWithTax, rate: tipRate, splitBy: ppl)
        tipLabel.text = "$" + String(tip)
        totalLabel.text = "$" + String(total)
        tipPplLabel.text = "$" + String(tipPpl)
        totalPplLabel.text = "$" + String(totalPpl)
    }
    
    fileprivate func updateSection(_ section: Int) {
        mainTableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    fileprivate func updateAllSections() {
        mainTableView.reloadSections(IndexSet(integersIn: 0 ..< 4), with: .automatic)
    }
    
    fileprivate func clearAllValues() {
        subtotalField.text = ""
        taxIncludedSwitch.setOn(true, animated: true)
        taxValueField.text = ""
        taxRateField.text = ""
        tipRateTypeSegmentedControl.selectedSegmentIndex = 0
        commonRateSegmentedControl.selectedSegmentIndex = 0
        customTipRateField.text = ""
        customTipRateSlider.setValue(0.0, animated: true)
        pplField.text = ""
        pplSlider.setValue(1, animated: true)
        
        tip = 0.0
        total = 0.0
        tipPpl = 0.0
        totalPpl = 0.0
        subtotal = 0.0
        tipRate = 0.1
        taxValue = 0.0
        taxRate = 0.0
        ppl = 1
        
        updateAllSections()
        updateValues()
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

extension CompleteCalcViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if taxIncludedSwitch.isOn {
                return 2
            } else {
                return 4
            }
        case 1:
            return 2
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            switch row {
            case 0:
                return 54
            default:
                return 44
            }
        case 1:
            switch row {
            case 1:
                if tipRateTypeSegmentedControl.selectedSegmentIndex == 1 {
                    return 84
                } else {
                    return 44
                }
            default:
                return 44
            }
        case 2:
            return 84
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Subtotal"
        case 1:
            return "Tip rate"
        case 2:
            return "Split bill"
        case 3:
            return "Clear all"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            if taxIncludedSwitch.isOn == false {
                return "Note: you only need to fill one of the two fields of tax value and tax rate."
            } else {
                return ""
            }
        case 1:
            if tipRateTypeSegmentedControl.selectedSegmentIndex == 1 {
                return "You can enter the tip rate if the number is over 100% (WOW)."
            } else {
                return ""
            }
        case 2:
            return "You can enter the number of people in case that the number is over 10."
        case 3:
            return "Clear all fields. Your progress will lost."
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            switch row {
            case 0:
                let cell = UITableViewCell(frame: .zero)
                cell.addSubview(subtotalField)
                subtotalField.snp.makeConstraints({ make in
                    make.edges.equalToSuperview().inset(UIEdgeInsetsMake(8, 16, 8, 16))
                })
                cell.selectionStyle = .none
                return cell
            case 1:
                let cell = UITableViewCell(frame: .zero)
                cell.addSubview(taxIncludedSwitch)
                let taxIncludedLabel = UILabel(frame: .zero)
                taxIncludedLabel.text = "Tax included"
                cell.addSubview(taxIncludedLabel)
                taxIncludedLabel.snp.makeConstraints({ make in
                    make.left.equalToSuperview().offset(16)
                    make.top.equalToSuperview().offset(3)
                    make.bottom.equalToSuperview().offset(-3)
                    make.right.equalTo(taxIncludedSwitch.snp.left).offset(-8)
                })
                taxIncludedSwitch.snp.makeConstraints({ make in
                    make.right.equalToSuperview().offset(-16)
                    make.centerY.equalToSuperview()
                })
                cell.selectionStyle = .none
                return cell
            case 2:
                let cell = UITableViewCell(frame: .zero)
                cell.addSubview(taxValueField)
                let taxValueLabel = UILabel(frame: .zero)
                taxValueLabel.text = "Tax value"
                cell.addSubview(taxValueLabel)
                taxValueLabel.snp.makeConstraints({ make in
                    make.left.equalToSuperview().offset(16)
                    make.top.equalToSuperview().offset(3)
                    make.bottom.equalToSuperview().offset(-3)
                    make.width.equalTo(160)
                })
                taxValueField.snp.makeConstraints({ make in
                    make.right.equalToSuperview().offset(-16)
                    make.left.equalTo(taxValueLabel.snp.right).offset(8)
                    make.centerY.equalToSuperview()
                })
                cell.selectionStyle = .none
                return cell
            case 3:
                let cell = UITableViewCell(frame: .zero)
                cell.addSubview(taxRateField)
                let taxRateLabel = UILabel(frame: .zero)
                taxRateLabel.text = "Tax rate (%)"
                cell.addSubview(taxRateLabel)
                taxRateLabel.snp.makeConstraints({ make in
                    make.left.equalToSuperview().offset(16)
                    make.top.equalToSuperview().offset(3)
                    make.bottom.equalToSuperview().offset(-3)
                    make.width.equalTo(160)
                })
                taxRateField.snp.makeConstraints({ make in
                    make.right.equalToSuperview().offset(-16)
                    make.left.equalTo(taxRateLabel.snp.right).offset(8)
                    make.centerY.equalToSuperview()
                })
                cell.selectionStyle = .none
                return cell
            default:
                return UITableViewCell()
            }
        case 1:
            switch row {
            case 0:
                let cell = UITableViewCell()
                cell.selectionStyle = .none
                cell.addSubview(tipRateTypeSegmentedControl)
                tipRateTypeSegmentedControl.snp.makeConstraints({ make in
                    make.center.equalToSuperview()
                    make.width.equalTo(200)
                })
                return cell
            case 1:
                let cell = UITableViewCell()
                cell.selectionStyle = .none
                if tipRateTypeSegmentedControl.selectedSegmentIndex == 0 {
                    // Common
                    cell.addSubview(commonRateSegmentedControl)
                    commonRateSegmentedControl.snp.makeConstraints({ make in
                        make.edges.equalToSuperview().inset(UIEdgeInsetsMake(8, 16, 8, 16))
                    })
                } else {
                    // Custom
                    let customTipRateLabel = UILabel(frame: .zero)
                    customTipRateLabel.text = "Custom rate (%)"
                    cell.addSubview(customTipRateLabel)
                    cell.addSubview(customTipRateField)
                    cell.addSubview(customTipRateSlider)
                    customTipRateLabel.snp.makeConstraints({ make in
                        make.top.equalToSuperview().offset(12)
                        make.left.equalToSuperview().offset(16)
                        make.width.equalTo(200)
                        make.height.equalTo(22)
                    })
                    customTipRateField.snp.makeConstraints({ make in
                        make.top.equalToSuperview().offset(12)
                        make.right.equalToSuperview().offset(-16)
                        make.left.equalTo(customTipRateLabel.snp.right).offset(8)
                        make.height.equalTo(22)
                    })
                    customTipRateSlider.snp.makeConstraints({ make in
                        make.left.equalToSuperview().offset(16)
                        make.right.equalToSuperview().offset(-16)
                        make.bottom.equalToSuperview().offset(-12)
                    })
                }
                return cell
            default:
                return UITableViewCell()
            }
        case 2:
            switch row {
            case 0:
                let cell = UITableViewCell()
                cell.selectionStyle = .none
                let splitByLabel = UILabel(frame: .zero)
                splitByLabel.text = "Split by"
                cell.addSubview(splitByLabel)
                cell.addSubview(pplField)
                cell.addSubview(pplSlider)
                splitByLabel.snp.makeConstraints({ make in
                    make.top.equalToSuperview().offset(12)
                    make.left.equalToSuperview().offset(16)
                    make.width.equalTo(200)
                    make.height.equalTo(22)
                })
                pplField.snp.makeConstraints({ make in
                    make.top.equalToSuperview().offset(12)
                    make.right.equalToSuperview().offset(-16)
                    make.left.equalTo(splitByLabel.snp.right).offset(8)
                    make.height.equalTo(22)
                })
                pplSlider.snp.makeConstraints({ make in
                    make.left.equalToSuperview().offset(16)
                    make.right.equalToSuperview().offset(-16)
                    make.bottom.equalToSuperview().offset(-12)
                })
                return cell
            default:
                return UITableViewCell()
            }
        case 3:
            switch row {
            case 0:
                let cell = UITableViewCell()
                cell.selectionStyle = .none
                cell.addSubview(clearBtn)
                clearBtn.snp.makeConstraints({ make in
                    make.edges.equalToSuperview()
                })
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
}

extension CompleteCalcViewController: UITableViewDelegate {
    
    
    
    
}
