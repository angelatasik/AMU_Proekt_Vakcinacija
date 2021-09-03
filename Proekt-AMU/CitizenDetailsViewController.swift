//
//  CitizenDetailsViewController.swift
//  Proekt-AMU
//
//  Created by Angela Tasikj on 8/23/21.
//  Copyright © 2021 Angela Tasikj. All rights reserved.
//

import UIKit
import MapKit
import Parse

class CitizenDetailsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
  
     @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var Phone: UILabel!
    @IBOutlet weak var Mapa: MKMapView!
    @IBOutlet weak var Bolest: UILabel!
    @IBOutlet weak var NameSurname: UILabel!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var Vakcina: UILabel!
    @IBOutlet weak var Datum: UILabel!
 
    
    
    var ImePrezime = String()
    var datum = NSDate()
    var bolest = String()
    var lokacija = String()
    var tel = String()
    var email = String()
    var lon = Double()
    var lat = Double()
    var vakcina = String()
    
    
    @IBAction func Reject(_ sender: Any) {
        let query = PFUser.query()
        query?.whereKey("firstLastName", equalTo: ImePrezime)
        query?.whereKey("phoneNumber", equalTo: tel)
        query?.whereKey("username", equalTo: email)
        query?.findObjectsInBackground(block: { (users, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else if let user = users{
                for u in user {
                    if let userId = u.objectId{
                        let Query = PFQuery(className: "Rezz")
                        Query.whereKey("from", equalTo: userId)
                        Query.whereKey("to", equalTo: PFUser.current()?.objectId)
                        Query.whereKey("description", equalTo: self.bolest)
                        Query.whereKey("date", equalTo: self.datum)
                        Query.whereKey("location", equalTo: self.lokacija)
                       // Query.whereKey("Vakcina", equalTo: self.vakcina)
                       
                        Query.findObjectsInBackground(block: { (objects, error) in
                            if error != nil {
                                print(error?.localizedDescription)
                            }else if let object = objects {
                                for obj in object {
                                    obj.deleteInBackground()
                                }
                            }
                        })
                    }
                }
            }
        })
        displayAlert(title: "Uspesno", message: "You reject request")
    }
    
    
    @IBAction func MakeRez(_ sender: Any) {
     //   vakcina = Vakcina.text as! String
       
            let DATA = DatePicker.date
           // let VAKCINA = Vakcina.text
            let query = PFUser.query()
            query?.whereKey("firstLastName", equalTo: ImePrezime)
            query?.whereKey("phoneNumber", equalTo: tel)
            query?.whereKey("username", equalTo: email)
            query?.findObjectsInBackground(block: { (users, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }else if let user = users{
                    for u in user {
                        if let userId = u.objectId{
                            let Query = PFQuery(className: "Rezz")
                            Query.whereKey("from", equalTo: userId)
                            Query.whereKey("to", equalTo: PFUser.current()?.objectId)
                            Query.whereKey("description", equalTo: self.bolest)
                            Query.whereKey("date", equalTo: self.datum)
                            Query.whereKey("location", equalTo: self.lokacija)
                           // Query.whereKey("Vakcina", equalTo: self.vakcina)
                            //print("proveri za vakcinata vo citizen info cont")
                            Query.findObjectsInBackground(block: { (objects, error) in
                                if error != nil {
                                    print(error?.localizedDescription)
                                }else if let object = objects {
                                    for obj in object {
                                        obj["status"] = "pending"
                                        obj["DateTime"] = DATA
                                        print("stava data")
                                        obj["vakcina"] = self.vakcina
                                        print("stava vakcina: 'vakcina'")
                                        obj.saveInBackground()
                                    }
                                }
                            })
                        }
                    }
                }
            })
            displayAlert(title: "Succesful!", message: "You make an reservation")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Bolest.text = bolest
         print("vo details kont vnesena bolest")
        Email.text = email
        Phone.text = tel
        NameSurname.text = ImePrezime
        Vakcina.text = vakcina
        print("vnesena vakcina .viewDidload")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let stringDate = dateFormatter.string(from: datum as! Date)
        Datum.text = stringDate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: coord, span: span)
        self.Mapa.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = lokacija
        self.Mapa.addAnnotation(annotation)
    }
       
    
    func displayAlert(title: String, message: String) {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertC,animated: true,completion: nil)
    }
}
