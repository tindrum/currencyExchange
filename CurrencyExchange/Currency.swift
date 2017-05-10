//
//  Currency.swift
//  CurrencyExchange
//
//  Created by Daniel Henderson on 5/7/17.
//  Copyright © 2017 Daniel Henderson. All rights reserved.
//
//  A Currency object contains the info to show a friendly version of the country/currency to the user,
//             and the monetary value of that currency in other contry's money.

// import Foundation // UIKit imports Foundation
import UIKit
import os.log

public enum ISOCode: String {
    // From https://en.wikipedia.org/wiki/List_of_circulating_currencies
    // These are the codes used when querying Yahoo Finance
    // Using upper-case to avoid having to convert to-upper later
    case USD  // United States Dollar Symbol: $
    case AUD  // Australia Dollar Symbol: $
    case BRL  // Brazil Real Symbol: R$
    case CAD  // Canada Dollar Symbol: $
    case EGP  // Egypt Pound Symbol: £
    case INR  // India Rupee Symbol: ₹
    case ILS  // Israel New Shekel Symbol: ₪
    case JPY  // Japan Yen Symbol: ¥
    case MXN  // Mexico Peso Symbol: $
    case PEN  // Peru Sol Symbol: S/.
    case SAR  // Saudi Arabia Riyal Symbol: ﷼
    case SGD  // Singapore Dollar Symbol: $
    case ZAR  // South Africa Rand Symbol: R$
    case KRW  // South Korea Won Symbol: ₩
    case THB  // Thailand Baht Symbol: ฿
    case CNY  // China Yuan Symbol: ¥
    case AED  // United Arab Emirates Dirham Symbol: د.إ
    case GBP  // United Kingdom Pound Symbol: £
    case EUR  // Eurozone Euro Symbol: €
    
    static let allValues = ["USD", "AUD", "BRL", "CAD", "EGP", "INR", "ILS", "JPY", "MXN", "PEN", "SAR", "SGD", "ZAR", "KRW", "THB", "CNY", "AED", "GBP", "EUR"]
    
}

class ExchangeRate: NSObject, NSCoding {
    public var countryCode: String
    public var rate: Double
    public var lastUpdated: Date
    

    
    //MARK: Types
    
    init(countryCode: String, rate: Double, lastUpdated: Date) {
        self.countryCode = countryCode
        self.rate = rate
        self.lastUpdated = lastUpdated
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(countryCode, forKey: "countryCode")
        aCoder.encode(rate, forKey: "rate")
        aCoder.encode(lastUpdated, forKey: "lastUpdated")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {

        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let countryCode = aDecoder.decodeObject(forKey: "countryCode") as? String? else {
            os_log("Unable to decode the ISO code for ExchangeRate object.", log: OSLog.default, type: .debug)
            return nil
        }

        guard let rate = aDecoder.decodeObject(forKey: "rate") as? Double? else {
            os_log("Unable to decode the excahnge rate", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let date:Date? = aDecoder.decodeObject(forKey: "lastUpdated") as? Date? else {
            os_log("Unable to decode lastUpdated for ExchangeRate object.", log: OSLog.default, type: .debug)
            return nil
        }

        if countryCode != nil && rate != nil && date != nil {
            self.init(countryCode: countryCode!, rate: rate!, lastUpdated: date!)
        } else {
            self.init(countryCode: "AAA/AAA", rate: 6.02, lastUpdated: Date())
        }
        
    }
    
    func logExchangeRate() {
        print("**************")
        print("Logging exchange rate object \(self.countryCode) \(self.rate) \(self.lastUpdated)")
//        print(self.countryCode)
//        print(self.rate)
//        print(self.lastUpdated)
//        print("...............")
    }
    
}


class Currency: NSObject, NSCoding, Comparable {
    //MARK: Properties
    
    var country: String
    var code: String
    // only archive the image filename, so store that too
    var flag: UIImage?
    var flagFile: String
    var favoritePosition: Int
    var fave: Bool = false
    var lastUpdate: NSDate

    // I think this is a dictionary with ISOCode as the key, and an ExchangeRate struct as the value
    var conversions = Dictionary<String, ExchangeRate>()
    var numberOfConversions: Int {
        get {
            return conversions.count
        }
    }
    
    
    
    //MARK: Types
    
//    struct PropertyKey {
//        static let code = "code"
//        static let flag = "flag"
//        static let fave = "fave"
//        static let favoritePosition = "favoritePosition"
//        static let conversions = "conversions"
//    }
    
    
    
    //MARK: Initialization
    
    init?(code: String, flag: String, favoritePosition: Int, fave: Bool, exchangeRates: Dictionary<String, ExchangeRate>) {
        self.country = codeToCountryName(code: code)
        // This will fail in the function if there's no ISO code for country
        self.code = code
        self.flagFile = flag
        self.flag = UIImage(named: flag)!
        self.fave = fave
        self.favoritePosition = favoritePosition
        self.lastUpdate = NSDate()

        super.init()

        if self.fave {
        // look up the conversions to other currencies, fill in the dictionary with its items.
            print("lookin up exchange rates for \(self.country) (code \(self.code))")
            self.exchangeRateLookup(fromCode: self.code)
        } else {
            // just use the existing currency exchange rates
            
            conversions = exchangeRates
        }
    }
    
    // Basic initializer, doesn't look up anything.
    init?(code: String, flag: String, position: Int) {
        self.country = codeToCountryName(code: code)
        self.code = code
        self.flagFile = flag
        self.flag = UIImage(named: flag)!
        self.fave = false
        self.favoritePosition = position
        self.lastUpdate = NSDate()

    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(code, forKey: "code")
        aCoder.encode(flagFile, forKey: "flagFile")
        aCoder.encode(fave, forKey: "fave")
        aCoder.encode(favoritePosition, forKey: "favoritePosition")
        aCoder.encode(conversions, forKey: "conversions")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The ISO code is required. If we cannot decode it, the initializer should fail.
        guard let code = aDecoder.decodeObject(forKey: "code") as? String else {
            os_log("Unable to decode ISO Code for a Currency object.", log: OSLog.default, type: .debug)
            return nil
        }
        let flagFile = aDecoder.decodeObject(forKey: "flagFile") as? String
//        let flag = UIImage(named: flagFile!)!

        
        let fave = aDecoder.decodeBool(forKey: "fave")
        let favoritePosition = aDecoder.decodeInteger(forKey: "favoritePosition")
        
        let conversions = aDecoder.decodeObject(forKey: "conversions") as? Dictionary<String, ExchangeRate>
        
        // Must call designated initializer.
        self.init(code: code, flag: flagFile!, favoritePosition: favoritePosition, fave: fave, exchangeRates: conversions!)
    }
    
    //MARK: Comparable protocol implementation
    
    static func < (lhs: Currency, rhs: Currency) -> Bool {
        let left: String
        let right: String
        if (lhs === rhs) {
            // Irreflexivity
            return false
        }
        if lhs.fave  {
            // left side is a fave
            if !rhs.fave {
                return true
            } else {
                // both are faves, compare favoritePosition
                if lhs.favoritePosition == rhs.favoritePosition {
                    // find order by string value of ISO Code
                    left = lhs.code
                    right = rhs.code
                } else if lhs.favoritePosition < rhs.favoritePosition {
                    return true
                } else {
                    return false
                }
            }
        } else  {
            // left is not a fave
            if rhs.fave {
                return false
            } else {
                // neither are faves, compare favoritePosition
                if lhs.favoritePosition == rhs.favoritePosition {
                    // find order by string value of ISO Code
                    left = lhs.code
                    right = rhs.code
                } else if lhs.favoritePosition < rhs.favoritePosition {
                    return true
                } else {
                    return false
                }
                
            }
        }
        if left < right {
            return true
        } else {
            return false
        }
    }
    
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        if lhs == rhs {
            return true
        }
        if lhs.fave == rhs.fave && lhs.favoritePosition == rhs.favoritePosition && lhs.code == rhs.code {
            return true
        } else {
            return false
        }
    }

    
    //MARK: YQL query

    func addExchangeRate(key: String, rate: ExchangeRate) {
//        print("adding...")
//        rate.logExchangeRate()
        self.conversions[key] = rate
//        print("added one exchange rate to \(self.country)")
    }

    func updateExchangeRates() {
        self.exchangeRateLookup(fromCode: self.code)
//        print("The country \(self.country) claims to have \(self.conversions.count) exchange rates in it")
    }

    // Cargo-culted from:
    //  Created by David McLaren on 4/2/17.
    //  Copyright © 2017 David McLaren. All rights reserved.
        func exchangeRateLookup(fromCode: String)  {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            let myYQL = YQL()
            let allValues = ["USD", "AUD", "BRL", "CAD", "EGP", "INR", "ILS", "JPY", "MXN", "PEN", "SAR", "SGD", "ZAR", "KRW", "THB", "CNY", "AED", "GBP", "EUR"]
            var partialQueryString:String = "" // = "\"USDGBP\", \"USDCAD\", \"USDEUR\", \"USDJPY\", \"USDMXN\""
            for val in allValues.enumerated() {
                partialQueryString += "\"" + fromCode + val.element + "\", "
            }

            let endIndex = partialQueryString.index(partialQueryString.endIndex, offsetBy: -2)
            let truncated = partialQueryString.substring(to: endIndex)

            var queryString = "select * from yahoo.finance.xchange where pair in ("
            queryString +=  truncated
            queryString += ")"
            print(queryString)
            // Network session is asyncronous so use a closure to act upon data once data is returned
            myYQL.query(queryString) { jsonDict in
                var code: String
                var date: Date
                var rate: Double
                
                let queryDict = jsonDict["query"] as! [String: Any]
                let rates = queryDict["results"] as! [String: Any]
                        print("*********************")

                print("there are \(rates.count) results in 'rates'")
                let r = rates["rate"] as! [Dictionary<String,Any>]
                for i in r {
//                    print("Parsing YAHOO Finance data for \(fromCode)")
                    let oneCurrencyRecord = i as! [String: Any]
                    code = oneCurrencyRecord["Name"]! as! String
                    let rateText:String = oneCurrencyRecord["Rate"]! as! String
                    
                    let dateString:String = oneCurrencyRecord["Date"] as! String
                    if dateString != "N/A"{
                        date = dateFormatter.date(from: dateString)! as Date
                    } else {
                        date = Date()
                    }
                    rate = Double(rateText)!
                    let exchangeRateObject: ExchangeRate = ExchangeRate(countryCode: code, rate: rate, lastUpdated: date)
                    self.addExchangeRate(key: code, rate: exchangeRateObject)
                    
                }
        }

    }

    //MARK: Debugging methods
    func numberOfConversions(forCurrency: Currency) -> Int {
        return forCurrency.conversions.count
    }
}

//MARK: Helpers

func codeToCountryName(code: String) -> String {
    switch code {
    case "USD":
        return "United States"
    case "AUD":
        return "Australia"
    case "BRL":
        return "Brazil"
    case "CAD":
        return "Canada"
    case "EGP":
        return "Egypt"
    case "INR":
        return "India"
    case "ILS":
        return "Israel"
    case "JPY":
        return "Japan"
    case "MXN":
        return "Mexico"
    case "PEN":
        return "Peru"
    case "SAR":
        return "Saudi Arabia"
    case "SGD":
        return "Singapore"
    case "ZAR":
        return "South Africa"
    case "KRW":
        return "South Korea"
    case "THB":
        return "Thailand"
    case "CNY":
        return "China"
    case "AED":
        return "United Arab Emirates"
    case "GBP":
        return "United Kingdom"
    case "EUR":
        return "Eurozone"
        
    // Not one of my chosen currencies.
    default:
        fatalError("No country for this ISO Code")
    }
}

