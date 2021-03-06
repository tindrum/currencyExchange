//
//  CurrencySingleton.swift
//  CurrencyExchange
//
//  Created by Daniel Henderson on 5/8/17.
//  Copyright © 2017 Daniel Henderson. All rights reserved.
//

import Foundation
import UIKit


// TODO: Refactor to control the times when the currency data is updated.
//       It refreshes quite often.
//
// TODO: Refactor, along with Currency, to put model info in the model, 
//       and view info in the view. 
//       CurrencyArraySingleton crosses the lines between being a model and a view, 
//       so figure out what it really is (a model of all currencies, I think)
//       and put more of the work into the true ViewControllers.
//       This would require a thoughtful rework of what helper functions are in this class,
//       which should be in the Currency class, and which should be in the true View classes that use these models.

class CurrencyArraySingleton {
    static let sharedInstance = CurrencyArraySingleton()
    var worldCurrencies = [Currency]()
    let numFaves: Int = 6

    let itemArchiveURL: URL = { // Closure with signature of () -> URL
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("worldCurrencies.archive")
    }()

    // TODO: Reduce the number of YQL queries. 
    //       Each time the Exchange Rate tableView comes back into scope,
    //       I'm reloading all the exchange rates for each of the faves.
    
    private init() { //This prevents others from using the default '()' initializer for this class.
        
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Currency] {
            print("UNARCHIVING CURRENCIES")
            worldCurrencies = archivedItems
            // Sort them after reloading them
            worldCurrencies.sort()

            
        } else {
            // if not, load default currencies
            print("CREATING DEFAULT CURRENCIES")
            createDefaultCurrencies()
        }
//        print("faves are:")
//        let faves = worldCurrencies.filter{ $0.fave }
//        for fave in faves {
//            print("updating faves for:")
//            print(fave.country)
//            fave.updateExchangeRates()
//            print(fave.country)
//            print("count of conversions:")
//            print(fave.conversions.count)
//        }
    }
    
    //MARK: Public Methods
    
    func currencyObjectForCode(code: String) -> Currency? {
        var currencyObject:Currency? = nil
        for obj in worldCurrencies {
            if Currency.isCountryForCode(object: obj, code: code) {
                currencyObject = obj
            }
        }
        return currencyObject
    }

    
    func codeToFlag(code: String) -> UIImage? {
        let currencyObject:Currency? = currencyObjectForCode(code: code)
        return currencyObject?.flag
    }
    

    
    func numberOfFavorites() -> Int {
        // find the count of faves, since that's all this tableView displays
        let count = worldCurrencies.filter{ $0.fave }.count
        return count
        
    }
    
    func numberOfCurrencies() -> Int {
        // find the count of faves, since that's all this tableView displays
        let count = worldCurrencies.count
        return count
        
    }
    
    func currencyForIndex(index: Int) -> Currency {
        return worldCurrencies[index]
    }
    
    func updateFaveExchangeRates() {
        worldCurrencies.sort()
        let faves = worldCurrencies.filter{ $0.fave }

        print("** requesting update of exchange rates")
        for currency in faves {
            print(" *\(currency.code)")
            currency.updateExchangeRates()
        }
        print("** done requesting exchange rate updates")
    }
    
    func favoritesCodes() -> [String] {
        var favesArray:[String] = []
        for currency in worldCurrencies {
            if currency.fave {
                favesArray.append(currency.code)
            }
        }
        return favesArray
    }
    
    func favoritesCodes(notIncluding: String) -> [String] {
        var favesArray:[String] = []
        for currency in worldCurrencies {
            if currency.fave && currency.code != notIncluding {
                favesArray.append(currency.code)
            }
        }
        return favesArray
    }
    
    func resetToDefaults() {
        // empty the current array
        worldCurrencies = []
        // delete the data file
//        itemArchiveURL
        do {
            let fm:FileManager = FileManager()
            try fm.removeItem(at: itemArchiveURL)
        } catch _ as NSError {
            print("couldn't delete prefs file")
        }
        createDefaultCurrencies()
    }
    
    //MARK: Persistence Methods
    
    func saveChanges() -> Bool {
        print("Saving world currency data to: \(itemArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(worldCurrencies, toFile: itemArchiveURL.path)
    }
    
    
    //MARK: Private Methods
    
    
    
    private func createDefaultCurrencies() {
        let flags = ["usa", "uk", "canada", "mexico", "europe", "japan", "australia", "brazil", "egypt", "india", "israel", "peru", "saudi", "singapore", "safrica", "skorea", "thailand", "china", "uae"]
        let countries = ["USD",  "GBP", "CAD", "MXN", "EUR", "JPY", "AUD", "BRL", "EGP", "INR", "ILS", "PEN", "SAR", "SGD", "ZAR", "KRW", "THB", "CNY", "AED"]
        
        if (flags.count == countries.count) {
            for count in 0..<flags.count {
//                print("creating \(countries[count]) with flag \(flags[count])")
                worldCurrencies.append(Currency(code: countries[count], flag: flags[count], position: count)!)
            }
            // Make a couple of them favorites
            
            for counter in 0..<numFaves {
                worldCurrencies[counter].fave = true
            }
            
            worldCurrencies.sort()
//            print("list all currencies, after createDefaultCurrencies() called")
//            for c in worldCurrencies {
//                print(c.country)
//                print(c.flagFile)
//                if c.fave {
//                    print("fave")
//                } else {
//                    print("not fave")
//                }
//                print(String(c.favoritePosition))
//            }
            
        } else {
            fatalError("Number of flags does not match number of country codes.")
        }
        
    }

}
