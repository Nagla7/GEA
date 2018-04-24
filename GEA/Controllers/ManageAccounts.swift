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
    
    @IBOutlet weak var CR: UILabel!
    @IBOutlet weak var PN: UILabel!
    @IBOutlet weak var E: UILabel!
    @IBOutlet weak var Cn: UILabel!
    
    @IBOutlet weak var Un: UILabel!
    @IBOutlet weak var N: UILabel!
    @IBOutlet weak var declinesp: UIButton!
    @IBOutlet weak var approvsp: UIButton!
    @IBOutlet weak var ApproveS: UIView!
    @IBOutlet weak var AS: UIView!
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
    let sections=["To be approved","Service Providers Accounts"] 
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
        AS.layer.shadowColor = UIColor.black.cgColor
       AS.layer.shadowOpacity = 0.5
       AS.layer.shadowOffset = CGSize(width: -2, height: 2)
        AS.layer.shadowRadius = 1
         AS.layer.cornerRadius = 20
        
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
        tableOne.allowsSelection = false
        tableTwo.allowsSelection = false
        approvsp.isHidden = true
        declinesp.isHidden = true
        
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
            print(indexPath.section,"heere")
            if(indexPath.section == 0){
           approvsp.tag = indexPath.row
           approvsp.addTarget(self, action: #selector(approve), for: .touchUpInside)
            
            declinesp.tag = indexPath.row
            declinesp.addTarget(self, action: #selector(disapprove), for: .touchUpInside)  }
        }
        
        return cell
    }
    
    
    @IBAction func closeSup(_ sender: Any) {
        ApproveS.removeFromSuperview()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if(tableView == tableThree){
           view.addSubview(ApproveS)
           ApproveS.center = self.view.center
            if(indexPath.section == 0){
                approvsp.isHidden = false
                declinesp.isHidden = false
              
            }
            else{
                approvsp.isHidden = true
                declinesp.isHidden = true
            }
            Un.text = Service[indexPath.section][indexPath.row]?["username"] as? String
            Cn.text = Service[indexPath.section][indexPath.row]?["companyname"] as? String
            N.text = Service[indexPath.section][indexPath.row]?["username"] as? String
            E.text = Service[indexPath.section][indexPath.row]?["email"] as? String
            CR.text = Service[indexPath.section][indexPath.row]?["commercialrecordnumber"] as? String
            PN.text = Service[indexPath.section][indexPath.row]?["phonenumber"] as? String
            }
            
        
        else{
           tableView.allowsSelection = false
        }
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
        if(self.SegmentedControlindex == 2 && indexPath.section == 0){
            print("no")
            return[]
        }
        else{
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
            if (self.SegmentedControlindex == 2 && indexPath.section == 1 ){
                self.ApprovedService.remove(at: indexPath.row)
                self.ref?.child("ServiceProviders").child(self.keys4[indexPath.row]).removeValue()
                self.keys4.remove(at: indexPath.row)
                self.ApprovedService = [NSDictionary?]()
                self.tableThree.reloadData()}
        })
        return [delete]
        }
        
    }
    
    // ================== POP UP MESSAGE ======================
    func popUpMessage(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    @objc func disapprove(_ sender: UIButton) {
        let alert = UIAlertController(title: "Warning" , message: "Are you sure you want to disapprove this user?", preferredStyle: .alert)
        
        
        let Delete = UIAlertAction(title: "Disapprove", style: .destructive) { (action) in
            self.notApprovedService.remove(at: sender.tag)
            self.ref?.child("ApprovalRequests").child(self.keys3[sender.tag]).removeValue()
            self.keys3.remove(at: sender.tag)
            self.popUpMessage(title: "Success", message: "Service provider account has been disapproved.")
            // should send email
            self.notApprovedService = [NSDictionary?]()
            self.Service = [[NSDictionary?](),[NSDictionary?]()]
            self.tableThree.reloadData()
            self.ApproveS.removeFromSuperview()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("Cancel")
        }
        
        alert.addAction(Delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
        
        print("no")
        
        
    }
    
    @objc func approve(_ sender: UIButton) {
        let alert = UIAlertController(title: "Warning" , message: "Are you sure you want to approve this user?", preferredStyle: .alert)
        
        
        let Delete = UIAlertAction(title: "Approve", style: .default) { (action) in
            
            self.ref.child("ApprovalRequests").child(self.keys3[sender.tag]).observeSingleEvent(of: .value, with: { (snapshot) in
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
                        
                        self.notApprovedService.remove(at: sender.tag)
                        self.ref?.child("ApprovalRequests").child(self.keys3[sender.tag]).removeValue()
                        self.keys3.remove(at: sender.tag)
                        self.popUpMessage(title: "Success", message: "Service provider account has been approved.")
                        self.notApprovedService = [NSDictionary?]()
                        self.ApprovedService = [NSDictionary?]()
                        self.Service = [[NSDictionary?](),[NSDictionary?]()]
                        self.tableThree.reloadData()
                        // should send email
                    } else {self.popUpMessage(title: "Error", message: (error?.localizedDescription)!)}
                }  })
            self.ApproveS.removeFromSuperview()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("Cancel")
        }
        
        alert.addAction(Delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
        
        print("no")
    }

        
        
        

    
}
