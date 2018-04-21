//
//  ReportedCommentsC/Users/wejdan/Documents/GEA/GEA/Controllers/ReportedCommentsController.swiftontroller.swift
//  
//
//  Created by njoool  on 30/03/2018.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ReportedCommentsController: UIViewController, UITableViewDelegate, UITableViewDataSource , ReportsDelegate{
  
    @IBOutlet var noCommentview: UIView!
    
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
        if (Reports.count == 0){
             self.view.addSubview(noCommentview)
        }
        else{
            noCommentview.removeFromSuperview()
        }
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
        
        cell.block.tag = indexPath.row
        cell.block.addTarget(self, action: #selector(BlockUserAction), for: .touchUpInside)
        
       Report = Reports[indexPath.row]
        
        cell.ReportedUser.text = Report!["ReportedUser"] as? String
        cell.Review.text = Report!["Review"] as? String
        cell.reason.text = Report!["Reason"] as? String
        
        return(cell)
    }
    
    @objc func deleteReview(_ sender: UIButton?) {
        
        deleteR(index: (sender?.tag)!)
        
    }
    func deleteR(index: Int) {
        
        self.ReviewAtIndex = Reports[index]
        let EID = self.ReviewAtIndex["EventID"] as! String
        let Rid = self.ReviewAtIndex["ReviewId"] as! String
        ref.child("ReportedReviews").child(self.ReviewAtIndex["ReportID"] as! String).removeValue()
        ref.child("Reviews").child(EID).child(Rid).removeValue()
        
        self.Reports.remove(at: index)
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
    
    @objc func BlockUserAction(_ sender: UIButton) {
        self.ReviewAtIndex = Reports[(sender.tag)]
         var id = ""
        ref.child("Customers").queryOrdered(byChild: "username").queryEqual(toValue: self.ReviewAtIndex["ReportedUser"] as! String ).observeSingleEvent(of: .value , with: { snapshot in
            if snapshot.exists() {
                //getting the email to login
            
                let data = snapshot.value as! [String: Any]
                for (_,value) in data {
                    let user = value as? NSDictionary
                    id = user!["UID"] as! String
                    self.ref.child("BlockedUsers").child(id).setValue(["username" : self.ReviewAtIndex["ReportedUser"] as! String])
                    self.deleteR(index: sender.tag)
                }
    
}
        })
}
}


