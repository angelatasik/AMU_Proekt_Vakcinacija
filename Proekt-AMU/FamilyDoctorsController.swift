//
//  FamilyDoctorsController.swift
//  Proekt-AMU
//
//  Created by Angela Tasikj on 8/20/21.
//  Copyright © 2021 Angela Tasikj. All rights reserved.
//

import UIKit
import Parse

class FamilyDoctorsController: UITableViewController {

    var ImePrezime = [String]()
    var kliknatMajstor = String()
    var bolest = String()
    var lokacija = String()
    var lon = Double()
    var lat = Double()
    var DoctorId = [String]()
    var index = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ImePrezime.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        DoctorId.removeAll()
        let cell = tableView.dequeueReusableCell(withIdentifier: "kelija", for: indexPath)
        cell.textLabel?.text = ImePrezime[indexPath.row]
        let DefektLokacija = CLLocation(latitude: lat, longitude: lon)
        let firstLastName = ImePrezime[indexPath.row]
                //SET UP OUR QUERY FOR A USER OBJ:
        let DoctorQuery = PFUser.query()
        print("go kreira QUERYTO")
        DoctorQuery?.whereKey("tipKorisnik", equalTo: "Doctor")
        DoctorQuery?.whereKey("firstLastName", equalTo: firstLastName)
        
        //EXECUTE THE QUERY - IZVRSI GO BARANJETO:
        DoctorQuery?.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else if let doktori = objects {
                print("VLAGAA")
                for object in doktori {
                    if let doktor = object as? PFUser {
                        if let objectID = doktor.objectId {
                            print("I TUKA VLAGA")
                            let query = PFQuery(className: "Job")
                            print("VLAGA VO QUERY-TO: JOB")
                            query.whereKey("from", equalTo: PFUser.current()?.objectId)
                            query.whereKey("to", equalTo: objectID)
                            query.whereKey("status", equalTo: "active")
                            print("gi prvoeri i from,to,status")
                            query.findObjectsInBackground(block: { (objects, error) in
                                if error != nil {
                                    print(error?.localizedDescription)
                                } else if let object = objects {
                                    print("vlaga i tuka")
                                    if object.count > 0 {
                                        print("count e > 0")
                                        cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                                        print("go izvrsi ova?")
                                    }
                                }
                            })
                            
                        }
                    }
                    
                }
            }
        })
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        //performSegue(withIdentifier: "MajstoriDetailSeg", sender: nil)
        
    }

}
