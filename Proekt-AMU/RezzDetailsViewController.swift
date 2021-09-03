//
//  RezzDetailsViewController.swift
//  Proekt-AMU
//
//  Created by Angela Tasikj on 8/26/21.
//  Copyright © 2021 Angela Tasikj. All rights reserved.
//

import UIKit
import Parse

class RezzDetailsViewController: UIViewController {

   
    var dataReq = NSDate()
    var DoctorId = String()
    var bolest = String()
    var status = String()
    var dateFinished = NSDate()
    //var imageFile = [PFFileObject]()
    var DatumPonuda = NSDate()
    var VakcinaPonuda = String()
    var ZakazanoNa = NSDate()
    
    
    @IBOutlet weak var VakcinaP: UILabel!
    
    @IBOutlet weak var DatumBaranje: UILabel!
    //@IBOutlet weak var VakcinaP: UILabel!
    
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var ImePrezime: UILabel!
    @IBOutlet weak var Email: UILabel!
    
    @IBOutlet weak var DatumP: UILabel!
    
    @IBOutlet weak var Datum: UILabel!
    
    
    
    @IBOutlet weak var DatumZakazano: UILabel!
    
    @IBOutlet weak var Vakcina: UILabel!
    
    @IBOutlet weak var Zakazano: UILabel!
    @IBOutlet weak var Phone: UILabel!
    
    @IBOutlet weak var Odbij: UIButton!
    @IBOutlet weak var Prifati: UIButton!
    
    var datumi = [NSDate]()
    var MajstoriIds = [String]()
    var statuses = [String]()
    var descriptions = [String]()

    
    @IBAction func Accept(_ sender: Any) {
        let query = PFQuery(className: "Rezz")
        query.whereKey("from", equalTo: PFUser.current()?.objectId)
        query.whereKey("to", equalTo: DoctorId)
       // query.whereKey("description", equalTo: bolest)
        query.whereKey("date", equalTo: dataReq)
        query.whereKey("vakcina", equalTo: VakcinaPonuda)
        query.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else if let obj = objects {
                for o in obj {
                    o["status"] = "scheduled"
                    o.saveInBackground()
                    self.displayAlert(title: "Success" , message: "Scheduled!")
                }
            }
        })
    }
    @IBAction func Reject(_ sender: Any) {
        
        let query = PFQuery(className: "Rezz")
        query.whereKey("from", equalTo: PFUser.current()?.objectId)
        query.whereKey("to", equalTo: DoctorId)
       // query.whereKey("description", equalTo: bolest)
        query.whereKey("date", equalTo: dataReq)
        query.whereKey("vakcina", equalTo: VakcinaPonuda)
        query.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else if let obj = objects {
                for o in obj {
                    o["status"] = "scheduled"
                    o.deleteInBackground()
                }
            }
        })
        if status == "active"{
            displayAlert(title: "Succes", message: "The request has been canceled")
        }else {
            displayAlert(title: "Succes", message: "The request has been rejected")
        }
    }
    
    
    func displayAlert(title: String, message: String){
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        allertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(allertController,animated: true,completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //OpisDefekt.text = opis
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy HH:mm"
        let stringDate = dateformatter.string(from: dataReq as Date)
        DatumBaranje.text = stringDate
        Status.text = status
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: DoctorId)
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else if let object = objects{
                for o in object {
                    if let doctor = o as? PFUser {
                        if let firsLastName = doctor["firstLastName"] {
                            
                                if let phoneNumber = doctor["phoneNumber"]{
                                    if let email = doctor.username {
                                                                                    self.ImePrezime.text = (firsLastName as! String)
                                        
                                         self.Email.text = email
                                         self.Phone.text = (phoneNumber as! String)
                                        }
                                        
                                    }
                        }
                    }
                }
            }
        })
        
        if status == "active" { //aktivno baranje
            
            DatumZakazano.isHidden = true
            Zakazano.isHidden = true
            Vakcina.isHidden = true
            VakcinaP.isHidden = true
            Datum.isHidden = true
            DatumP.isHidden = true
           // Image.isHidden = true
            Prifati.isHidden = true
            Odbij.setTitle("CANCEL", for: .normal)
            Odbij.isHidden = false
        }else if status == "pending" { //dobiena ponuda
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let StringDate = dateFormatter.string(from: DatumPonuda as Date)
            DatumP.text = StringDate
            VakcinaP.text = VakcinaPonuda
            Datum.isHidden = false
            Vakcina.isHidden = false
            VakcinaP.isHidden = false
            DatumP.isHidden = false
            Prifati.isHidden = false
            Odbij.setTitle("REJECT", for: .normal)
            Odbij.isHidden = false
            //Image.isHidden = true
            Zakazano.isHidden = true
            DatumZakazano.isHidden = true
        }else if status == "scheduled" { //zakazana rabota
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let StringDate = dateFormatter.string(from: ZakazanoNa as Date)
            DatumZakazano.text = StringDate
            VakcinaP.text = VakcinaPonuda
            Vakcina.isHidden = false
            VakcinaP.isHidden = false
            DatumP.isHidden = true
            Datum.isHidden = true
            DatumZakazano.isHidden = false
            Zakazano.isHidden = false
            Zakazano.text = "Scheduled on:"
           // Image.isHidden = true
            Prifati.isHidden = true
            Odbij.isHidden = true
        }else if status == "done" { //zavrsena rabota
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let StringDate = dateFormatter.string(from: dateFinished as Date)
            DatumZakazano.text = StringDate
            //let slika = imageFile[0]
            /*
            slika.getDataInBackground { (data, error) in
                if let imageData = data {
                    if let imageToDisplay = UIImage(data: imageData){
                        self.Image.image = imageToDisplay
                    }
                }
            }
            imageFile.removeAll()
 */
            Vakcina.isHidden = true
            VakcinaP.isHidden = true
            DatumP.isHidden = true
            Datum.isHidden = true
            Zakazano.text = "Finished on: "
            DatumZakazano.isHidden = false
            Zakazano.isHidden = false
            //Image.isHidden = false
            Prifati.isHidden = true
            Odbij.isHidden = true
        }
        
    }
    
}
