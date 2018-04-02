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
    var ref = Database.database().reference()
    var dbHandle : DatabaseHandle!
    @IBOutlet weak var complaintsTable: UITableView!
    var complaints = [NSDictionary]()
    var completed = [NSDictionary]()

    var index = 0
    
    @IBAction func index(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            index = 0
           
            
        }
        else{
            index = 1
           
        }
        complaintsTable.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        complaintsTable.delegate = self
        complaintsTable.dataSource = self
        ref.child("Complaint").observe(.value, with: { (snapshot) in
            if let deta=snapshot.value as? [String:Any]{
                for (_,value) in deta{
                    let complaint=value as! NSDictionary
                    if(complaint["status"] as! String == "Completed" ){
                        self.completed.append(complaint)}
                    else{
                        self.complaints.append(complaint)
                    }
                }
                self.complaintsTable.reloadData()
            }
            else {print("there is no complaints")}
        })
        //sections objects array
        //objectsArray = [Objects(sectionName: "In progress", sectionObjects: [" "," "]),Objects(sectionName: "Completed", sectionObjects: [" "," "])]
        
        //table delegate
        
    }
        
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
        if(index == 0){
            return complaints.count}
        else if (index == 1){
            return completed.count
        }
        else{
            return complaints.count
        }
       // return objectsArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     
        
        print("%%%%%%bhb%%%%%%%%%%%%%%%%")
        let cell = complaintsTable.dequeueReusableCell(withIdentifier: "ccell") as! complaintTableViewCell
        
         let cell2 = complaintsTable.dequeueReusableCell(withIdentifier: "ccell") as! complaintTableViewCell
        
        
       
       
        
         if(index == 0){
            
            let complaint  = complaints[indexPath.row]
            print(complaint,"%%%%%%%%%%%%%%%%%%%%%%")
            cell.EventName.text = complaint["EventName"] as? String
            cell.Discription.text = complaint["Discription"] as! String
            cell.Email.text = complaint["CustomerEmail"] as? String
            cell.phone.text = complaint["CustomerPhoneNum"] as? String
            return cell}
        else{
            let complaint2  = completed[indexPath.row]
            cell2.EventName.text = complaint2["EventName"] as? String
            cell2.Discription.text = complaint2["Discription"] as! String
            cell2.Email.text = complaint2["CustomerEmail"] as? String
            cell2.phone.text = complaint2["CustomerPhoneNum"] as? String
            
            return cell2
        }
        
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

    /////////////////////////////////
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //let delete = UITableViewRowAction(style: .destructive, title:"Delete", handler:{ action , indexPath in
        //  print("delete")
        var approveAction = UITableViewRowAction()
    if(index == 0){
            approveAction = UITableViewRowAction(style: .default, title:"completed") {(action, indexPath) in
                print("completed")
                let complaint = self.complaints[indexPath.row]
                let cid = complaint["CID"] as! String
                print(cid,"heeereee")
                self.ref.child("Complaint").child(cid).updateChildValues(["status" : "Completed"])
                self.complaints.removeAll()
                self.completed.removeAll()
              
            approveAction.backgroundColor =  UIColor(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            // let disapproveAction = UITableViewRowAction(style: .default, title:"in progress") {(action, indexPath) in
            // print("in progress")
            
           
        }
        
        return [approveAction]}
    return[]
    }
    
    
}
