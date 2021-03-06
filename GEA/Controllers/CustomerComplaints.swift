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

class CustomerComplaints: UIViewController,UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet var nocomplaints: UIView!
    //customer complaints table
    var ref = Database.database().reference()
    var dbHandle : DatabaseHandle!
    @IBOutlet weak var complaintsTable: UITableView!
    var complaints = [NSDictionary]()
    var completed = [NSDictionary]()
    var arr1 = false
    var arr2 = false
    var index = 0
    
    @IBAction func index(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            if(complaints.count == 0){
                
                self.view.addSubview(self.nocomplaints)
            }
            else{
                self.nocomplaints.removeFromSuperview()
            }
            index = 0
            break
        case 1:
            index = 1
            if(completed.count == 0){
                self.view.addSubview(self.nocomplaints)
            }
            else{
                self.nocomplaints.removeFromSuperview()
            }
            break
        default:
            if(complaints.count == 0){
                
                self.view.addSubview(self.nocomplaints)
                complaintsTable.isHidden = true
            }
            else{
                self.nocomplaints.removeFromSuperview()
                  complaintsTable.isHidden = false
            }
        }
        complaintsTable.reloadData()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
        complaintsTable.delegate = self
        complaintsTable.dataSource = self
nocomplaints.frame = CGRect(x: 0, y:94, width: 375, height: 539)
        ref.child("Complaint").observe(.value, with: { (snapshot) in
            if let deta=snapshot.value as? [String:Any]{
                self.complaints.removeAll()
                self.completed.removeAll()
               self.nocomplaints.removeFromSuperview()
                for (_,value) in deta{
                    let complaint=value as! NSDictionary
                    if(complaint["status"] as! String == "Completed" ){
                        self.completed.append(complaint)
                    }
                    else{
                        self.complaints.append(complaint)
                    }
                }
                if(self.complaints.count == 0){
                    self.view.addSubview(self.nocomplaints)
                }
                else{
                    self.nocomplaints.removeFromSuperview()
                }
                self.complaintsTable.reloadData()
            }
            else {print("there is no complaints")
              self.view.addSubview(self.nocomplaints)
            }
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
            if(complaints.count == 0){
                complaintsTable.isHidden = true
                self.view.addSubview(self.nocomplaints)
            }
            else{
                 complaintsTable.isHidden = false
                self.nocomplaints.removeFromSuperview()
            }
            let complaint  = complaints[indexPath.row]
            print(complaint,"%%%%%%%%%%%%%%%%%%%%%%")
            cell.EventName.text = complaint["EventName"] as? String
            cell.Discription.text = complaint["Discription"] as! String
            cell.Contact.tag = indexPath.row
            arr1 = true
            cell.Contact.addTarget(self, action: #selector(ContactInfo), for: .touchUpInside)
            
            return cell}
        else{
            complaintsTable.isHidden = false
            let complaint2  = completed[indexPath.row]
            cell2.EventName.text = complaint2["EventName"] as? String
            cell2.Discription.text = complaint2["Discription"] as! String
            cell2.Contact.tag = indexPath.row
            arr2 = true
            cell2.Contact.addTarget(self, action: #selector(ContactInfo), for: .touchUpInside)
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
    
    @objc func ContactInfo(_ sender: UIButton) {
        
                if(index == 0){
           
                    let complaint  = complaints[sender.tag]
                    
                    let Email1 : String!
                    Email1 = complaint["CustomerEmail"] as! String
                    
                    let phone1 : String!
                    phone1 = complaint["CustomerPhoneNum"] as! String
                    
            let alertView = UIAlertController(title: "Contact Info", message: "Customer Contact Info", preferredStyle: .actionSheet)
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
              print("Cancel")
            }
            let Email = UIAlertAction(title: "Email: \(Email1!)"  , style: .default) { (action) in
               // self.displayLbl.text = "Save Successfull"
                print("email44")
                
                
                let alert = UIAlertController(title: "Success" , message: "Email copied to the clipboard", preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "OK", style: .default) { (action) in
                    print("Cancel")
                }
                alert.addAction(cancel)
                print("hiiiii")
                UIPasteboard.general.string = Email1!
                self.present(alert, animated: true, completion: nil)
                 }
               
            
         
            let phone = UIAlertAction(title: "Phone number: \(phone1!)" , style: .default) { (action) in
                print("hiiiii")
                
                let alert = UIAlertController(title: "Success" , message: "Phone number copied to the clipboard", preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "OK", style: .default) { (action) in
                    print("Cancel")
                }
                alert.addAction(cancel)
                print("hiiiii")
                UIPasteboard.general.string = phone1!
                self.present(alert, animated: true, completion: nil)
                }
            
            alertView.addAction(Email)
            alertView.addAction(phone)
            alertView.addAction(cancel)
            
            self.present(alertView, animated: true, completion: nil)
        }
        
                if(index == 1){
                    
                    let complaint  = completed[sender.tag]
                    
                    let Email1 : String!
                    Email1 = complaint["CustomerEmail"] as! String
                    
                    let phone1 : String!
                    phone1 = complaint["CustomerPhoneNum"] as! String
                    let alertView = UIAlertController(title: "Contact Info", message: "Customer Contact Info", preferredStyle: .actionSheet)
                    
                    let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                        print("Cancel")
                    }
                    
                    let Email = UIAlertAction(title: "Email: \(Email1!)"  , style: .default) { (action) in
                        // self.displayLbl.text = "Save Successfull"
                        print("email44")
                        
                        let alert = UIAlertController(title: "Success" , message: "Email copied to the clipboard", preferredStyle: .alert)
                        
                        let cancel = UIAlertAction(title: "OK", style: .default) { (action) in
                            print("Cancel")
                        }
                        alert.addAction(cancel)
                        print("hiiiii")
                        UIPasteboard.general.string = Email1!
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    
                    
                    let phone = UIAlertAction(title: "Phone number: \(phone1!)" , style: .default) { (action) in
                       
                        let alert = UIAlertController(title: "Success" , message: "Phone number copied to the clipboard", preferredStyle: .alert)
                        
                        let cancel = UIAlertAction(title: "OK", style: .default) { (action) in
                            print("Cancel")
                        }
                        alert.addAction(cancel)
                        print("hiiiii")
                        UIPasteboard.general.string = phone1!
                        self.present(alert, animated: true, completion: nil)
                    }
                    

                     
                   
                    
                    alertView.addAction(Email)
                    alertView.addAction(phone)
                    alertView.addAction(cancel)
                    
                    self.present(alertView, animated: true, completion: nil)
            
        }

    }
    
    
}
