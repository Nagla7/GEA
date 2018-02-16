//
//  ManageAccounts.swift
//  GEA
//
//  Created by leena hassan on 29/05/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase

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
    let sections=["To be approved","Rest"] // cahnge it please ما لقيت اسم صح
    


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
            let deta=snapshot.value as! [String:Any]
            for (_,value) in deta{
                let gea=value as! NSDictionary
                type = gea["type"] as! String
                if (type == "gea"){
                    self.Gea.append(gea)}
            }
            self.tableOne.reloadData()})
        
        // 2- Customers
        dbHandle = ref?.child("Customers").observe(.value, with: { (snapshot) in
            let deta=snapshot.value as! [String:Any]
            for (_,value) in deta{
                let customer=value as! NSDictionary
                self.Customers.append(customer)
            }
            self.tableTwo.reloadData()})
        
        // 3- Service not approved
        dbHandle = ref?.child("ApprovalRequests").observe(.value, with: { (snapshot) in
            let deta=snapshot.value as! [String:Any]
            for (_,value) in deta{
                let service=value as! NSDictionary
                self.notApprovedService.append(service)
            }
            self.Service  = [self.notApprovedService,self.ApprovedService]
            self.tableThree.reloadData()})
        
        // 4- Service approved
        dbHandle = ref?.child("ServiceProviders").observe(.value, with: { (snapshot) in
            let deta=snapshot.value as! [String:Any]
            for (_,value) in deta{
                let service=value as! NSDictionary
                self.ApprovedService.append(service)
            }
            self.Service  = [self.notApprovedService,self.ApprovedService]
            self.tableThree.reloadData()})
    

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
        {print(Service[section].count,"!!!!!!!!!!!!!!!!!")
            return Service[section].count}
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableOne.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        
        if (SegmentedControlindex == 0)
        {cell.titleLabel.text = Gea[indexPath.row]?["username"] as? String}
        
        if (SegmentedControlindex == 1)
        {cell.titleLabel.text = Customers[indexPath.row]?["username"] as? String}
        
        if (SegmentedControlindex == 2)
        {cell.titleLabel.text = Service[indexPath.section][indexPath.row]?["username"] as? String
         //   print(Service[indexPath.section][indexPath.row][0],"T%%%%%%%%%%%%%%%%")
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
    func tableView(_ tableView: UITableView,commit editingStyle:UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        //============Delete GEA===========
        if (SegmentedControlindex == 0){
        if editingStyle==UITableViewCellEditingStyle.delete{
            
            tableOne.reloadData()}
        }
        //============Delete Customers===========
        if (SegmentedControlindex == 1){
            if editingStyle==UITableViewCellEditingStyle.delete{
                
                tableOne.reloadData()}
        }
        //============Delete Service===========
        if (SegmentedControlindex == 2){
            if editingStyle==UITableViewCellEditingStyle.delete{
                
                tableOne.reloadData()}
        }
        
        
    }

}
