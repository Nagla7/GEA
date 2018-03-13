//
//  ManageAccounts.swift
//  GEA
//
//  Created by leena hassan on 29/05/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ManageAccounts: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var addGea: UIButton!
    @IBOutlet weak var tableOne: UITableView! // gea
    @IBOutlet weak var tableTwo: UITableView! // customer
    @IBOutlet weak var tableThree: UITableView! // service
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var ref : DatabaseReference!
    var dbHandle:DatabaseHandle?
    var Gea = [NSDictionary?]()
    var Customers = [NSDictionary?]()
    var notApprovedService = [NSDictionary?]()
    var ApprovedService = [NSDictionary?]()
    var Service = [[NSDictionary?](),[NSDictionary?]()]
    var SegmentedControlindex = 0
    let sections=["To be approved","Service Providers Accounts"] // cahnge it please ما لقيت اسم صح
    var keys1 = [String](); //gea keys
    var keys2 = [String](); //customer keys
    var keys3 = [String](); //disapproved service keys
    var keys4 = [String](); //approved service keys
    var firstname = ""
    var lastname = ""
    var email = ""
    var phonenumber = ""
    var username = ""
    var companyname = ""
    var commercialrecordnumber = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //============The configurations of the tables===========
        
        tableOne.delegate = self
        tableTwo.delegate = self
        tableThree.delegate = self
        tableOne.dataSource = self
        tableTwo.dataSource = self
        tableThree.dataSource = self
        tableThree.isHidden=true
        tableTwo.isHidden=true
        //tableOne.backgroundColor=UIColor.darkGray
        let nib = UINib(nibName: "CustomCell",bundle:nil)
        tableOne.register(nib, forCellReuseIdentifier: "CustomCell")
        tableTwo.register(nib, forCellReuseIdentifier: "CustomCell")
        tableThree.register(nib, forCellReuseIdentifier: "CustomCell")
        
        
        //============Fetching data===========
        // 1- GEA
        var type = ""
        ref=Database.database().reference()
        dbHandle = ref?.child("Users").observe(.value, with: { (snapshot) in
            if let deta=snapshot.value as? [String:Any]{
                for (key,value) in deta{
                    let gea=value as! NSDictionary
                    type = gea["type"] as! String
                    if (type == "gea"){
                        self.Gea.append(gea)
                        self.keys1.append(key)
                    }}
                self.tableOne.reloadData()
            } else {print("There are no GEA staff!")}
        })
        
        // 2- Customers
        dbHandle = ref?.child("Customers").observe(.value, with: { (snapshot) in
            if let deta=snapshot.value as? [String:Any]{
                for (key,value) in deta{
                    let customer=value as! NSDictionary
                    self.Customers.append(customer)
                    self.keys2.append(key)
                }
                self.tableTwo.reloadData()
            } else {print("There are no customers!")}
        })
        
        // 3- Service not approved
        dbHandle = ref?.child("ApprovalRequests").observe(.value, with: { (snapshot) in
            if let deta=snapshot.value as? [String:Any]{
                var notApprovedService = [NSDictionary?]()
                for (key,value) in deta{
                    let service=value as! NSDictionary
                    self.notApprovedService.append(service)
                    self.keys3.append(key)
                }
                self.Service  = [self.notApprovedService,self.ApprovedService]
                self.tableThree.reloadData()
            } else {print("There are no requests!")}
        })
        
        // 4- Service approved
        dbHandle = ref?.child("ServiceProviders").observe(.value, with: { (snapshot) in
            if let deta=snapshot.value as? [String:Any]{
                var ApprovedService = [NSDictionary?]()
                for (key,value) in deta{
                    let service=value as! NSDictionary
                    self.ApprovedService.append(service)
                    self.keys4.append(key)
                }
                self.Service  = [self.notApprovedService,self.ApprovedService]
                self.tableThree.reloadData()
            } else {print("There are no service providers!")}
        })
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (SegmentedControlindex == 2)
        {return 2}
        else
        {return 1}
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (SegmentedControlindex == 2){
            return sections[section]}
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (SegmentedControlindex == 0)
        {return Gea.count}
        
        if (SegmentedControlindex == 1)
        {return Customers.count}
            
        else
        {return Service[section].count}
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableOne.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        
        if (SegmentedControlindex == 0)
        {cell.titleLabel.text = Gea[indexPath.row]?["username"] as? String}
        
        if (SegmentedControlindex == 1)
        {cell.titleLabel.text = Customers[indexPath.row]?["username"] as? String}
        
        if (SegmentedControlindex == 2)
        {cell.titleLabel.text = Service[indexPath.section][indexPath.row]?["username"] as? String
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            
        case 0:
            tableThree.isHidden=true
            tableOne.isHidden=false
            tableTwo.isHidden=true
            SegmentedControlindex=0
            addGea.isHidden = false
            tableOne.reloadData()
            
        case 1:
            tableTwo.isHidden=false
            tableOne.isHidden=true
            tableThree.isHidden=true
            SegmentedControlindex=1
            addGea.isHidden = true
            tableTwo.reloadData()
            
        case 2:
            tableThree.isHidden=false
            tableOne.isHidden=true
            tableTwo.isHidden=true
            SegmentedControlindex=2
            addGea.isHidden = true
            tableThree.reloadData()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title:"Delete", handler:{ action , indexPath in
            //============Delete GEA===========
            if (self.SegmentedControlindex == 0){
                self.Gea.remove(at: indexPath.row)
                self.ref?.child("Users").child(self.keys1[indexPath.row]).removeValue()
                self.keys1.remove(at: indexPath.row)
                self.Gea = [NSDictionary?]()
                self.tableOne.reloadData()}
            
            //============Delete Customers===========
            if (self.self.SegmentedControlindex == 1){
                self.Customers.remove(at: indexPath.row)
                self.ref?.child("Customers").child(self.keys2[indexPath.row]).removeValue()
                self.keys2.remove(at: indexPath.row)
                self.Customers = [NSDictionary?]()
                self.tableTwo.reloadData()}
            
            //============Delete Service===========
            if (self.SegmentedControlindex == 2){
                self.ApprovedService.remove(at: indexPath.row)
                self.ref?.child("ServiceProviders").child(self.keys4[indexPath.row]).removeValue()
                self.keys4.remove(at: indexPath.row)
                self.ApprovedService = [NSDictionary?]()
                self.tableThree.reloadData()}
        })
        
        if(tableView == tableThree){
            var section = 0
            if let index = tableView.indexPathsForVisibleRows?.first?.section {
                section = index
            }
            if(indexPath.section == 0){
                
                let approveAction = UITableViewRowAction(style: .default, title:"approve") {(action, indexPath) in
                    self.ref.child("ApprovalRequests").child(self.keys3[indexPath.row]).observeSingleEvent(of: .value, with: { (snapshot) in
                        let snapshot = snapshot.value as! [String: AnyObject]
                        
                        // fetech user details
                        self.firstname = snapshot["firstname"] as! String
                        self.lastname = snapshot["lastname"] as! String
                        self.email = snapshot["email"] as! String
                        self.phonenumber = snapshot["phonenumber"] as! String
                        self.username = snapshot["username"] as! String
                        self.companyname = snapshot["companyname"] as! String
                        self.commercialrecordnumber = snapshot["commercialrecordnumber"] as! String
                        self.password = snapshot["password"] as! String
                        
                        // create new user
                        Auth.auth().createUser(withEmail: self.email, password: self.password) { (user, error) in
                            if error == nil {
                                
                                self.ref.child("ServiceProviders").child(user!.uid).setValue(["firstname":self.firstname,"lastname":self.lastname,"email": self.email,"phonenumber":self.phonenumber,"username": self.username, "companyname":self.companyname, "commercialrecordnumber":self.commercialrecordnumber ,"UID": user!.uid])
                                
                                self.notApprovedService.remove(at: indexPath.row)
                                self.ref?.child("ApprovalRequests").child(self.keys3[indexPath.row]).removeValue()
                                self.keys3.remove(at: indexPath.row)
                                self.popUpMessage(title: "Success", message: "Service provider account has been approved.")
                                self.notApprovedService = [NSDictionary?]()
                                self.ApprovedService = [NSDictionary?]()
                                self.Service = [[NSDictionary?](),[NSDictionary?]()]
                                self.tableThree.reloadData()
                                // should send email
                            } else {self.popUpMessage(title: "Error", message: (error?.localizedDescription)!)}
                        }  })
                }
                
                approveAction.backgroundColor =  UIColor(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                let disapproveAction = UITableViewRowAction(style: .default, title:"disapprove") {(action, indexPath) in
                    print("no")
                    self.notApprovedService.remove(at: indexPath.row)
                    self.ref?.child("ApprovalRequests").child(self.keys3[indexPath.row]).removeValue()
                    self.keys3.remove(at: indexPath.row)
                    self.popUpMessage(title: "Success", message: "Service provider account has been disapproved.")
                    // should send email
                    self.notApprovedService = [NSDictionary?]()
                    self.Service = [[NSDictionary?](),[NSDictionary?]()]
                    self.tableThree.reloadData()}
                
                return [approveAction,disapproveAction]
            }
        }
        
        return [delete]
    }
    
    // ================== POP UP MESSAGE ======================
    func popUpMessage(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
}
