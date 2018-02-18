//
//  EditVenueViewController.swift
//  GEA
//
//  Created by Wejdan Aziz on 16/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase

class EditVenueViewController: UIViewController {
    
   
    @IBOutlet weak var ownerInfo: HoshiTextField!
    @IBOutlet weak var Website: HoshiTextField!
    @IBOutlet weak var capacity: HoshiTextField!
    
    @IBOutlet weak var location: HoshiTextField!
    @IBOutlet weak var contactInfo: HoshiTextField!
    @IBOutlet weak var VName: HoshiTextField!
    @IBOutlet weak var cost: HoshiTextField!
    var ref: DatabaseReference!
    
    var venue : NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        VName.text = venue!["VenueName"] as! String
        cost.text = venue!["Cost"] as? String
        ownerInfo.text = venue!["OwnerInfo"] as! String
        Website.text = venue!["website"] as! String
        contactInfo.text = venue!["ContactInfo"] as! String
        capacity.text = venue!["Capacity"] as! String
        location.text = venue!["Location"] as! String
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func EditVenueAction(_ sender: UIButton) {

        let NewVenue = [
            "VenueName": VName.text
            , "Cost" : cost.text
            ,"OwnerInfo": ownerInfo.text
            , "website" : Website.text
            ,"ContactInfo": contactInfo.text
            ,"Capacity": capacity.text
            ,"Location": location.text
        ]
        
        ref.child("Venues")
        
        
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

