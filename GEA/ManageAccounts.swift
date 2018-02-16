//
//  ManageAccounts.swift
//  GEA
//
//  Created by leena hassan on 29/05/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit

class ManageAccounts: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var tableOne: UITableView!
    @IBOutlet weak var tableTwo: UITableView!
    @IBOutlet weak var tableThree: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    ////////////////////////////////////////////
    var data = [
        ["Soccer",       "Golf",      "Basketball",    "American Football",
         "Baseball",     "Tennis"]
    ]
    
    var p: Int!
    ////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
////////////
        
        let nib = UINib(nibName: "CustomCell",bundle:nil)
        tableOne.register(nib, forCellReuseIdentifier: "CustomCell")
        //tableOne.backgroundColor=UIColor.darkGray
        p=0
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[p].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableOne.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            
        case 0:
            print("first")
            tableThree.isHidden=true
            tableOne.isHidden=false
            tableTwo.isHidden=true
            //tableOne.reloadData()
            
            
            
        case 1:
            print("second")
            tableTwo.isHidden=false
            tableOne.isHidden=true
            tableThree.isHidden=true
            
        case 2:
            print("third")
            tableThree.isHidden=false
            tableOne.isHidden=true
            tableTwo.isHidden=true
            
        default:
            break
        }
    }
    

}
