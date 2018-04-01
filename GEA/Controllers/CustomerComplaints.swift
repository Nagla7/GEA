//
//  CustomerComplaints.swift
//  GEA
//
//  Created by leena hassan on 16/06/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CustomerComplaints: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //customer complaints table
   var   ref = Database.database().reference()
    var dbHandle : DatabaseHandle!
    @IBOutlet weak var complaintsTable: UITableView!
    var complaints : [NSDictionary]!
    
    //table sections
   // struct Objects{
     //   var sectionName: String!
      //  var sectionObjects: [String]!
   // }
  //  var objectsArray = [Objects]()
    
    
    //let sections=["in progress","completed"]
    //try
    // var data = ["  ","   "]
    //var p: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
       
        ref.child("Complaint").observe(.value, with: { (snapshot) in
            if let deta=snapshot.value as? [String:Any]{
                print(deta, "heeere " )
                for (_,value) in deta{
                    let complaint=value as! NSDictionary
                    self.complaints.append(complaint)
                }
         
            }
            else {print("there is no complaints")}
        })
        //sections objects array
        //objectsArray = [Objects(sectionName: "In progress", sectionObjects: [" "," "]),Objects(sectionName: "Completed", sectionObjects: [" "," "])]
        
        //table delegate
        complaintsTable.delegate = self
        complaintsTable.dataSource = self}
        
        ///////custom cell
      //  let nib = UINib(nibName: "CustomCell",bundle:nil)
      //  complaintsTable.register(nib, forCellReuseIdentifier: "CustomCell")
        
        //color table
        // complaintsTable.backgroundColor = UIColor.clear
        //  p=0
    
    ////table color
    //func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    // cell.backgroundColor = UIColor.clear
    // }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
       // return objectsArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = complaintsTable.dequeueReusableCell(withIdentifier: "cell") as! complaintTableViewCell
        let complaint  = complaints[indexPath.row]
        cell.EventName.text = complaint["EventName"] as! String
        return cell
        
    }
    //num of sections we have
    
    //display sections on header of table
    //func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     //   return objectsArray[section].sectionName
  //  }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    /////////////////////////////////
   /* func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //let delete = UITableViewRowAction(style: .destructive, title:"Delete", handler:{ action , indexPath in
        //  print("delete")
        var approveAction = UITableViewRowAction()
       
            approveAction = UITableViewRowAction(style: .default, title:"completed") {(action, indexPath) in
                print("completed")
            
            approveAction.backgroundColor =  UIColor(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            // let disapproveAction = UITableViewRowAction(style: .default, title:"in progress") {(action, indexPath) in
            // print("in progress")
            
           
        }
        
        return [approveAction]
    }
    
    
}*/
