//
//  TipCalcViewController.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/10.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import SnapKit
import TipCalcKit
import LTMorphingLabel
import AudioToolbox
import Hero

class TipCalcViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var resultsView: UIVisualEffectView!
    
    fileprivate let subtotalField: UITextField = {
        let subtotalField = UITextField(frame: .zero)
        subtotalField.placeholder = "$0.0"
        subtotalField.font = UIFont.boldSystemFont(ofSize: 24.0)
        subtotalField.keyboardType = .decimalPad
        subtotalField.textAlignment = .right
        subtotalField.clearButtonMode = .whileEditing
        subtotalField.addTarget(self, action: #selector(subtotalFieldChanged), for: .editingChanged)
        return subtotalField
    }()
    
    fileprivate let taxIncludedSwitch: UISwitch = {
        let taxIncludedSwitch = UISwitch()
        taxIncludedSwitch.addTarget(self, action: #selector(taxIncludedSwitchChanged), for: .valueChanged)
        taxIncludedSwitch.isOn = true
        return taxIncludedSwitch
    }()
    
    fileprivate let taxValueField: UITextField = {
        let taxValueField = UITextField(frame: .zero)
        taxValueField.placeholder = "$0.0"
        taxValueField.keyboardType = .decimalPad
        taxValueField.textAlignment = .right
        taxValueField.clearButtonMode = .whileEditing
        taxValueField.addTarget(self, action: #selector(taxValueFieldChanged), for: .editingChanged)
        return taxValueField
    }()
    
    fileprivate let taxRateField: UITextField = {
        let taxRateField = UITextField(frame: .zero)
        taxRateField.placeholder = "0%"
        taxRateField.keyboardType = .decimalPad
        taxRateField.textAlignment = .right
        taxRateField.clearButtonMode = .whileEditing
        taxRateField.addTarget(self, action: #selector(taxRateFieldChanged), for: .editingChanged)
        return taxRateField
    }()
    
    fileprivate let tipRateTypeSegmentedControl: UISegmentedControl = {
        let tipRateTypeSegmentedControl = UISegmentedControl(items: ["Common", "Custom"])
        tipRateTypeSegmentedControl.selectedSegmentIndex = 0
        tipRateTypeSegmentedControl.addTarget(self, action: #selector(tipRateTypeSegmentedControlChanged), for: .valueChanged)
        return tipRateTypeSegmentedControl
    }()
    
    fileprivate let commonRateSegmentedControl: UISegmentedControl = {
        let commonRateSegmentedControl = UISegmentedControl(items: ["10%", "12%", "15%", "18%", "20%"])
        commonRateSegmentedControl.selectedSegmentIndex = TipCalcDataManager.defaultTipRateIndex()
        commonRateSegmentedControl.addTarget(self, action: #selector(commonRateSegmentedControlChanged), for: .valueChanged)
        return commonRateSegmentedControl
    }()
    
    fileprivate let customTipRateField: UITextField = {
        let customTipRateField = UITextField(frame: .zero)
        customTipRateField.placeholder = "0%"
        customTipRateField.keyboardType = .decimalPad
        customTipRateField.textAlignment = .right
        customTipRateField.clearButtonMode = .whileEditing
        customTipRateField.addTarget(self, action: #selector(customTipRateFieldChanged), for: .editingChanged)
        return customTipRateField
    }()
    
    fileprivate let customTipRateSlider: UISlider = {
        let customTipRateSlider = UISlider(frame: .zero)
        customTipRateSlider.minimumValue = 0.0
        customTipRateSlider.maximumValue = 100.0
        customTipRateSlider.isContinuous = true
        customTipRateSlider.addTarget(self, action: #selector(customTipRateSliderChanged), for: .valueChanged)
        return customTipRateSlider
    }()
    
    fileprivate let pplField: UITextField = {
        let pplField = UITextField(frame: .zero)
        pplField.placeholder = "1"
        pplField.keyboardType = .numberPad
        pplField.textAlignment = .right
        pplField.clearButtonMode = .whileEditing
        pplField.addTarget(self, action: #selector(pplFieldChanged), for: .editingChanged)
        return pplField
    }()
    
    fileprivate let pplStepper: UIStepper = {
        let pplStepper = UIStepper()
        pplStepper.minimumValue = 1
        pplStepper.stepValue = 1.0
        pplStepper.maximumValue = 100
        pplStepper.addTarget(self, action: #selector(pplStepperChanged), for: .valueChanged)
        return pplStepper
    }()
    
    fileprivate let pplSlider: UISlider = {
        let pplSlider = UISlider(frame: .zero)
        pplSlider.minimumValue = 1
        pplSlider.maximumValue = 10
        pplSlider.isContinuous = true
        pplSlider.addTarget(self, action: #selector(pplSliderChanged), for: .valueChanged)
        return pplSlider
    }()
    
    fileprivate let generateBillBtn: UIButton = {
        let generateBillBtn = UIButton(type: .system)
        generateBillBtn.setTitle("Generate bill", for: .normal)
        generateBillBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        generateBillBtn.addTarget(self, action: #selector(generateBillBtnPressed), for: .touchUpInside)
        return generateBillBtn
    }()
    
    fileprivate let saveAndClearBtn: UIButton = {
        let saveAndClearBtn = UIButton(type: .system)
        saveAndClearBtn.setTitle("Save and clear", for: .normal)
        saveAndClearBtn.addTarget(self, action: #selector(saveAndClearBtnPressed), for: .touchUpInside)
        saveAndClearBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return saveAndClearBtn
    }()
    
    fileprivate let clearBtn: UIButton = {
        let clearBtn = UIButton(type: .system)
        clearBtn.setTitle("Clear all", for: .normal)
        clearBtn.addTarget(self, action: #selector(clearBtnPressed), for: .touchUpInside)
        clearBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return clearBtn
    }()
    
    @IBOutlet weak var tipLabel: LTMorphingLabel!
    @IBOutlet weak var totalLabel: LTMorphingLabel!
    @IBOutlet weak var tipPplLabel: LTMorphingLabel!
    @IBOutlet weak var totalPplLabel: LTMorphingLabel!
    
    fileprivate var billItem = BillItem()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.contentInset = UIEdgeInsets(top: 144, left: 0, bottom: 44, right: 0)
        
        tipLabel.heroID = "tipLabel"
        totalLabel.heroID = "totalLabel"
        tipPplLabel.heroID = "tipPplLabel"
        totalPplLabel.heroID = "totalPplLabel"
        
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
        updateValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if TipCalcDataManager.shakeToClear() {
                if TipCalcDataManager.shakeToClearOption() == 0 {
                    clearAllValues()
                } else {
                    saveAndClearBtnPressed()
                }
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
    
    // MARK: - Functions
    
    fileprivate func setColors() {
        let mainTintColor = TipCalcDataManager.widgetTintColor()
        let animatedEnabled = TipCalcDataManager.animatedLabel()
        
        tipLabel.textColor = mainTintColor
        tipLabel.morphingEffect = .evaporate
        tipLabel.morphingDuration = ANIMATION_DURATION
        tipLabel.morphingEnabled = animatedEnabled
        
        totalLabel.textColor = mainTintColor
        totalLabel.morphingEffect = .evaporate
        totalLabel.morphingDuration = ANIMATION_DURATION
        totalLabel.morphingEnabled = animatedEnabled
        
        tipPplLabel.textColor = mainTintColor
        tipPplLabel.morphingEffect = .evaporate
        tipPplLabel.morphingDuration = ANIMATION_DURATION
        tipPplLabel.morphingEnabled = animatedEnabled
        
        totalPplLabel.textColor = mainTintColor
        totalPplLabel.morphingEffect = .evaporate
        totalPplLabel.morphingDuration = ANIMATION_DURATION
        totalPplLabel.morphingEnabled = animatedEnabled
    }
    
    @objc fileprivate func taxIncludedSwitchChanged() {
        if taxIncludedSwitch.isOn {
            // Change to On
            billItem.taxIncluded = true
            billItem.taxValue = 0.0
            billItem.taxRate = 0.0
            if let subtotalValue = Double(subtotalField.text!) {
                billItem.subtotal = subtotalValue
            }
        } else {
            billItem.taxIncluded = false
            if let taxValueDouble = Double(taxRateField.text!) {
                billItem.taxValue = taxValueDouble
                billItem.taxRate = billItem.taxValue / billItem.subtotal
            }
        }
        updateValues()
        updateSection(0)
    }
    
    @objc fileprivate func tipRateTypeSegmentedControlChanged() {
        if tipRateTypeSegmentedControl.selectedSegmentIndex == 0 {
            // Change to common
            billItem.tipRate = rateList[commonRateSegmentedControl.selectedSegmentIndex]
        } else {
            if let rate = Double(customTipRateField.text!) {
                billItem.tipRate = rate / 100
            } else {
                billItem.tipRate = 0
            }
        }
        updateValues()
        updateSection(1)
    }
    
    @objc fileprivate func commonRateSegmentedControlChanged() {
        billItem.tipRate = rateList[commonRateSegmentedControl.selectedSegmentIndex]
        updateValues()
    }
    
    @objc fileprivate func subtotalFieldChanged() {
        if let subtotalValue = Double(subtotalField.text!) {
            billItem.subtotal = subtotalValue
        } else {
            billItem.subtotal = 0
        }
        updateValues()
    }
    
    @objc fileprivate func taxValueFieldChanged() {
        if let taxValueDouble = Double(taxValueField.text!) {
            billItem.taxValue = taxValueDouble
            billItem.taxRate = (billItem.taxValue / billItem.subtotal).roundTo(places: 4)
            taxRateField.text = String(billItem.taxRate * 100)
        } else {
            billItem.taxValue = 0
            billItem.taxRate = 0
            taxRateField.text = ""
        }
        updateValues()
    }
    
    @objc fileprivate func taxRateFieldChanged() {
        if let taxRateValue = Double(taxRateField.text!) {
            billItem.taxRate = taxRateValue / 100
            billItem.taxValue = (billItem.subtotal * billItem.taxRate).roundTo(places: 2)
            taxValueField.text = String(billItem.taxValue)
        } else {
            billItem.taxRate = 0
            billItem.taxValue = 0
            taxValueField.text = ""
        }
        updateValues()
    }
    
    @objc fileprivate func customTipRateFieldChanged() {
        if let tipRateValue = Double(customTipRateField.text!) {
            billItem.tipRate = tipRateValue / 100
            if tipRateValue >= 0 && tipRateValue <= 100 {
                customTipRateSlider.setValue(Float(tipRateValue), animated: true)
            } else if tipRateValue > 100 {
                customTipRateSlider.setValue(100.0, animated: true)
            }
        } else {
            billItem.tipRate = 0
            customTipRateSlider.setValue(0, animated: true)
        }
        updateValues()
    }
    
    @objc fileprivate func customTipRateSliderChanged() {
        let tipRateValue = Double(customTipRateSlider.value).roundTo(places: 2)
        billItem.tipRate = tipRateValue / 100
        customTipRateField.text = String(tipRateValue)
        updateValues()
    }
    
    @objc fileprivate func pplFieldChanged() {
        if let pplValue = Int(pplField.text!) {
            if pplValue > 0 {
                billItem.ppl = pplValue
                if billItem.ppl >= 1 && billItem.ppl <= 10 {
                    pplSlider.setValue(Float(billItem.ppl), animated: true)
                    pplStepper.value = Double(billItem.ppl)
                }
            }
        } else {
            billItem.ppl = 1
            pplSlider.setValue(1.0, animated: true)
            pplStepper.value = 1.0
        }
        updateValues()
    }
    
    @objc fileprivate func pplStepperChanged() {
        let pplValue = Int(pplStepper.value)
        billItem.ppl = pplValue
        pplField.text = String(billItem.ppl)
        pplSlider.setValue(Float(billItem.ppl), animated: true)
        updateValues()
    }
    
    @objc fileprivate func pplSliderChanged() {
        let pplValue = Int(pplSlider.value)
        if pplValue > 0 {
            billItem.ppl = pplValue
            pplField.text = String(billItem.ppl)
            pplStepper.value = Double(billItem.ppl)
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
    
    @objc fileprivate func saveAndClearBtnPressed() {
        let alertController = UIAlertController(title: "Save and Clear", message: "Please enter a title for your bill\nAll fileds will be cleared after saving", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Monday lunch"
        })
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action in
            self.billItem.title = alertController.textFields![0].text!
            if DatabaseUtility.shared.save(billItem: self.billItem) {
                self.clearAllValues()
                MsgDisplay.show(message: "Bill saved to database")
            } else {
                MsgDisplay.show(message: "Sorry, cannot save bill to database")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc fileprivate func generateBillBtnPressed() {
        performSegue(withIdentifier: "generateBill", sender: nil)
    }
    
    fileprivate func updateValues() {
        tipLabel.text = "$" + String(billItem.result.tip)
        totalLabel.text = "$" + String(billItem.result.total)
        tipPplLabel.text = "$" + String(billItem.result.tipPpl)
        totalPplLabel.text = "$" + String(billItem.result.totalPpl)
    }
    
    fileprivate func updateSection(_ section: Int) {
        mainTableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    fileprivate func updateAllSections() {
        mainTableView.reloadSections(IndexSet(integersIn: 0 ..< 3), with: .automatic)
    }
    
    fileprivate func clearAllValues() {
        subtotalField.text = ""
        taxIncludedSwitch.setOn(true, animated: true)
        taxValueField.text = ""
        taxRateField.text = ""
        tipRateTypeSegmentedControl.selectedSegmentIndex = 0
        commonRateSegmentedControl.selectedSegmentIndex = TipCalcDataManager.defaultTipRateIndex()
        customTipRateField.text = ""
        customTipRateSlider.setValue(0.0, animated: true)
        pplField.text = ""
        pplSlider.setValue(1, animated: true)
        pplStepper.value = 1.0
        
        billItem = BillItem()
        
        updateAllSections()
        updateValues()
        
        mainTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    // Set an item for TipCalcViewController and update values
    // Mainly used for open app from URL Scheme
    func setBillItem(item: BillItem) {
        billItem = item
        
        subtotalField.text = "\(billItem.subtotal)"
        taxIncludedSwitch.setOn(billItem.taxIncluded, animated: true)
        taxValueField.text = "\(billItem.taxValue)"
        taxRateField.text = "\(billItem.taxRate)"
        tipRateTypeSegmentedControl.selectedSegmentIndex = 0
        commonRateSegmentedControl.selectedSegmentIndex = {
            switch billItem.tipRate.roundTo(places: 2) {
            case 0.10:
                return 0
            case 0.12:
                return 1
            case 0.15:
                return 2
            case 0.18:
                return 3
            case 0.20:
                return 4
            default:
                return TipCalcDataManager.defaultTipRateIndex()
            }
        }()
        customTipRateField.text = ""
        customTipRateSlider.setValue(0.0, animated: true)
        pplField.text = "\(billItem.ppl)"
        pplSlider.setValue(Float(billItem.ppl), animated: true)
        pplStepper.value = Double(billItem.ppl)
        
        updateAllSections()
        updateValues()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "generateBill" {
            // Mode: OverCurrentContext
            let billController = segue.destination as! BillViewController
            billController.billItem = self.billItem
        }
    }

}

// MARK: - UITableViewDataSource

extension TipCalcViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
        case 4:
            return 2
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
            return "Bill"
        case 4:
            return "Clear all"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            if taxIncludedSwitch.isOn == false {
                return "Note: you only need to fill one of the two fields of tax value and tax rate"
            } else {
                return ""
            }
        case 1:
            if tipRateTypeSegmentedControl.selectedSegmentIndex == 1 {
                return "You can enter the tip rate if the number is over 100% (WOW)"
            } else {
                return ""
            }
        case 2:
            return "You can enter the number of people in case that the number is over 10"
        case 3:
            return "Generate a bill, then save or share it"
        case 4:
            return "If \"Shake to clear\" switch is on, you can also shake the device to clear all fields"
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
                cell.addSubview(pplStepper)
                splitByLabel.snp.makeConstraints({ make in
                    make.top.equalToSuperview().offset(12)
                    make.left.equalToSuperview().offset(16)
                    make.width.equalTo(120)
                    make.height.equalTo(22)
                })
                pplStepper.snp.makeConstraints({ make in
                    make.centerY.equalTo(splitByLabel)
                    make.right.equalToSuperview().offset(-16)
                })
                pplField.snp.makeConstraints({ make in
                    make.top.equalToSuperview().offset(12)
                    make.right.equalTo(pplStepper.snp.left).offset(-8)
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
                cell.addSubview(generateBillBtn)
                generateBillBtn.snp.makeConstraints({ make in
                    make.edges.equalToSuperview()
                })
                return cell
            default:
                return UITableViewCell()
            }
        case 4:
            switch row {
            case 0:
                let cell = UITableViewCell()
                cell.selectionStyle = .none
                cell.addSubview(saveAndClearBtn)
                saveAndClearBtn.snp.makeConstraints({ make in
                    make.edges.equalToSuperview()
                })
                return cell
            case 1:
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

extension TipCalcViewController: UITableViewDelegate {

    
    
}
