//
//  ManageAccounts.swift
//  GEA
//
//  Created by leena hassan on 29/05/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit

class ManageAccounts: UIViewController {

    @IBOutlet weak var tableOne: UITableView!
    @IBOutlet weak var tableTwo: UITableView!
    @IBOutlet weak var tableThree: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("first")
            tableOne.isHidden=false
            tableTwo.isHidden=true
            tableThree.isHidden=true
        case 1:
            print("second")
            tableOne.isHidden=true
            tableTwo.isHidden=false
            tableThree.isHidden=true
        case 2:
            print("third")
            tableOne.isHidden=true
            tableTwo.isHidden=true
            tableThree.isHidden=false
        default:
            break
        }
    }
    

}
