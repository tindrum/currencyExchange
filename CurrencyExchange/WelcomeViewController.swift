//
//  WelcomeViewController.swift
//  CurrencyExchange
//
//  Created by Daniel Henderson on 5/7/17.
//  Copyright © 2017 Daniel Henderson. All rights reserved.
//

import UIKit

// TODO: Make this view less ugly.

class WelcomeViewController: UIViewController {
    var worldCurrencies = CurrencyArraySingleton.sharedInstance
    @IBAction func resetToDefaults(_ sender: UIButton) {
        worldCurrencies.resetToDefaults()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

