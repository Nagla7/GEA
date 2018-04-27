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
    
    @IBOutlet weak var SC: UISegmentedControl!
    
    @IBOutlet weak var requestsTable: UITableView!
    var Prequests=[NSDictionary]()
    var Arequests=[NSDictionary]()
    var Drequests=[NSDictionary]()
    var index = Int()
    var ref = Database.database().reference()
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
           print("defalut")
        }
      requestsTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //sections objects array
      //objectsArray = [Objects(sectionName: "", sectionObjects: [" "," "])]
        
        //table delegate
        requestsTable.delegate = self
        requestsTable.dataSource = self
        ref = Database.database().reference()
        //////////////
      //  let nib = UINib(nibName: "CustomCell",bundle:nil)
       // complaintTable.register(nib, forCellReuseIdentifier: "CustomCell")
        // requestsTable.register(nib, forCellReuseIdentifier: "CustomCell")
        if(index==0){
            SC.selectedSegmentIndex=0
        }
        else if(index==1){
            SC.selectedSegmentIndex = 1
        }
        else{
            SC.selectedSegmentIndex = 2
        }
        ref.child("IssuedEventsRequests").observe(.value, with:{ (snapshot) in
            if snapshot.exists(){
                print("rere")
                self.Prequests.removeAll()
                self.Arequests.removeAll()
                self.Drequests.removeAll()
                var deta=snapshot.value as! [String:NSDictionary]
                for(_ , value) in deta{
                    let req = value as! NSDictionary
                    print(req)
                    print("heere i am")
                    if(req["status"] as! String == "Pending" ){
                        self.Prequests.append(req)}
                    else if (req["status"] as! String == "Approved"){
                        self.Arequests.append(req)
                    }
                    else{
                        self.Drequests.append(req)
                    }
                }
                self.requestsTable.reloadData()
            }
            else {print("there is no requests")
        }
        })
       print(Prequests)
        print(Arequests)
        if(Prequests.count == 0){
            requestsTable.isHidden = true
        }
        else{
        requestsTable.isHidden = false
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(index == 0){
            if(Prequests.count == 0){
                requestsTable.isHidden = true
            }
            else{
                requestsTable.isHidden = false
            }
            return Prequests.count
        }
       else if(index == 1){
            if(Arequests.count == 0){
                requestsTable.isHidden = true
            }
            else{
                requestsTable.isHidden = false
            }
            return Arequests.count
        }
        else{
            if(Drequests.count == 0){
                requestsTable.isHidden = true
            }
            else{
                requestsTable.isHidden = false
            }
            return Drequests.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = requestsTable.dequeueReusableCell(withIdentifier: "ccell") as! ReqTableViewCell
          let cell2 = requestsTable.dequeueReusableCell(withIdentifier: "ccell") as! ReqTableViewCell
          let cell3 = requestsTable.dequeueReusableCell(withIdentifier: "ccell") as! ReqTableViewCell
        
        
        if(index == 0){
           let req = Prequests[indexPath.row]
            ref.child("ServiceProviders").queryOrdered(byChild: "UID").queryEqual(toValue: req["SPID"] as! String).observeSingleEvent(of: .value , with: { snapshot in
                if snapshot.exists() {
                    //getting the email to login
                    
                    let data = snapshot.value as! [String: Any]
                    for (_,value) in data {
                        var cn = "df"
                        let user = value as? NSDictionary
                        cn = user!["companyname"] as! String
                         cell1.serviceP.text = cn
                    }
                }})
            
           cell1.EventName.text = req["EventName"] as? String
           
            return cell1
        }
            
        else if(index == 1){
           let req = Arequests[indexPath.row]
            ref.child("ServiceProviders").queryOrdered(byChild: "UID").queryEqual(toValue: req["SPID"] as! String).observeSingleEvent(of: .value , with: { snapshot in
                if snapshot.exists() {
                    //getting the email to login
                    
                    let data = snapshot.value as! [String: Any]
                    for (_,value) in data {
                        var cn = "df"
                        let user = value as? NSDictionary
                        cn = user!["companyname"] as! String
                        cell2.serviceP.text = cn
                    }
                }})
            
        cell2.EventName.text = req["EventName"]  as? String
            return cell2
        }
            
        else{
            let req = Drequests[indexPath.row]
            ref.child("ServiceProviders").queryOrdered(byChild: "UID").queryEqual(toValue: req["SPID"] as! String).observeSingleEvent(of: .value , with: { snapshot in
                if snapshot.exists() {
                    //getting the email to login
                    
                    let data = snapshot.value as! [String: Any]
                    for (_,value) in data {
                        var cn = "df"
                        let user = value as? NSDictionary
                        cn = user!["companyname"] as! String
                        cell3.serviceP.text = cn
                    }
                }})
            
           cell3.EventName.text = req["EventName"] as? String
            return cell3
        }
        
        
    }
    
    //num of sections we have
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //display sections on header of table
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var req = NSDictionary()
        if(index == 0){
            req = Prequests[indexPath.row]}
        else   if( index == 1){
             req = Arequests[indexPath.row]}
        else{
            req = Drequests[indexPath.row]
        }
        
        
        let SP = UIStoryboard(name: "Main" , bundle: nil)
        let RInfo = SP.instantiateViewController(withIdentifier: "reqD") as! ReqDetailsViewController
        RInfo.req = req
        
        if( index == 0 ){
            RInfo.flag = false
           
        }
        else{
            RInfo.flag = true
           
        }
        self.navigationController?.pushViewController(RInfo, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /////////////////////////////////
   
    
    
    
    
}
