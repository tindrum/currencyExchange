//
//  ConvertCurrencyViewController.swift
//  CurrencyExchange
//
//  Created by Daniel Henderson on 5/10/17.
//  Copyright © 2017 Daniel Henderson. All rights reserved.
//

import UIKit

// The last conversion made in the ConvertCurrency view
protocol ConvertCurrencyViewControllerDelegate {
    func lastConversion(from: Currency, to: Currency)
}

//class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
//    
//}


class ConvertCurrencyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var worldCurrencies = CurrencyArraySingleton.sharedInstance
    
    var fromCurrency: Currency?
    @IBOutlet weak var fromCurrencyName: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var numConversions: UILabel!
    
    // Currencies to convert TO
    @IBOutlet weak var toCountryName: UILabel!
    @IBOutlet weak var toExchangeRate: UILabel!
    @IBOutlet weak var toCountryCode: UILabel!
    
    @IBOutlet weak var toFlag: UIImageView!
    
    // Picker view data
    @IBOutlet weak var toCurrencyPicker: UIPickerView!
    var components = [[String]]()
    var codes = [String]()
    var rates = [Double?]()
    var flags = [UIImage?]()
    
    var resultString = ""

    var delegate:ConvertCurrencyViewControllerDelegate! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fromCurrencyName.text = fromCurrency?.country ?? "No Country"
        flag.image = fromCurrency?.flag
        numConversions.text = String(fromCurrency?.numberOfConversions ?? 0)
        toCurrencyPicker.dataSource = self
        toCurrencyPicker.delegate = self
//        components = [stringsForConversions()]
        components.append([String]())
        prepareDataForPicker(componentsArray: &components, codes: &codes, rates: &rates, flags: &flags)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    //:MARK - Delegates and data sources
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
                toExchangeRate.text = String(rates[indexOfPicked]!)
            } else {
                toExchangeRate.text = "???"
            }
            
            // TODO: Number Formatter on label field
            toCountryCode.text = codes[indexOfPicked]
        }
    }


}



