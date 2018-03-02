//
//  VenueInfoViewController.swift
//  GEA
//
//  Created by Wejdan Aziz on 16/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class VenueInfoViewController: UIViewController {
    var Vname = String()
    var venue : NSDictionary?
    
    @IBOutlet weak var costL: UILabel!
    @IBOutlet weak var contactL: UILabel!
    @IBOutlet weak var ownerL: UILabel!
    @IBOutlet weak var capacityL: UILabel!
    @IBOutlet weak var  WebsiteL: UILabel!
    @IBOutlet weak var vNameLable: UILabel!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        vNameLable.text = Vname 
        costL.text = venue!["Cost"] as! String
        ownerL.text = venue!["OwnerInfo"] as! String
        capacityL.text = venue!["Capacity"] as! String
        WebsiteL.text = venue!["website"] as! String
        contactL.text = venue!["ContactInfo"] as! String
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func GoToEditVenue(_ sender: UIButton) {
        performSegue(withIdentifier: "EditVenue", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditVenueViewController{
            destination.venue = venue
        }
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

