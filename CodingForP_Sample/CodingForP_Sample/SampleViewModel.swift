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
    
    func setupData() -> [String : Any]
    {
        let sampleSource = ["id" : "10000", "name" : "Fish", "salary" : 5000 , "summary" : "fff", "description" : "sss"] as [String : Any]
        let person = Person(json : sampleSource)
        return ["Name" : person.name,
                "Salary" : person.displayedSalary ,
                "Summary" : person.summary ,
                "Desciprtion" : person.displayedDiscription]
        
        
    }
}

struct Person
{
    var id : String!
    var name : String!
    var salary : Double = 0
    var summary : String!
    var description : String!
    
    var displayedDiscription : String  {
        return "PersonId : \(id) \n Description : \(description)"
    }
    
    var displayedSalary : String  {
        return currencyGenerator(currencyDoubleValue: salary)
    }
    
    func currencyGenerator(currencyDoubleValue : Double) -> String
    {
        return ""
    }
    
    init(json : [String : Any]) {
        
   }
}

struct ConfigRow
{
    // left title
    var key : String!
    
    // right title
    var value : String!
    var sortOrder : Int = 0
    var color : String = ""
}
