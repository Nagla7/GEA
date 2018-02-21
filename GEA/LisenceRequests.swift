//
//  LisenceRequests.swift
//  GEA
//
//  Created by leena hassan on 05/06/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit

class LisenceRequests: UIViewController,UITableViewDelegate,UITableViewDataSource {


    //lisence request table
    
    @IBOutlet weak var requestsTable: UITableView!
    
    //try
    var data = ["    ","     "]
    var p: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //table delegate
        requestsTable.delegate = self
        requestsTable.dataSource = self
        
        //////////////
        let nib = UINib(nibName: "CustomCell",bundle:nil)
       // complaintTable.register(nib, forCellReuseIdentifier: "CustomCell")
         requestsTable.register(nib, forCellReuseIdentifier: "CustomCell")
        
        p=0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[p].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = requestsTable.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /////////////////////////////////
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //let delete = UITableViewRowAction(style: .destructive, title:"Delete", handler:{ action , indexPath in
          //  print("delete")
        let approveAction = UITableViewRowAction(style: .default, title:"accept") {(action, indexPath) in
            print("yes")
        }
        approveAction.backgroundColor =  UIColor(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        let disapproveAction = UITableViewRowAction(style: .default, title:"decline") {(action, indexPath) in
            print("no")
        }
       
    
        
    
                
                return [disapproveAction,approveAction]
        
       
    }
    
    
    
}
