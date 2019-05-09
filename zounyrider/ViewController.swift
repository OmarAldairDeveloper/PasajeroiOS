//
//  ViewController.swift
//  zounyrider
//
//  Created by Omar Aldair Romero Pérez on 5/4/19.
//  Copyright © 2019 Honey Mustard. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func signInAction(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, (email.count > 0 && password.count > 0){
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error == nil{
                    self.performSegue(withIdentifier: "loginToRequest", sender: nil)
                }
            }
            
        }
    }
    @IBAction func signUpAction(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, (email.count > 0 && password.count > 0){
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                if error == nil{
                    
                    if let uid = result?.user.uid{
                        Firestore.firestore().collection("Pasajeros").document(uid).setData(["apellidos":"", "celular":"", "fecha_registro":Timestamp().dateValue(), "foto_perfil":"", "nombre":"Aldar"], completion: { (error) in
                            if error == nil{
                                self.performSegue(withIdentifier: "loginToRequest", sender: nil)
                            }
                        })
                    }
                    
                    
                    
                }
            }
            
        }
    }
    
}

