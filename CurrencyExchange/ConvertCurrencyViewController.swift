//
//  ConvertCurrencyViewController.swift
//  CurrencyExchange
//
//  Created by Daniel Henderson on 5/10/17.
//  Copyright © 2017 Daniel Henderson. All rights reserved.
//

import Foundation
import UIKit

// The last conversion made in the ConvertCurrency view
protocol ConvertCurrencyViewControllerDelegate {
    func lastConversion(from: Currency, to: Currency)
}

//class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
//    
//}

// Todo: Layout: fix all constraints to be conformant.
//       make layout responsive for more devices.
//       
// TODO: Fix refresh when choosing different currency,
//       so converted amount updates immediately.
//       Right now, last conversion stays in convert to label
//       until user edits text.
//
// TODO: Fix crash when user enters two decimal places.
//       If user enters "10.01." <- at this point, it crashes.
//       Probably need to validate all input on the text field.
//
// TODO: Pass back the last-used conversion.
//       The delegate method and protocol already exist to pass back
//       the last country used, but it isn't being passed back
//       when the segue is started.
//       Most of the functionality would be in the CurrencyTableWiewController for this.
//
// TODO: Display the date of the last time the exchange rate was updated.
//       The date updated is already an instance variable of the Currency class.
//
// TODO: Add button to force-update the exchange rate.



class ConvertCurrencyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var worldCurrencies = CurrencyArraySingleton.sharedInstance
    
    var fromCurrency: Currency?
    @IBOutlet weak var fromCurrencyName: UILabel!
    @IBOutlet weak var flag: UIImageView!
    
    // Currencies to convert TO
    @IBOutlet weak var toCountryName: UILabel!
    @IBOutlet weak var toExchangeRate: UILabel!
    var toExchangeRateDouble: Double = 0.0
    var selectedExchangeRateCode: String = "USD"
    @IBOutlet weak var toCountryCode: UILabel!
    
    @IBOutlet weak var toFlag: UIImageView!
    
    // Picker view data
    @IBOutlet weak var toCurrencyPicker: UIPickerView!
    var components = [[String]]()
    var codes = [String]()
    var rates = [Double?]()
    var flags = [UIImage?]()
    
    // Currency Exchange
    @IBOutlet weak var fromCurrencyAmount: UITextField!
    @IBOutlet weak var toCurrencyAmount: UILabel!
    
    
    @IBAction func fromCurrencyAction(_ sender: UITextField) {
        let convertedAmount:Double
        // TODO: this is not DRY
        if fromCurrencyAmount.text != "" {
            convertedAmount = toExchangeRateDouble * Double(fromCurrencyAmount.text!)!
        } else {
            convertedAmount = 0.0

        }
            let formatter = getFormatterFor(code: selectedExchangeRateCode)
        toCurrencyAmount.text = formatter.string(from: NSNumber(value: convertedAmount))
        
    }
    
    @IBAction func fromCurrencyEditingChanged(_ sender: UITextField) {
        // TODO: this is not DRY
        let convertedAmount:Double
        if fromCurrencyAmount.text != "" {
            convertedAmount = toExchangeRateDouble * Double(fromCurrencyAmount.text!)!
        } else {
            convertedAmount = 0.0
        }
        let formatter = getFormatterFor(code: selectedExchangeRateCode)
        toCurrencyAmount.text = formatter.string(from: NSNumber(value: convertedAmount))
        
    }
    
    var resultString = ""

    var delegate:ConvertCurrencyViewControllerDelegate! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fromCurrencyAmount.delegate = self
        fromCurrencyName.text = fromCurrency?.country ?? "No Country"
        flag.image = fromCurrency?.flag
        toCurrencyPicker.dataSource = self
        toCurrencyPicker.delegate = self
//        components = [stringsForConversions()]
        components.append([String]())
        prepareDataForPicker(componentsArray: &components, codes: &codes, rates: &rates, flags: &flags)
        let pickerReturnData:(Int, Int) = (0, 0)
        toCurrencyPicker.selectRow(pickerReturnData.0, inComponent: pickerReturnData.1, animated: true)
        pickerView(toCurrencyPicker, didSelectRow: pickerReturnData.0, inComponent: pickerReturnData.1)

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ConvertCurrencyViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)    }
    

    func didReceiveMemoryWarning(notification: NSNotification) {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: Text Field delegates
    
    // Notifications
    func keyboardWillShow(notification:Notification) {
        print("keyboard will show now. hide the picker")
        toCurrencyPicker.isHidden = true
        
    }
    
    func keyboardWillHide(notification:Notification) {
        print("keyboard will hide, show the picker")
        toCurrencyPicker.isHidden = false
        
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - Navigation

    @IBAction func backToCurrencyListView(_ sender: UIButton) {
        if sender.titleLabel?.text == "backToList" {
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToList" {
            print("segue back to list")
        }
    }
    
    //MARK: Conversion
    func prepareDataForPicker(componentsArray: inout [[String]], codes: inout [String], rates: inout [Double?], flags: inout [UIImage?]) {
        let thisCountryCode = fromCurrency?.code
        let faves:[String] = worldCurrencies.favoritesCodes(notIncluding: thisCountryCode!)
        for rate in (fromCurrency?.conversions)! {
            let shortCode = rate.value.countryCode
            if faves.contains(shortCode) && shortCode != thisCountryCode {
                codes.append(shortCode)
                let countryName = codeToCountryName(code: shortCode)
                componentsArray[0].append(countryName)
                let currencyObject = worldCurrencies.currencyObjectForCode(code: shortCode)
                flags.append(currencyObject?.flag)
                let thisRate:Double = (fromCurrency?.conversions[shortCode]?.rate)!
                print("collecting up data for Conversion View. rate for \(shortCode) is \(thisRate)")
                rates.append(thisRate)
                
            }
        }

        
    }

    
    func stringsForConversions() -> [String] {
        // get the codes for the favorites
        let thisCountryCode = fromCurrency?.code
        let faves:[String] = worldCurrencies.favoritesCodes(notIncluding: thisCountryCode!)

        var countries:[String] = []
        for rate in (fromCurrency?.conversions)! {
//            let longCode = rate.value.countryCode
//            let shortCode = exchangeRateCountryCodeToCode(longCode: longCode)
            let shortCode = rate.value.countryCode
            if faves.contains(shortCode) {
                let countryName = codeToCountryName(code: shortCode)
                countries.append(countryName)
            }
        }
        return countries
    }
    
    //MARK: Picker
    //MARK: - Delegates and data sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return components.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return components[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return components[component][row]
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var indexOfPicked: Int
        for index in 0..<components.count{
            // component.count better be 1
            indexOfPicked = pickerView.selectedRow(inComponent: index)
            print("Index of picker selection is \(indexOfPicked)")
            // TODO: save country code, exchange rate, whatever at same time country name is being retrieved.
            //       store this all in parallel arrays, so we can use them when user picks from picker.
            toCountryName.text = components[0][indexOfPicked]
            toFlag.image = flags[indexOfPicked]
            if ((rates[indexOfPicked]) != nil) {
                let r = rates[indexOfPicked]!
                toExchangeRateDouble = r
                selectedExchangeRateCode = codes[indexOfPicked]
//                toExchangeRate.text = currencyFormatter.string(from: NSNumber(value: r))
                toExchangeRate.text = getFormatterFor(code: codes[indexOfPicked]).string(from: NSNumber(value: r))
//                stringFromDouble(rates[indexOfPicked]!)
//                toExchangeRate.text = String(rates[indexOfPicked]!)
            } else {
                toExchangeRate.text = "???"
            }
            
            // TODO: Number Formatter on label field
            toCountryCode.text = codes[indexOfPicked]
        }
    }

    func getSymbolForCurrencyCode(code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }
    
    func getFormatterFor(code: String) -> NumberFormatter {
        let currencyFormatter:NumberFormatter = NumberFormatter()
        let specialParts:(Int, String, String) = specialFormattingFor(countryCode: code)
        currencyFormatter.currencySymbol = getSymbolForCurrencyCode(code: code)
        currencyFormatter.maximumFractionDigits = specialParts.0
        currencyFormatter.minimumFractionDigits = specialParts.0
        currencyFormatter.currencyGroupingSeparator = specialParts.1
        currencyFormatter.currencyDecimalSeparator = specialParts.2
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        return currencyFormatter
        
    }
    
    func specialFormattingFor( countryCode: String) -> (Int, String, String) {
        // This is a brute-force way to find the minor units.
        // Source of data for this is http://www.thefinancials.com/?SubSectionID=curformat
        // .1 is grouping separator
        // .2 is decimal seperator
        //
        // TODO: Rupee from India actually has #,##,###.##, 
        //       so variable number of digits in groupings
        //
        // TODO: Find the Apple way to do this. It must exist
        // If there's a an Apple API for these things, 
        // I couldn't find then in time to use them.
        switch countryCode {
        case "USD", "CAD", "EGP", "INR", "ILS", "MXN", "PEN", "SAR", "SGD",
             "THB", "CNY", "AED", "GBP", "EUR":
            return(2, ",", ".")
        case "AUD", "ZAR":
            return (2, " ", ".")
        case "BRL":
            return (2, ".", ",")
        case "JPY", "KRW":
            return (0, ",", "")
        default:
            return (2, ",", ".")
        }
    }
}



