//
//  CurrencyTableViewController.swift
//  CurrencyExchange
//
//  Created by Daniel Henderson on 5/7/17.
//  Copyright © 2017 Daniel Henderson. All rights reserved.
//

import UIKit

class CurrencyTableViewController: UITableViewController {
    //MARK: Properties
    
    var currencies = [Currency]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the country currencies
        loadCurrencies()
        
        // update exchange rates of favorites
        for currency in currencies {
            if currency.fave {
                currency.conversions = Currency.exchangeRateLookup(fromCode: currency.code)
            }
        }
        
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
        // find the count of faves, since that's all this tableView displays
        let count = currencies.filter{ $0.fave }.count
        print("Number of faves is \(count)")
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "CurrencyTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CurrencyTableViewCell else {
            fatalError("The dequeued cell is not an instance of CurrencyTableViewCell.")
        }

        // Fetches the appropriate currency for the data source layout
        let currency = currencies[indexPath.row]

        cell.countryLabel.text = currency.country
        cell.flagImageView.image = currency.flag
        
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

    //MARK: Private Methods
    
    private func loadCurrencies() {
        let flags = ["australia", "brazil", "canada", "egypt", "europe", "india", "israel", "japan", "mexico", "peru", "saudi", "singapore", "safrica", "skorea", "thailand", "china", "uae", "uk", "usa"]
        let countries = ["AUD", "BRL", "CAD", "EGP", "EUR", "INR", "ILS", "JPY", "MXN", "PEN", "SAR", "SGD", "ZAR", "KRW", "THB", "CNY", "AED", "GBP", "USD"]
        
        if (flags.count == countries.count) {
            for count in 0..<flags.count {
                print("creating \(countries[count]) with flag \(flags[count])")
                currencies.append(Currency(code: ISOCode(rawValue: countries[count])!, flag: flags[count])!)
            }
            // Make a couple of them favorites
            let defaultFaves = [18, 17, 2, 8, 4, 7]
            for (index, countryIndex) in defaultFaves.enumerated() {
                currencies[countryIndex].fave = true
                currencies[countryIndex].favoritePosition = index
            }
            currencies.sort()
            print("list all currencies, after loadCurrencies() called")
            for c in currencies {
                print(c.country)
                print(c.flagFile)
                if c.fave {
                    print("fave")
                } else {
                    print("not fave")
                }
                print(String(c.favoritePosition))
            }
            
        } else {
            fatalError("Number of flags does not match number of country codes.")
        }
        
    }
}
