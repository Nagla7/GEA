//
//  CustomerComplaints.swift
//  GEA
//
//  Created by leena hassan on 05/06/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit

class CustomerComplaints: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //customer complaints table
    @IBOutlet weak var complaintsTable: UITableView!
    
    //table sections
    struct Objects{
        var sectionName: String!
        var sectionObjects: [String]!
    }
    var objectsArray = [Objects]()
    
    
     //let sections=["in progress","completed"]
    //try
   // var data = ["  ","   "]
    //var p: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        //sections objects array
        objectsArray = [Objects(sectionName: "In progress", sectionObjects: [" "," "]),Objects(sectionName: "Completed", sectionObjects: [" "," "])]
        
        //table delegate
        complaintsTable.delegate = self
        complaintsTable.dataSource = self
        
        ///////custom cell
        let nib = UINib(nibName: "CustomCell",bundle:nil)
        complaintsTable.register(nib, forCellReuseIdentifier: "CustomCell")
       
        //color table
        // complaintsTable.backgroundColor = UIColor.clear
        //  p=0
    }
       ////table color
       //func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // cell.backgroundColor = UIColor.clear
       // }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = complaintsTable.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        cell.textLabel?.text = objectsArray[indexPath.section].sectionObjects[indexPath.row]
        return cell
        
    }
    //num of sections we have
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectsArray.count
    }
    //display sections on header of table
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsArray[section].sectionName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /////////////////////////////////
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //let delete = UITableViewRowAction(style: .destructive, title:"Delete", handler:{ action , indexPath in
        //  print("delete")
        var approveAction = UITableViewRowAction()
        if(indexPath.section == 0){
        approveAction = UITableViewRowAction(style: .default, title:"completed") {(action, indexPath) in
            print("completed")
        }
        approveAction.backgroundColor =  UIColor(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
       // let disapproveAction = UITableViewRowAction(style: .default, title:"in progress") {(action, indexPath) in
           // print("in progress")
            
           return [approveAction]
        }
        
        return[]
        
        }
 

}

