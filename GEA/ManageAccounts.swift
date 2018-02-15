//
//  ManageAccounts.swift
//  GEA
//
//  Created by leena hassan on 29/05/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit

class ManageAccounts: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func indexChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            print("first")
        case 1:
            print("second")
        case 2:
            print("third")
        default:
            break
        }
    }
    

}
