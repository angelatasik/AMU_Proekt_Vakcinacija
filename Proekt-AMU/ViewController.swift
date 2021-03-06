//
//  ViewController.swift
//  Proekt-AMU
//
//  Created by Angela Tasikj on 7/30/21.
//  Copyright © 2021 Angela Tasikj. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var NameSurname: UITextField!
    @IBOutlet weak var Opis1: UILabel!
    @IBOutlet weak var Opis2: UILabel!
    
    @IBOutlet weak var IDNumber: UITextField!

    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var PhoneNumber: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var LogInOutlet: UIButton!
    @IBOutlet weak var Citizen: UIButton!
    
    @IBOutlet weak var TipKorisnik: UILabel!
    @IBOutlet weak var SwitchSignUp: UIButton!
    
    @IBOutlet weak var Doctor: UIButton!
    var signUpMode = true
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func DoctorButton(_ sender: Any) {
        print("tipkorisnik: doktor")
        TipKorisnik.text = "Doctor"
        TipKorisnik.isHidden = true
        //Doctor.isHidden = true
        //Citizen.isHidden = true
        Opis1.isHidden = true
        Opis2.isHidden = false
        Opis2.text = "       You will be registered as a Doctor"
        print("se izvrsuva se vo DoctButton")
        
    }
    
    
 
    @IBAction func CitizenButton(_ sender: Any) {
        print("tipkorisnik: citizen")
        
        //self.Citizen.backgroundColor = UIColor.green
        TipKorisnik.text = "Citizen"
        TipKorisnik.isHidden = true
        Opis1.isHidden = true
        Opis2.isHidden = false
        Opis2.text = "       You will be registered as a Citizen"
        print("se izvrsuva se vo CitizenButton")
    }
    @IBAction func LoginAction(_ sender: Any) {
        if signUpMode{
            if Email.text == "" || Password.text == "" || PhoneNumber.text == "" || NameSurname.text == "" || IDNumber.text == ""{
                DisplayAlert(title: "Error in form", msg: "You must provide all ")
            }else{
                activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityIndicator.center = view.center //da vrti vo sredina
                activityIndicator.hidesWhenStopped = true // da se skrie koga ke bide prekinat activityindicator-or
                activityIndicator.style = UIActivityIndicatorView.Style.gray
                view.addSubview(activityIndicator)
                UIApplication.shared.beginIgnoringInteractionEvents() //blokirano e klikanjeto na sekoe kopce ili pole po pritiskanje na Login/SignUp za da ne se klika bilo so dr
                
                let user = PFUser()
                user.username = Email.text
                user.password = Password.text
                user.email = Email.text
                
                user["firstLastName"] = NameSurname.text
                user["phoneNumber"] = PhoneNumber.text
                user["tipKorisnik"] = TipKorisnik.text
                
                
                user.signUpInBackground { (succes, error) in
                    if let error = error {
                        let errorString = error.localizedDescription
                        self.DisplayAlert(title: "Error signing up", msg: errorString)
                    }else{
                        //print("Sign up succ")
                        if PFUser.current()!["tipKorisnik"] as! String == "Citizen" {
                            self.performSegue(withIdentifier: "GragjaninSeg", sender: self)
                            print("Signed up - Citizen")
                        }else if PFUser.current()!["tipKorisnik"] as! String == "Doctor" {
                            self.performSegue(withIdentifier: "DoctorsSeg", sender: self)
                            //DoctorSeg
                            print("Login- Doctor")
                        }else{
                            self.performSegue(withIdentifier: "DoctorsSeg", sender: self)
                            //DoctorSeg
                            print("Login- Korisnik")
                        }
                    }
                }
    }
        }else{
            if Email.text == "" || Password.text == ""{
                DisplayAlert(title: "Error in form", msg: "You must provide all ")
            }else{
                activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityIndicator.center = view.center //da vrti vo sredina
                activityIndicator.hidesWhenStopped = true // da se skrie koga ke bide prekinat activityindicator-or
                activityIndicator.style = UIActivityIndicatorView.Style.gray
                view.addSubview(activityIndicator)
                UIApplication.shared.beginIgnoringInteractionEvents() //blokirano e klikanjeto na sekoe kopce ili pole po pritiskanje na Login/SignUp za da ne se klika bilo so dr
                
                PFUser.logInWithUsername(inBackground: Email.text! , password: Password.text!) { (user,error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if let error = error{
                        let errorString = error.localizedDescription
                        self.DisplayAlert(title: "Error", msg: errorString)
                    }else{
                        //print("LogIn succes")
                        if PFUser.current()!["tipKorisnik"] as! String == "Citizen" {
                            self.performSegue(withIdentifier: "GragjaninSeg", sender: self)
                            print("Login - Citizen")
                        }else if PFUser.current()!["tipKorisnik"] as! String == "Doctor" {
                            self.performSegue(withIdentifier: "DoctorsSeg", sender: self)
                            //DoctorSeg
                            print("Login- Doctor")
                        }else{
                            self.performSegue(withIdentifier: "DoctorsSeg", sender: self)
                            //DoctorSeg
                            print("Login- Korisnik")
                        }
                    }
        }
    }
        }
    }
    
    @IBAction func SwitchSignUpAction(_ sender: Any) {
        if signUpMode {
            
            signUpMode = false
            print("kliknato za da premine na login")
            LogInOutlet.setTitle("Login", for: .normal)
            SwitchSignUp.setTitle("Switch to Sign Up", for: .normal)
            NameSurname.isHidden = true
            IDNumber.isHidden = true
            PhoneNumber.isHidden = true
            TipKorisnik.isHidden = true
            Citizen.isHidden = true
            Doctor.isHidden = true
            
            Opis1.isHidden = true
            Opis2.isHidden = true

        }else{
            
            print("kliknato za da premine na signup")
            signUpMode = true
            LogInOutlet.setTitle("Sign Up", for: .normal)
            SwitchSignUp.setTitle("Switch to Log In", for: .normal)
            NameSurname.text = ""
            IDNumber.text = " "
            PhoneNumber.text = " "
            Email.text = " "
            Password.text  = " "
            NameSurname.isHidden = false
            IDNumber.isHidden = false
            PhoneNumber.isHidden = false
            TipKorisnik.isHidden = true
            Citizen.isHidden = false
            Doctor.isHidden = false
            //Opis1.isHidden = false
            //Opis2.isHidden = false
            proverka()
            /*
            if TipKorisnik.text == "Citizen" {
                
                print("kliknato za da premine na signup-kliknat citizen")
                Citizen.isHidden = true
                Doctor.isHidden = true
                Opis1.isHidden = true
                Opis2.text = "You will be registered as a Citizen"
            }else if TipKorisnik.text == "Doctor"{
                
                print("kliknato za da premine na signup,kliknat doctor")
                Citizen.isHidden = true
                Doctor.isHidden = true
                Opis1.isHidden = true
                Opis2.text = "You will be registered as a Doctor"
            }else{
                
                print("kliknato za da premine na signup-nisho kliknato")
                Citizen.isHidden = false
                Doctor.isHidden = false
                Opis1.isHidden = false
                Opis2.isHidden = false
            }
            */
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if signUpMode == false {
            print("viewDidAp: vo login delot")
            NameSurname.isHidden = true
            IDNumber.isHidden = true
            PhoneNumber.isHidden = true
            TipKorisnik.isHidden = true
            Citizen.isHidden = true
            Doctor.isHidden = true
            Opis1.isHidden = true
            Opis2.isHidden = true
        }else{
            print("viewDidAp: vo signup delot")
            
            Opis1.isHidden = false
            Opis2.isHidden = false
            NameSurname.isHidden = false
            IDNumber.isHidden = false
            PhoneNumber.isHidden = false
            TipKorisnik.isHidden = true
            /*
            if TipKorisnik.text == "Citizen" {
                print("viewDidAp: vo signup delot-KLIK citizen")
                Citizen.isHidden = true
                Doctor.isHidden = true
                Opis1.isHidden = true
                Opis2.isHidden = false
                Opis2.text = "You will be registered as a Citizen"
            }else if TipKorisnik.text == "Doctor"{
                print("viewDidAp: vo signup delot-KLIK doct")
                Citizen.isHidden = true
                Doctor.isHidden = true
                Opis1.isHidden = true
                Opis2.isHidden = false
                Opis2.text = "You will be registered as a Doctor"
            }else{
                
                print("viewDidAp: vo signup delot-KLIK nisho")
                Citizen.isHidden = false
                Doctor.isHidden = false
                Opis1.isHidden = false
                Opis2.isHidden = false
            }
 */
            Citizen.isHidden = false
            Doctor.isHidden = false
            //proverka()
    }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func DisplayAlert(title: String, msg: String) {
            let alertCotnroller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alertCotnroller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alertCotnroller,animated: true, completion: nil)
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func proverka() {
        if(TipKorisnik.text == "Citizen") {
            //Opis2.text = "regg as a citizen"
            Opis1.isHidden = false
            Opis2.isHidden = false
            Opis2.text = "any,you will be registered as a regular user."
        }else if (TipKorisnik.text == "Doctor"){
            Opis1.isHidden = false
            Opis2.isHidden = false
             Opis2.text = "any,you will be registered as a regular user."
            //Opis2.text = "regg as a citizen"
        }else{
            Opis1.isHidden = false
            Opis2.isHidden = false
            Opis2.text = "any,you will be registered as a regular user."
        }
    }
    
}

