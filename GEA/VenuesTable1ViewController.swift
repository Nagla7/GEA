//
//  VenuesTable1ViewController.swift
//  GEA
//
//  Created by Wejdan Aziz on 14/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class VenuesTable1ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var VenuesTable: UITableView!
    var venues = [NSDictionary]()
    var dbHandle:DatabaseHandle?
    var ref : DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VenuesTable.delegate = self
        VenuesTable.dataSource = self
        ref=Database.database().reference()
        //read from database
        dbHandle = ref?.child("Venues").observe(.value, with: { (snapshot) in
            let data=snapshot.value as! [String:Any]
            
            for(_,value) in data{
                let venue = value as! NSDictionary
                self.venues.append(venue)
            }
            self.VenuesTable.reloadData()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  VenuesTable?.dequeueReusableCell(withIdentifier :"Vcell", for: indexPath) as! VenuesTableViewCell
        let venue : NSDictionary?
        venue = venues[indexPath.row]
        cell.Vname.text = venue?["VenueName"] as? String
        cell.Cost.text = venue?["Cost"] as? String
        return (cell)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SP = UIStoryboard(name: "Main" , bundle: nil)
        let vInfo = SP.instantiateViewController(withIdentifier: "VenueInfoViewController") as! VenueInfoViewController
        let venue : NSDictionary?
        venue = venues[indexPath.row]
        vInfo.Vname = venue?["VenueName"] as! String
        vInfo.venue = venue
        self.navigationController?.pushViewController(vInfo, animated: true)
    }
    
}

