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
    var fromCurrency: Currency?
    @IBOutlet weak var fromCurrencyName: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var numConversions: UILabel!
    
    // Picker view data
    @IBOutlet weak var toCurrencyPicker: UIPickerView!
    var components = [[String]]()
    var resultString = ""
    // TODO: remove Example code
    let decimalDigit = ["0","1","2","3","4","5","6","7","8","9"]
    let timeDigit = ["0","1","2","3","4","5"]
    let timeSeperator = [":"]
    let decimalSeperator = ["."]

    var delegate:ConvertCurrencyViewControllerDelegate! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fromCurrencyName.text = fromCurrency?.country ?? "No Country"
        flag.image = fromCurrency?.flag
        numConversions.text = String(fromCurrency?.numberOfConversions ?? 0)
        toCurrencyPicker.dataSource = self
        toCurrencyPicker.delegate = self
        components = [["A", "B", "C"], ["a", "b", "c"]]
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

    func numberPickerComponent(from char:Character) -> [String]{
        switch char{
            case "9":
                return ["0","1","2","3","4","5","6","7","8","9"]
            case "5":
                return ["0","1","2","3","4","5"]
            case "x":
                return ["0"," 1/16","1/8","3/16","1/4","5/16","3/8","7/16","1/2","9/16","5/8","11/16","3/4","13/16","7/8","15/16"]
            default:
                return [String(char)]
        }
    }
    
    func numberPickerComponents(from string:String)->[[String]]{
        var components = [[String]]()
        for char in string.characters{
            components += [numberPickerComponent(from:char)]
        }
        return components
    }

}
