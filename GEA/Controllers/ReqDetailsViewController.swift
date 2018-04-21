//
//  ReqDetailsViewController.swift
//  GEA
//
//  Created by Wejdan Aziz on 15/04/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ReqDetailsViewController: UIViewController {
    @IBOutlet weak var approve: UIButton!
    @IBOutlet weak var decline: UIButton!
    @IBOutlet weak var LocTitle: UILabel!
    @IBOutlet weak var NumTicketLable: UILabel!
    var flag = Bool()
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var Audience: UILabel!
    @IBOutlet weak var TP: UILabel!
    @IBOutlet weak var ServiceProvider: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var locationCapacity: UILabel!
    @IBOutlet weak var attendance: UILabel!
    @IBOutlet weak var Rules: UITextView!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Earning: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var Discription: UITextView!
    @IBOutlet weak var TPLable: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var NumTicket: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    var ref = Database.database().reference()
    var req = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.isScrollEnabled = true
        scroll.contentSize = CGSize(width: 375, height: 2100)
       
        ref.child("ServiceProviders").queryOrdered(byChild: "UID").queryEqual(toValue: req["SPID"] as! String).observeSingleEvent(of: .value , with: { snapshot in
            if snapshot.exists() {
                //getting the email to login
                
                let data = snapshot.value as! [String: Any]
                for (_,value) in data {
                     var cn = "df"
                    let user = value as? NSDictionary
                   cn = user!["companyname"] as! String
                    self.ServiceProvider.text =  cn
                }
            }})
                
        
        Name.text = req["EventName"] as? String
        Audience.text =  req["audience"] as? String
      
     
        category.text =  req["category"] as? String
        locationCapacity.text =  req["LocationCapacity"] as? String
        attendance.text =  req["ExpectedAttendees"] as? String
        Time.text =  "\(req["OpenTime"]!) - \(req["CloseTime"]!)"
        Date.text =  "\(req["SDate"]!) - \(req["EDate"]!)"
        Earning.text =  req["Earnings"] as? String
        cost.text =  req["Cost"] as? String
        city.text =  req["City"] as? String
        LocTitle.text = req["locTitle"] as? String
        if(req["NumOfTickets"] as! String == "0"){
            NumTicketLable.text = "Ticket"
        NumTicket.text = "Free"
          TPLable.isHidden = true
        }

        else{
            NumTicket.text =  req["NumOfTickets"] as? String
            TP.text =  req["TicketPrice"] as? String
        }
        Discription.text =  req["EventDiscription"] as! String
        Rules.text = req["EventRules"] as! String
        
        if (flag){
             scroll.contentSize = CGSize(width: 375, height: 2000)
            approve.isHidden = true
            decline.isHidden = true
        }
        
        if req["pic"] != nil{
            img.sd_setImage(with:URL(string:req["pic"] as! String), completed:nil)
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DeclineAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Warning" , message: "Are you sure you want to decline this request?", preferredStyle: .alert)
        
        
        let Delete = UIAlertAction(title: "Decline", style: .destructive) { (action) in
            let rid = self.req["ID"] as! String
            print(rid,"heeereee")
            self.ref.child("IssuedEventsRequests").child(rid).updateChildValues(["status" : "Declined"])
            let SP = UIStoryboard(name: "Main" , bundle: nil)
            let RInfo = SP.instantiateViewController(withIdentifier: "LRs") as! LisenceRequests
            RInfo.Drequests.removeAll()
            RInfo.index = 2
            
            self.navigationController?.pushViewController(RInfo, animated: true)
            
           
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("Cancel")
        }
        
        alert.addAction(Delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
        
            print("no")
        
    }
    
    @IBAction func ApproveAction(_ sender: Any) {
        var ref = Database.database().reference()
        let randomid = ref.childByAutoId().key
        let alert = UIAlertController(title: "Warning" , message: "Are you sure you want to Approve this request?", preferredStyle: .alert)
        
        
        let approve = UIAlertAction(title: "Approve", style: .default) { (action) in
           
            print("yes")
            let rid = self.req["ID"] as! String
            print(rid,"heeereee")
            let v:String
            if self.req["pic"] == nil{
              
                 v=""
            }else{v=self.req["pic"] as! String}
              self.ref.child("IssuedEventsRequests").child(rid).updateChildValues(["status" : "Approved"])
            ref.child("Events").child(randomid).setValue(["title" :"\( self.Name.text!)","Category":"\( self.category.text!)","City": "\(self.city.text!)","Description": "\(self.Discription.text!)","ID":randomid ,"Date" :"\( self.Date.text!)","EDate": "\( self.req["EDate"] as! String)","Firstcoordinate": self.req["Firstcoordinate"],"SDate": self.req["SDate"] ,"SPID": self.req["SPID"],
                "Target Audience" : self.Audience.text!,"TicketPrice" : self.req["TicketPrice"],"Time" : self.Time.text!, "locTitle" : self.LocTitle.text! ,
                "pic" : v,"secondcoordinate" : self.req["secondcoordinate"] , "RemainingTickets" : self.req["NumOfTickets"] , "NumOfTickets": self.req["NumOfTickets"]])
            
        /*    self.ref.child("Events").child(randomid).setValue(["Category": self.category!.text  , "City": self.city!.text, "Date": self.Date!.text , "Description": self.Discription!.text , "EDate": self.req["EDate"]! as? String , "Firstcoordinate": self.req["Firstcoordinate"]! as? String  , "ID": randomid , "NumOfTickets" : self.req!["NumOfTickets"] as! String  , "RemainingTickets": self.req["NumOfTickets"]! as? String  ,"SDate": self.req["SDate"]! as? String   ,"SPID" : self.req!["SPID"] as! String  , "Target Audience" : self.Audience!.text , "TicketPrice" : self.req["TicketPrice"]! as? String  , "Time" : self.Time!.text, "locTitle" : self.LocTitle!.text , "pic" : self.req["pic"]! as? String , "secondcoordinate" : self.req["secondcoordinate"]! as? String  , "title" : self.Name!.text])*/
            
            let SP = UIStoryboard(name: "Main" , bundle: nil)
            let RInfo = SP.instantiateViewController(withIdentifier: "LRs") as! LisenceRequests
            RInfo.Arequests.removeAll()
            RInfo.index = 1
            self.navigationController?.pushViewController(RInfo, animated: true)
            
            
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("Cancel")
        }
        
        alert.addAction(approve)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
