//
//  ReportedCommentsController.swift
//  
//
//  Created by njoool  on 30/03/2018.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ReportedCommentsController: UIViewController, UITableViewDelegate, UITableViewDataSource , ReportsDelegate{
  
    
    @IBOutlet weak var tableView: UITableView!
    var ref : DatabaseReference!
    var dbHandle:DatabaseHandle?
    var model=Model()
    var Reports=[NSDictionary]()
    var ReviewAtIndex : NSDictionary!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Blure.isHidden = true
        ref=Database.database().reference()
        tableView.delegate=self
        tableView.dataSource=self
        model.Rdelegate = self as? ReportsDelegate
        model.getReports()
        
    }
    func receiveReports(data: [NSDictionary]) {
        if data.count != 0{
            self.Reports=data
            self.tableView.reloadData()}
          
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Reports.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Vcell", for: indexPath) as! ReportsTableViewCell
        let Report : NSDictionary?
        cell.DeleteBtn.tag = indexPath.row
        cell.DeleteBtn.addTarget(self, action: #selector(deleteReview), for: .touchUpInside)
        
        cell.DismissBtn.tag = indexPath.row
        cell.DismissBtn.addTarget(self, action: #selector(DismissReport), for: .touchUpInside)
        
       Report = Reports[indexPath.row]
        
        cell.ReportedUser.text = Report!["ReportedUser"] as? String
        cell.Review.text = Report!["Review"] as? String
        cell.reason.text = Report!["Reason"] as? String
        
        return(cell)
    }
    
    @objc func deleteReview(_ sender: UIButton?) {
        
       
          self.ReviewAtIndex = Reports[(sender?.tag)!]
        let EID = self.ReviewAtIndex["EventID"] as! String
        let Rid = self.ReviewAtIndex["ReviewId"] as! String
        ref.child("ReportedReviews").child(self.ReviewAtIndex["ReportID"] as! String).removeValue()
        ref.child("Reviews").child(EID).child(Rid).removeValue()
   
       self.Reports.remove(at: (sender?.tag)!)
        model.getReports()
        tableView.reloadData()
    }

    @objc func DismissReport(_ sender:  UIButton?) {
        self.ReviewAtIndex = Reports[(sender?.tag)!]
        ref.child("ReportedReviews").child(self.ReviewAtIndex["ReportID"] as! String).removeValue()
        self.Reports.remove(at: (sender?.tag)!)
        model.getReports()
        tableView.reloadData()
    }
    
}


