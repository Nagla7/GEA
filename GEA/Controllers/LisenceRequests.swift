//
//  LisenceRequests.swift
//  GEA
//
//  Created by leena hassan on 05/06/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth



class LisenceRequests: UIViewController,UITableViewDelegate,UITableViewDataSource {


    //lisence request table
    
    @IBOutlet weak var requestsTable: UITableView!
    var Prequests : [NSDictionary]!
    var Arequests : [NSDictionary]!
    var Drequests : [NSDictionary]!
    var index = 0
    var ref : DatabaseReference!
    var dbHandle : DatabaseHandle!

    //table sections
    /*struct Objects{
        var sectionName: String!
        var sectionObjects: [String]!
    }
    var objectsArray = [Objects]()*/
    
    //try
    //var data = ["    ","     "]
    //var p: Int!
    @IBAction func index(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            index = 0
        case 1:
            index = 1
        case 2:
            index = 2
        default:
            index = 0
        }
      requestsTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //sections objects array
      //  objectsArray = [Objects(sectionName: "", sectionObjects: [" "," "])]
        
        //table delegate
        requestsTable.delegate = self
        requestsTable.dataSource = self
        ref = Database.database().reference()
        //////////////
      //  let nib = UINib(nibName: "CustomCell",bundle:nil)
       // complaintTable.register(nib, forCellReuseIdentifier: "CustomCell")
        // requestsTable.register(nib, forCellReuseIdentifier: "CustomCell")
        
      /*  ref.child("IssuedEventsRequests").observe(.value, with: { (snapshot) in
            if let deta=snapshot.value as? [String:Any]{
                print(deta,"98989")
                for (_,value) in deta{
                    let req = value as! NSDictionary
                    if(req["Status"] as! String == "Pending" ){
                        self.Prequests.append(req)}
                    else if (req["Status"] as! String == "Approved"){
                        self.Arequests.append(req)
                    }
                    else{
                        self.Drequests.append(req)
                    }
                }
                self.requestsTable.reloadData()
            }
            else {print("there is no requests")}
        })
       print(Prequests)
        print(Arequests)*/
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       /* if(index == 0){
            return Prequests.count
        }
       else if(index == 1){
            return Arequests.count
        }
        else{
            return Drequests.count
        }*/
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = requestsTable.dequeueReusableCell(withIdentifier: "ccell") as! ReqTableViewCell
          let cell2 = requestsTable.dequeueReusableCell(withIdentifier: "ccell") as! ReqTableViewCell
          let cell3 = requestsTable.dequeueReusableCell(withIdentifier: "ccell") as! ReqTableViewCell
        
      //  cell.textLabel?.text = objectsArray[indexPath.section].sectionObjects[indexPath.row]
        
        if(index == 0){
          //  let req = Prequests[indexPath.row]
         //   cell1.EventName.text = req["EventName"] as? String
            return cell1
        }
        else if(index == 1){
         //   let req = Arequests[indexPath.row]
          //  cell2.EventName.text = req["EventName"] as? String
            return cell2
        }
        else{
          //  let req = Drequests[indexPath.row]
          //  cell3.EventName.text = req["EventName"] as? String
            return cell3
        }
        
        
    }
    
    //num of sections we have
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //display sections on header of table

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /////////////////////////////////
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //let delete = UITableViewRowAction(style: .destructive, title:"Delete", handler:{ action , indexPath in
        //  print("delete")
        var approveAction = UITableViewRowAction()
        var disapproveAction = UITableViewRowAction()
        if(indexPath.section == 0){
         approveAction = UITableViewRowAction(style: .default, title:"accept") {(action, indexPath) in
            print("yes")
            /*
             let req = self.Prequests[indexPath.row]
             let rid = req["RID"] as! String
             print(rid,"heeereee")
             self.ref.child("IssuedEventsRequests").child(rid).updateChildValues(["Status" : "Approved"])
             self.Prequests.removeAll()
             self.Arequests.removeAll()
             */
        }
        approveAction.backgroundColor =  UIColor(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
         disapproveAction = UITableViewRowAction(style: .default, title:"decline") {(action, indexPath) in
            print("no")
            /*
             let req = self.Prequests[indexPath.row]
             let rid = req["RID"] as! String
             print(rid,"heeereee")
             self.ref.child("IssuedEventsRequests").child(rid).updateChildValues(["Status" : "Declined"])
             self.Prequests.removeAll()
             self.Arequests.removeAll()
             */
        }
       
    return [disapproveAction,approveAction]
        
        }
                
        return[]
        
       
    }
    
    
    
}
