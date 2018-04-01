//
//  File.swift
//  GEA
//
//  Created by rano2 on 04/03/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import Foundation
import Firebase
protocol RegulationDelegate:class{
    func receiveRegulation(data:[NSDictionary])
}
protocol VenuesDelegate:class {
    func receiveVenues(data:[NSDictionary])
}

protocol ReportsDelegate:class {
    func receiveReports(data:[NSDictionary])
}

protocol AccountsDelegate:class {
    func recieveCustomer(data:[NSDictionary],keys:[String])
    func receivedGea(data:[NSDictionary],keys:[String])
   // func receivedNotApproveSP(data:[NSDictionary],keys:[String])
   // func receivedApproveSP(data:[NSDictionary],keys:[String])
}
class Model{
    var ref : DatabaseReference!
    var dbHandle:DatabaseHandle?
     var delegate: RegulationDelegate?
    var Vdelegate:VenuesDelegate?
    var accountDelegate:AccountsDelegate?
    var Rdelegate : ReportsDelegate?
    /////////////conection for regulation//////////
    func getRegulation(){
        ref=Database.database().reference()
        var Regulations=[NSDictionary]()
        dbHandle = ref?.child("Regulations").observe(.value, with: { (snapshot) in
            if let deta=snapshot.value as? [String:Any]{
            print(deta)
            for (_,value) in deta{
                let Regulation=value as! NSDictionary
                Regulations.append(Regulation)
            }
                self.delegate?.receiveRegulation(data:Regulations)}
            else{
                self.delegate?.receiveRegulation(data:[NSDictionary]())
            }
            
        })
    }
    
    func getReports(){
         ref=Database.database().reference()
        var Reports=[NSDictionary]()
        dbHandle = ref?.child("ReportedReviews").observe(.value, with: { (snapshot) in
            if let deta=snapshot.value as? [String:Any]{
                print(deta)
                for (_,value) in deta{
                    let Report=value as! NSDictionary
                    Reports.append(Report)
                }
                self.Rdelegate?.receiveReports(data:Reports)}
            else{
                self.Rdelegate?.receiveReports(data:[NSDictionary]())
            }
        
        })
        
    }
    ///////////Connection for venues////////////////
    func getVenue(){
        ref=Database.database().reference()
        var venues=[NSDictionary]()
        dbHandle = ref?.child("Venues").observe(.value, with: { (snapshot) in
            if let data=snapshot.value as? [String:Any] {
                
                for(_,value) in data{
                    let venue = value as! NSDictionary
                    var i = -1
                    for v in venues {
                        i = i+1
                        if venue["VID"] as! String == v["VID"] as! String{
                            print("----------ignore--------------")
                            venues.remove(at: i)
                        }
                    }
                    venues.append(venue)
                }
                self.Vdelegate?.receiveVenues(data:venues)
            }else{self.Vdelegate?.receiveVenues(data:[NSDictionary]())}
        })
    }
    //////Conection For Cutomers/////
    func getCustomer(){
        var Customers=[NSDictionary]()
        var keys2=[String]()
        dbHandle = ref?.child("Customers").observe(.value, with: { (snapshot) in
            if let deta=snapshot.value as? [String:Any]{
                for (key,value) in deta{
                    let customer=value as! NSDictionary
                    Customers.append(customer)
                    keys2.append(key)
                }
                self.accountDelegate?.recieveCustomer(data:Customers, keys:keys2)
            } else {
                self.accountDelegate?.recieveCustomer(data:[NSDictionary](), keys:[String]())
            }
        })
    }
    ////////////////Get GEA///////////////
    func getGEA(){
        var type = ""
        var Gea=[NSDictionary]()
        var keys1=[String]()
        ref=Database.database().reference()
        dbHandle = ref?.child("Users").observe(.value, with: { (snapshot) in
            if let deta=snapshot.value as? [String:Any]{
                for (key,value) in deta{
                    let gea=value as! NSDictionary
                    type = gea["type"] as! String
                    if (type == "gea"){
                        Gea.append(gea)
                        keys1.append(key)
                    }
                    self.accountDelegate?.receivedGea(data:Gea, keys:keys1)
                }
            } else {self.accountDelegate?.receivedGea(data:[NSDictionary](), keys:[String]())}
        })
    }
    
}
