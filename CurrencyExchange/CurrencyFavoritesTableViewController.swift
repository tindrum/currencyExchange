//
//  CurrencyFavoritesTableViewController.swift
//  CurrencyExchange
//
//  Created by Daniel Henderson on 5/11/17.
//  Copyright © 2017 Daniel Henderson. All rights reserved.
//

import UIKit

class CurrencyFavoritesTableViewController: UITableViewController {
    var worldCurrencies = CurrencyArraySingleton.sharedInstance
    var selectedCurrency:Currency?

    override func viewDidLoad() {
        super.viewDidLoad()

        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(self.tabBarController!.tabBar.frame.height, 0, 0, 0);
        //Where tableview is the IBOutlet for your storyboard tableview.
        self.tableView.contentInset = adjustForTabbarInsets;
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
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
        let count = worldCurrencies.numberOfCurrencies()
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "CurrencyFavoritesTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CurrencyFavoritesTableViewCell else {
            fatalError("The dequeued cell is not an instance of CurrencyFavoritesTableViewCell.")
        }
        
        // Fetches the appropriate currency for the data source layout
        let currency = worldCurrencies.currencyForIndex(index: indexPath.row)
        
        cell.countryLabel.text = currency.country
        cell.flagImageView.image = currency.flag
        if currency.fave {
            cell.faveStar.image = #imageLiteral(resourceName: "fave")
        } else {
            cell.faveStar.image = #imageLiteral(resourceName: "unfave")
       }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCurrency = worldCurrencies.currencyForIndex(index: indexPath.item)
        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath)! as! CurrencyFavoritesTableViewCell
        
        if (selectedCurrency?.fave)! {
            selectedCurrency?.fave = false
            currentCell.faveStar.image = #imageLiteral(resourceName: "unfave")

        } else {
            selectedCurrency?.fave = true
            currentCell.faveStar.image = #imageLiteral(resourceName: "fave")

        }
        
        
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

}
