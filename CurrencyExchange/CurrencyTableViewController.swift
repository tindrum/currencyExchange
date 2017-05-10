//
//  CurrencyTableViewController.swift
//  CurrencyExchange
//
//  Created by Daniel Henderson on 5/7/17.
//  Copyright © 2017 Daniel Henderson. All rights reserved.
//

import UIKit

class CurrencyTableViewController: UITableViewController, ConvertCurrencyViewControllerDelegate {
    //MARK: Properties
//    var currencies = [Currency]()
    var worldCurrencies = CurrencyArraySingleton.sharedInstance
    var selectedCurrency:Currency?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        // Use the function from the Singleton
        let count = worldCurrencies.numberOfFavorites()
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "CurrencyTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CurrencyTableViewCell else {
            fatalError("The dequeued cell is not an instance of CurrencyTableViewCell.")
        }

        // Fetches the appropriate currency for the data source layout
        let currency = worldCurrencies.currencyForIndex(index: indexPath.row)

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

    
    // MARK: - Navigation
    
    // New version of Swift or iOS changed the method signature
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("tableView didSelectRowAtIndexPath")
        selectedCurrency = worldCurrencies.currencyForIndex(index: indexPath.item)
//        print(String(indexPath.item))
//        print(selectedCurrency?.country ?? "No Country")
        self.performSegue(withIdentifier: "convertCurrency", sender: indexPath);

    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "convertCurrency" {
            print("segue to Convert Currency")
            let convertCurrencyViewController = segue.destination as! ConvertCurrencyViewController
                convertCurrencyViewController.delegate = self
                convertCurrencyViewController.fromCurrency = selectedCurrency
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: Protocol implementations
    // ConvertCurrencyViewControllerDelegate
    
    func lastConversion(from: Currency, to: Currency)
    {
        // save the "to" currency in the "from" currency data
        // so the user can easily see what they converted to last time
        print("last connversion from: \(from.country) to: \(to.country)")
        print("delegated to here from ConvertCurrencyViewController")
        
    }
}
