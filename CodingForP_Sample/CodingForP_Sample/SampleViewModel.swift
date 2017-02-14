//
//  SampleViewModel.swift
//  CodingForP_Sample
//
//  Created by Harly on 2017/2/6.
//  Copyright © 2017年 MogoOrg. All rights reserved.
//

import UIKit

class SampleViewModel: NSObject {

    func samplePlist()
    {
        let sampleSource = ["userName" : "harly", "userId" : "123", "price" : ""]
        guard let plistPath = Bundle.main.path(forResource: "sampleCodingP", ofType: "plist") else { return }
        guard let dic = NSDictionary(contentsOfFile: plistPath) as? [String : String] else { return }
        
        for (key , value) in dic
        {
            print("\(key) -> \(smartTranslate(value, fromLazyServerJson: sampleSource as [String : AnyObject]))")
        }
    }
}
