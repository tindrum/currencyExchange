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
    public var countryCode: ISOCode
    public var rate: Double
    public var lastUpdated: NSDate
    
    //MARK: Types
    struct PropertyKey {
        static let countryCode = "countryCode"
        static let rate = "rate"
        static let lastUpdated = "lastUpdated"
    }
    
    init(countryCode: ISOCode, rate: Double, lastUpdated: NSDate) {
        self.countryCode = countryCode
        self.rate = rate
        self.lastUpdated = lastUpdated
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(countryCode, forKey: PropertyKey.countryCode)
        aCoder.encode(rate, forKey: PropertyKey.rate)
        aCoder.encode(lastUpdated, forKey: PropertyKey.lastUpdated)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let countryCode = aDecoder.decodeObject(forKey: PropertyKey.countryCode) as? ISOCode else {
            os_log("Unable to decode the ISO code for ExchangeRate object.", log: OSLog.default, type: .debug)
            return nil
        }

        let rate = aDecoder.decodeObject(forKey: PropertyKey.rate) as? Double
        
        guard let date:NSDate = aDecoder.decodeObject(forKey: PropertyKey.lastUpdated) as? NSDate else {
                os_log("Unable to decode lastUpdated for ExchangeRate object.", log: OSLog.default, type: .debug)
            return nil
            }
        self.init(countryCode: countryCode, rate: rate!, lastUpdated: date)
    }
    
    
}

func codeToCountryName(code: ISOCode) -> String {
    switch code {
    case .USD:
        return "United States"
    case .AUD:
        return "Australia"
    case .BRL:
        return "Brazil"
    case .CAD:
        return "Canada"
    case .EGP:
        return "Egypt"
    case .INR:
        return "India"
    case .ILS:
        return "Israel"
    case .JPY:
        return "Japan"
    case .MXN:
        return "Mexico"
    case .PEN:
        return "Peru"
    case .SAR:
        return "Saudi Arabia"
    case .SGD:
        return "Singapore"
    case .ZAR:
        return "South Africa"
    case .KRW:
        return "South Korea"
    case .THB:
        return "Thailand"
    case .CNY:
        return "China"
    case .AED:
        return "United Arab Emirates"
    case .GBP:
        return "United Kingdom"
    case .EUR:
        return "Eurozone"

    // Not one of my chosen currencies.
    default:
        fatalError("No country for this ISO Code")
    }
}

class Currency: NSObject, NSCoding, Comparable {
    //MARK: Properties
    
    var country: String
    var code: ISOCode
    // only archive the image filename, so store that too
    var flag: UIImage?
    var flagFile: String
    var favoritePosition: Int
    var fave: Bool = false

    // I think this is a dictionary with ISOCode as the key, and an ExchangeRate struct as the value
    var conversions = Dictionary<ISOCode, ExchangeRate>()
    
    
    
    //MARK: Types
    
    struct PropertyKey {
        static let code = "code"
        static let flag = "flag"
        static let fave = "fave"
        static let favoritePosition = "favoritePosition"
        static let conversions = "conversions"
    }
    
    
    
    //MARK: Initialization
    
    init?(code: ISOCode, flag: String, favoritePosition: Int, fave: Bool, exchangeRates: Dictionary<ISOCode, ExchangeRate>) {
        self.country = codeToCountryName(code: code)
        // This will fail in the function if there's no ISO code for country
        self.code = code
        self.flagFile = flag
        self.flag = UIImage(named: flag)!
        self.fave = fave
        self.favoritePosition = favoritePosition
        
        super.init()

        if self.fave {
        // look up the conversions to other currencies, fill in the dictionary with its items.
            print("lookin up exchange rates for \(self.country) (code \(self.code.rawValue))")
            self.conversions = Currency.exchangeRateLookup(fromCode: self.code)
        } else {
            // just use the existing currency exchange rates
            
            conversions = exchangeRates
        }
    }
    
    init?(code: ISOCode, flag: String) {
        self.country = codeToCountryName(code: code)
        self.code = code
        self.flagFile = flag
        self.flag = UIImage(named: flag)!
        self.fave = false
        self.favoritePosition = 0
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(code, forKey: PropertyKey.code)
        aCoder.encode(flag, forKey: PropertyKey.flag)
        aCoder.encode(fave, forKey: PropertyKey.fave)
        aCoder.encode(favoritePosition, forKey: PropertyKey.favoritePosition)
        aCoder.encode(conversions, forKey: PropertyKey.conversions)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The ISO code is required. If we cannot decode it, the initializer should fail.
        guard let code = aDecoder.decodeObject(forKey: PropertyKey.code) as? ISOCode else {
            os_log("Unable to decode ISO Code for a Currency object.", log: OSLog.default, type: .debug)
            return nil
        }
        let flag = aDecoder.decodeObject(forKey: PropertyKey.flag) as? String
        
        let fave = aDecoder.decodeBool(forKey: PropertyKey.fave)
        let favoritePosition = aDecoder.decodeInteger(forKey: PropertyKey.favoritePosition)
        
        let conversions = aDecoder.decodeObject(forKey: PropertyKey.conversions) as? Dictionary<ISOCode, ExchangeRate>
        
        // Must call designated initializer.
        self.init(code: code, flag: flag!, favoritePosition: favoritePosition, fave: fave, exchangeRates: conversions!)
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
                    left = lhs.code.rawValue
                    right = rhs.code.rawValue
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
                    left = lhs.code.rawValue
                    right = rhs.code.rawValue
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
        if lhs.fave == rhs.fave && lhs.favoritePosition == rhs.favoritePosition && lhs.code.rawValue == rhs.code.rawValue {
            return true
        } else {
            return false
        }
    }

    
    //MARK: YQL query

//    func buildQueryParameters(isoCode: ISOCode) -> String {
//        let otherCodes = ISOCode.allValues
//        let thisCode = isoCode.rawValue
//        var queryString: String = ""
//        
//        for code in otherCodes {
//            queryString += "\"" + thisCode + code + "\", "
//        }
//        let resultString = queryString.substring(from:queryString.index(queryString.endIndex, offsetBy: -2))
//        
//        print("The string that will be sent to Yahoo is:")
//        print(resultString)
//        return resultString
//        
//    }
//
//    
//    func parseCodeFromJSONNameField(code: String) -> ISOCode? {
//        var last3 = code.substring(from:code.index(code.endIndex, offsetBy: -3))
//        if last3.characters.count == 3 {
//            last3 = String(describing: ISOCode(rawValue: last3))
//            return ISOCode(rawValue: last3)
//        }
//        return nil
//    }

    static func exchangeRateLookup(fromCode: ISOCode ) -> Dictionary<ISOCode, ExchangeRate> {
        // Cargo-culted from:
        //  Created by David McLaren on 4/2/17.
        //  Copyright © 2017 David McLaren. All rights reserved.
        var conversions: Dictionary<ISOCode, ExchangeRate> = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let myYQL = YQL()
        let partialQueryString:String = self.buildQueryParameters(fromCode)
        let queryString:String = "select * from yahoo.finance.xchange where pair in (" +  "\" + ")"
        
        // Network session is asyncronous so use a closure to act upon data once data is returned
        myYQL.query(queryString) { jsonDict in
            // With the resulting jsonDict, pull values out
            // jsonDict["query"] results in an Any? object
            // to extract data, cast to a new dictionary (or other data type)
            // repeat this process to pull out more specific information
            var code: ISOCode
            var date: NSDate
            var rate: Double
            
            let queryDict = jsonDict["query"] as! [String: Any]
            let rates = queryDict["results"] as! [String: Any]
            let r = rates["rate"] as! [Dictionary<String,String>]
            for i in r {
                code = parseCodeFromJSONNameField(i["Name"]!) as! String
                rate = Double(i["rate"]!)!
                date = dateFormatter.date(from: i["Date"]!)! as NSDate
                print("the rate is:")
                print(i["Rate"]!)
                print("the Name is:")
                print(i["Name"]!)
                print("the date is:")
                print(i["Date"]!)
                let exchangeRateObject: ExchangeRate = ExchangeRate(countryCode: code, rate: rate, lastUpdated: date)
                conversions[code] = exchangeRateObject
                
            }
            
        }
        
        
        return conversions
    }

}
