//
//  DetailViewController.swift
//  Proekt-AMU
//
//  Created by Angela Tasikj on 8/28/21.
//  Copyright © 2021 Angela Tasikj. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var Korisnik: UILabel!
    @IBOutlet weak var Phone: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var FinishDate: UILabel!
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var Vaccine: UILabel!
    @IBOutlet weak var DateFinish: UILabel!
    @IBOutlet weak var Data: UILabel!
    var datum = NSDate()
    var status = String()
    var ImePrezime = String()
    //var Prezime = String()
    //var imageFile = [PFFileObject]()
    var phone = String()
    var email = String()
    var vakcina = String()
    var lat = Double()
    var long = Double()
    var adresa = String()
    var rezzId = String()
    var datePicker = NSDate()
    var DatumZavrsuvanje = NSDate()
    
 
    @IBOutlet weak var DatePicker: UIDatePicker!

    
    func displayAlert(title: String, message: String) {
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        allertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(allertController, animated: true, completion: nil)
    }
    
    override func prepare(for seg: UIStoryboardSegue, sender: Any?) {
        if seg.identifier == "ToMapSeg" {
            let dVC = seg.destination as! MapViewController
            dVC.lat = lat
            dVC.long = long
            dVC.lokacija = adresa
        }
    }
    
    
    @IBAction func SavePressed(_ sender: Any) {
        
            let query = PFQuery(className: "Rezz")
            query.whereKey("objectId", equalTo: rezzId)
            query.findObjectsInBackground { (objects,error) in
                if error != nil {
                    print(error?.localizedDescription)
                }else if let object = objects{
                    for obj in object {
                        obj["finishDate"] = self.datePicker
                        obj["status"] = "done"
                        /*
                        if let image = self.Image.image {
                            if let imageData = image.jpeg(.medium) {
                                let imageFile = PFFileObject(name: "image.jpeg", data: imageData)
                                obj["imageFile"] = imageFile
                                obj.saveInBackground()
                            }
                        }
 */
                    }
                }
                
            }
            displayAlert(title: "Succesfull", message: "Finished!")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Korisnik.text = ImePrezime
        Status.text = status
        Phone.text = phone
        Email.text = email
        Vaccine.text = vakcina
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let StringDate = formatter.string(from: datum as Date)
        Data.text = StringDate
        let stringFDate = formatter.string(from: DatumZavrsuvanje as Date)
       // Adresa.text = adresa
        if status == "scheduled" {
            FinishDate.isHidden = true
            DateFinish.isHidden = true
           // Camera.isHidden = false
            //Or.isHidden = false
         //   PhotoLibrary.isHidden = false
            //SaveImage.isHidden = false
            DatePicker.datePickerMode = .date
            DatePicker.isHidden = false
            datePicker = DatePicker.date as NSDate
           // VnesiSlika.isHidden = false
        }else{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            let StringDate = formatter.string(from: datum as Date)
            FinishDate.text = StringDate
            FinishDate.isHidden = false
           // Camera.isHidden = true
            //Or.isHidden = true
            //PhotoLibrary.isHidden = true
            //SaveImage.isHidden = true
            //VnesiSlika.isHidden = true
            DatePicker.isHidden = true
            //imageFile[0].getDataInBackground{ (data,error) in
            /*
            if let imageDate = data {
                    if let imageToDisplay = UIImage(data: imageDate){
                        self.Image.image = imageToDisplay
                    }
                }*/
            }
        }
}
    


