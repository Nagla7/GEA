//
//  AddVenuesController.swift
//  GEA
//
//  Created by Wejdan Aziz on 13/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class AddVenuesController: UIViewController, UITextFieldDelegate {
  
    

   
    @IBOutlet weak var VenueName: HoshiTextField!
    @IBOutlet weak var Cost: HoshiTextField!
    @IBOutlet weak var capacity: HoshiTextField!
    @IBOutlet weak var contactInfo: HoshiTextField!
    @IBOutlet weak var website: HoshiTextField!
    @IBOutlet weak var ownerInfo: HoshiTextField!
    @IBOutlet weak var location: HoshiTextField!
    
    
    var ref : DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        VenueName.delegate = self
        Cost.delegate = self
        capacity.delegate = self
        contactInfo.delegate = self
        website.delegate = self
        ownerInfo.delegate = self
        location.delegate = self
        
         ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addVenueaction(_ sender: Any) {
        var flag =  Bool()
       flag = self.VenueName.text == "" || self.Cost.text! == "" || self.capacity.text! == "" || self.contactInfo.text! == "" || self.website.text! == "" || self.ownerInfo.text! == ""
        
       if flag {
            print("************")
            let alertController = UIAlertController(title: "Error", message: "All fields are required. Please enter all the informations.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)}
        
        else {
       ref.child("Venues").childByAutoId().setValue(["VenueName": self.VenueName.text! , "Cost": self.Cost.text! , "Capacity": self.capacity.text! , "ContactInfo": self.contactInfo.text! , "website": self.website.text! , "OwnerInfo": self.ownerInfo.text! , "Location": self.location.text!])
        
        
        }}
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == VenueName)
        {
            let name_reg = "[A-Za-z]{1,30}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: VenueName.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "Venue name can contain letters only.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if (textField == website)
        {
            let name_reg = "[A-Z0-9a-z._%+-]+.[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: website.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "Enter the website in correct format. e.g. example.domain.com ", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    
    }
   
 

}
