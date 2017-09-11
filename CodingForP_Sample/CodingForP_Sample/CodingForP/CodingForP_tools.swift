//
//  CodingForP_tools.swift
//  MogoPartner
//
//  Created by Harly on 2016/12/25.
//  Copyright © 2016年 mogoroom. All rights reserved.
//

import Foundation

let CodingForP_FormatStartSignal = "-p"

let CodingForP_StringPrefix = "*&"
let CodingForP_StringSuffix = "&*"

let CodingForP_NullablePrefix = "<|"
let CodingForP_NullableSuffix = "|>"

let CodingForP_CurrencyPrefix = "*$"
let CodingForP_CurrencySuffix = "$*"

let CodingForP_FormatSuffix = "#*"
let CodingForP_FormatPrefix = "*#"

let CodingForP_FormatedSplit = "^*^"


let CodingForP_DefaultEqual = "*="

/// translate JSON according to the formatString
/// -p should be the prefix for all the formats
/// e.g plistString - "-p *&studentName&* 's score is *&score&*"
///     serverDic - ["studentName" : "Harly" , "score" :
/// "99"]
/// -> result = "Harly's score is 99"
/// - Parameters:
///   - plistString: String in P
///   - serverDic: Your server JSON
/// - Returns: ResultString formatted from [plistString]
func smartTranslate(_ plistString : String ,
                    fromLazyServerJson serverDic : [String : Any])
    -> String
{
    //Verify -p exsistance, if not, returns the normal key-value
    guard plistString.hasPrefix(CodingForP_FormatStartSignal) else
    {
        return realString(para: serverDic[plistString])
    }

    let currencyValue = smartCurrencyTranslate(plistString, fromLazyServerJson: serverDic)
    
    let decimalValue = smartFormatedTranslate(currencyValue, fromLazyServerJson: serverDic)
    
    let stringWithoutNullable = smartNullableTranslate(decimalValue, fromLazyServerJson: serverDic)
    
    return smartInternalTranslate(stringWithoutNullable, suffix: CodingForP_StringSuffix, prefix: CodingForP_StringPrefix, fromLazyServerJson: serverDic).0
    
}

let currencyFormat = NumberFormatter()

func stringFromCurrencyNumber(_ number : Any , needZero : Bool) -> String
{
    currencyFormat.numberStyle = .currency
    currencyFormat.currencySymbol = ""
    
    let realStringNum = realString(para: number)
    let currency = (realStringNum as NSString).doubleValue
    
    if  currency == 0
    {
        return  needZero ? "0.00":""
    }
    if let currencyNumber = currencyFormat.string(from : NSNumber(value: currency))
    {
        return currencyNumber
    }
    
    return needZero ? "0.00":""
}

func smartCurrencyTranslate(_ plistString : String, fromLazyServerJson serverDic : [String : Any]) -> String
{
    let keyPairForCurrency = smartInternalTranslate(plistString, suffix: CodingForP_CurrencySuffix, prefix: CodingForP_CurrencyPrefix, fromLazyServerJson: serverDic).1
    
    let format = NumberFormatter()
    
    format.numberStyle = .currency
    format.currencySymbol = ""
    
    var resultCurrencyString = plistString
    
    for (key,value) in keyPairForCurrency
    {
        let currency = (value as NSString).doubleValue
        
        let currenctyReplacement = CodingForP_CurrencyPrefix + key + CodingForP_CurrencySuffix
        
        if let currencyNumber = format.string(from : NSNumber(value: currency))
        {
            resultCurrencyString = resultCurrencyString.replacingOccurrences(of: currenctyReplacement, with: currencyNumber)
        }
        else
        {
            let zero = format.string(from: NSNumber(value : 0))
            resultCurrencyString = resultCurrencyString.replacingOccurrences(of: currenctyReplacement, with: zero!)
        }

    }
    
    return resultCurrencyString
}

func smartFormatedTranslate(_ plistString : String, fromLazyServerJson serverDic : [String : Any]) -> String
{
    let keyPairForDecimal = smartInternalTranslate(plistString, suffix: CodingForP_FormatSuffix, prefix: CodingForP_FormatPrefix, fromLazyServerJson: serverDic).1
    
    var resultCurrencyString = plistString
    
    for (key,value) in keyPairForDecimal
    {
        var currency = (value as NSString).doubleValue
        
        let splited = key.components(separatedBy: CodingForP_FormatedSplit)
        
        var formate = ""
        
        var realKey = ""
        
        realKey = splited.count == 1 ? key : splited.first!
        
        if splited.count == 2
        {
            formate = splited.last!
        }
        
        let currenctyReplacement = CodingForP_FormatPrefix + key + CodingForP_FormatSuffix
        
        let realReplacement = CodingForP_FormatPrefix + realKey + CodingForP_FormatSuffix
        
        if splited.count > 1
        {
            let realValues = smartInternalTranslate(realReplacement, suffix: CodingForP_FormatSuffix, prefix: CodingForP_FormatPrefix, fromLazyServerJson: serverDic).1
            
            currency = (realValues.values.first! as NSString).doubleValue
        }
        
        let currencyNumber = formate.isEmpty ? "\(currency)" : String(format: formate, currency)
        
        resultCurrencyString = resultCurrencyString.replacingOccurrences(of: currenctyReplacement, with: currencyNumber)
    }
    
    return resultCurrencyString
}

func smartInternalTranslate(_ plistString : String ,
                            suffix : String ,
                            prefix : String ,
                    fromLazyServerJson serverDic : [String : Any])
    -> (String , [String : String])
{
    let strArrayWithoutPrefix = plistString.components(separatedBy: prefix)
    
    let splitedsContainsSuff = strArrayWithoutPrefix.filter { $0.contains(suffix)}
    
    var spitedList = [String]()
    
    splitedsContainsSuff.forEach { (splited) in
        let realKey = splited.components(separatedBy: suffix).first
        if let key = realKey
        {
            spitedList.append(key)
        }
    }
    
    var resultString = plistString
    
    var keyPair = [String : String]()
    
    for key in spitedList {
        
        let defaultArray = key.components(separatedBy: CodingForP_DefaultEqual)
        
        guard let jsonKey = defaultArray.first else { continue }
        let defaultValue = defaultArray.last
        
        var pairedValue = realString(para: serverDic[jsonKey])
        
        if pairedValue.isEmpty
        {
            if let defaultParied = defaultValue, !defaultParied.isEmpty && defaultValue != jsonKey
            {
                pairedValue = defaultParied
            }
        }
        
        keyPair[jsonKey] = pairedValue
        
        let preSufxString = prefix + key + suffix
        
        resultString = resultString.replacingOccurrences(of : preSufxString, with: pairedValue)
    }
    
    resultString = resultString.replacingOccurrences(of: CodingForP_FormatStartSignal, with: "")
    
    return (resultString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ,keyPair)
}

func smartNullableTranslate(_ plistString : String ,
                    fromLazyServerJson serverDic : [String : Any])
    -> String
{
    //Verify -p exsistance, if not, returns the normal key-value
    guard plistString.hasPrefix(CodingForP_FormatStartSignal) else
    {
        return realString(para: serverDic[plistString]!)
    }
    
    let strArrayWithoutPrefix = plistString.components( separatedBy: CodingForP_NullablePrefix)
    
    let splitedsContainsSuff = strArrayWithoutPrefix.filter { $0.contains(CodingForP_NullableSuffix) }
    
    var spitedList = [String]()
    
    splitedsContainsSuff.forEach { (splited) in
        let realKey = splited.components(separatedBy: CodingForP_NullableSuffix).first
        if let key = realKey
        {
            spitedList.append(key)
        }
    }
    
    var resultString = plistString
    
    for jsonKey in spitedList {
        //        let pairedValue = realString(serverDic[jsonKey])
        
        let paired = smartInternalTranslate(jsonKey, suffix: CodingForP_StringSuffix, prefix: CodingForP_StringPrefix, fromLazyServerJson: serverDic)
        
        var hasNullValue = false
        
        paired.1.forEach({ (_, value) in
            if value.isEmpty ||  value == "0"
            {
                hasNullValue = true
            }
        })
        
        let preSufxString = CodingForP_NullablePrefix + jsonKey + CodingForP_NullableSuffix
        
        if hasNullValue
        {
            resultString = resultString.replacingOccurrences(of: preSufxString, with: "")
        }
        else
        {
            resultString = resultString.replacingOccurrences(of: preSufxString, with: paired.0)
        }
    }
    
    resultString = resultString.replacingOccurrences(of: CodingForP_FormatStartSignal, with: "")
    
    return resultString.trimmingCharacters(in :
        CharacterSet.whitespacesAndNewlines)
    
}
