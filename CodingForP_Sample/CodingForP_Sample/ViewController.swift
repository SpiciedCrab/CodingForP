//
//  ViewController.swift
//  CodingForP_Sample
//
//  Created by Harly on 2017/2/6.
//  Copyright © 2017年 MogoOrg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let str = String(format: "%.2f", 1.1)
        //Sample 
        let sampleVm = SampleViewModel()
        sampleVm.samplePlist()
    }


}

