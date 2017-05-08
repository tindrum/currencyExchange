//
//  CurrencySingleton.swift
//  CurrencyExchange
//
//  Created by Daniel Henderson on 5/8/17.
//  Copyright © 2017 Daniel Henderson. All rights reserved.
//

import UIKit

class CurrencyArraySingleton {
    static let sharedInstance = CurrencyArraySingleton()
    private init() {} //This prevents others from using the default '()' initializer for this class.
}
