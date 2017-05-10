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

class ConvertCurrencyViewController: UIViewController {
    @IBAction func backToCurrencyListView(_ sender: UIButton) {
        if sender.titleLabel?.text == "backToList" {
            
        }
    }

    var delegate:ConvertCurrencyViewControllerDelegate! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToList" {
            print("segue back to list")
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
