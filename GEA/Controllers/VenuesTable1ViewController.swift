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
import SDWebImage

class VenuesTable1ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate,VenuesDelegate  {

    
    
    @IBOutlet weak var Novenues: UILabel!
    @IBOutlet weak var VenuesTable: UITableView!
    var venues = [NSDictionary]()
    var dbHandle:DatabaseHandle?
    var ref : DatabaseReference!
    var model=Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VenuesTable.delegate = self
        VenuesTable.dataSource = self
        ref=Database.database().reference()
        model.Vdelegate=self
        model.getVenue()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        model.Vdelegate=self
        model.getVenue()
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
        cell.view.layer.masksToBounds=true
        cell.view.layer.cornerRadius=10
        if venue!["pic"] != nil{
            cell.img.sd_setImage(with:URL(string:venue!["pic"] as! String), completed:nil)
        }
        return (cell)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SP = UIStoryboard(name: "Main" , bundle: nil)
        let vInfo = SP.instantiateViewController(withIdentifier: "EditVenueViewController") as! EditVenueViewController
        let venue : NSDictionary?
        venue = venues[indexPath.row]
        vInfo.venue = venue
        self.navigationController?.pushViewController(vInfo, animated: true)
    }
    func receiveVenues(data: [NSDictionary]) {
        if data.count != 0{
            self.venues=data
            self.VenuesTable.reloadData()
            self.Novenues.isHidden=true
            self.VenuesTable.isHidden=false
        }else{self.Novenues.isHidden=false
            self.VenuesTable.isHidden=true
        }
    }
}

