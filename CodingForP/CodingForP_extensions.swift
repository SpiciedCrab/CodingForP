//
//  CodingForP_extensions.swift
//  MogoPartner
//
//  Created by Harly on 2016/12/25.
//  Copyright © 2016年 mogoroom. All rights reserved.
//

import Foundation

let dateFormate = DateFormatter()

/// 万能string转换
///
/// - Parameter para: 转化前参数
/// - Returns: 真的参数
func realString(para : AnyObject?) -> String {
    guard let realPara = para else { return "" }
    if realPara is String
    {
        return realPara as! String
    }
    else if realPara is NSNumber
    {
        if let stringNum = realPara.stringValue
        {
            return stringNum
        }
        else if let intNum = realPara.int64Value
        {
            return "\(intNum)"
        }
        else
        {
            return ""
        }
    }
    else if realPara is Date
    {
        return dateFormate.string(from: realPara as! Date)
    }
    else
    {
        return ""
    }
}
