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
        
        
    }
    func receiveReports(data: [NSDictionary]) {
        if data.count != 0{
            self.Reports=data
            self.tableView.reloadData()
            if (Reports.count == 0){
                print("zeeerooo")
                self.view.addSubview(noCommentview)
            }
            else{
                print("98989")
                noCommentview.removeFromSuperview()
            }
        }
        
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
        let alert = UIAlertController(title: "Warning" , message: "Are you sure you want to delete this review?", preferredStyle: .alert)
        
        
        let Delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteR(index: (sender?.tag)!)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("Cancel")
        }
        
        alert.addAction(Delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
        
        print("no")
        
        
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
        let alert = UIAlertController(title: "Warning" , message: "Are you sure you want to dismiss this report?", preferredStyle: .alert)
        
        
        let Delete = UIAlertAction(title: "Dismiss", style: .destructive) { (action) in
            self.ReviewAtIndex = self.Reports[(sender?.tag)!]
            self.ref.child("ReportedReviews").child(self.ReviewAtIndex["ReportID"] as! String).removeValue()
            self.Reports.remove(at: (sender?.tag)!)
            self.model.getReports()
            self.tableView.reloadData()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("Cancel")
        }
        
        alert.addAction(Delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
        
        print("no")
        
    }
    
    @objc func BlockUserAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Warning" , message: "Are you sure you want to block this user?", preferredStyle: .alert)
        
        
        let Delete = UIAlertAction(title: "Block", style: .destructive) { (action) in
            self.ReviewAtIndex = self.Reports[(sender.tag)]
            var id = ""
            self.ref.child("Customers").queryOrdered(byChild: "username").queryEqual(toValue: self.ReviewAtIndex["ReportedUser"] as! String ).observeSingleEvent(of: .value , with: { snapshot in
                if snapshot.exists() {
                    //getting the email to login
                    
                    let data = snapshot.value as! [String: Any]
                    for (_,value) in data {
                        let user = value as? NSDictionary
                        id = user!["UID"] as! String
                        self.ref.child("Customers").child(id).child("blocked").setValue("true")
                        self.deleteR(index: sender.tag)
                    }
                    
                }
            })
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("Cancel")
        }
        
        alert.addAction(Delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
        
        print("no")
        
        //----------
        
    }
}


