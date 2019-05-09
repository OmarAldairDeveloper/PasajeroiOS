//
//  RequestDriverViewController.swift
//  zounyrider
//
//  Created by Omar Aldair Romero Pérez on 5/4/19.
//  Copyright © 2019 Honey Mustard. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseMessaging
import Geofirestore
import FirebaseAuth
import CoreLocation
import Alamofire

class RequestDriverViewController: UIViewController {

    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var lonTextField: UITextField!
    
    var myLocation = CLLocation()
    let serverKey = "AAAA6Xdmy78:APA91bFGeto7iVAw3bR5bUQAzrpP6nhPRdpeCp31tYDWSKU3ogZEVLbRY5Xa62c02Sv74ih-PvnHn2MdoXblfZxxXk1s2BqA8cWN7ieC9pksW5_AAipMDoOKM2p5jE7OCxV9LG0bgBE67XjTxc2jwJcFghdwbDTmNg"
    let notificationURL = "https://fcm.googleapis.com/fcm/send"
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 40
        
    }
    

    @IBAction func requestZouny(_ sender: UIButton) {
        
        var conductorID = ""
        let ref = Firestore.firestore().collection("ConductoresDisponibles")
        let geoFirestore = GeoFirestore(collectionRef: ref)
        
        let query =  geoFirestore.query(withCenter: myLocation, radius: 3)
        query.removeAllObservers()
        query.observe(.documentEntered) { (id, location) in


            if let id = id{
                conductorID = id
                
                Firestore.firestore().collection("Conductores").document(conductorID).getDocument(completion: { (snapshot, error) in
                    if error == nil{
                        
                        if let snapshot = snapshot{
                            if let deviceID = snapshot.data()?["token_Android"] as? String{
                                print("deviceID: \(deviceID)")
                                // Ya tendría el token, entonces enviar al conductor la notificación
                                
                                if let myDevice = Messaging.messaging().fcmToken{
                                    
                                    if let uid = Auth.auth().currentUser?.uid{
                                        let reference = Firestore.firestore().collection("Pasajeros").document(uid).collection("Viajes")
                                        let viajeID = reference.document().documentID
                                        
                                        let data: [String:Any] = ["idPasajero": uid, "latOrigenPasajero": self.myLocation.coordinate.latitude, "lngOrigenPasajero":self.myLocation.coordinate.longitude, "destinoPasajero":"Ubicacion predeterminada, número X, Colonia X", "latDestinoPasajero":19.426995, "lngDestinoPasajero":-99.167819]
                                        
                                        
                                        reference.document(viajeID).setData(data, completion: { (error) in
                                            if error == nil{
                                                
                                                self.sendPushNotification(fromDevice: myDevice, toDevice: deviceID, viajeID:viajeID)
                                                
                                               
                                                
                                                
                                                
                                                
                                            }
                                        })
                                        
                                        
                                    }
                                    
                                    
                                    
                                   
                                }
                                
                                
                            }
                        }
                    }
                })
            }
            
        }
        
        
        
        
        
        
    }
    
    
    func sendPushNotification(fromDevice: String, toDevice: String, viajeID: String){
        let message = "Notificación"
        let title = "Hola"
        let body = message
        var headers: HTTPHeaders = HTTPHeaders()
        
        headers = ["Content-Type":"application/json","Authorization":"key=\(serverKey)"]
        
        let notification: [String:Any] = ["to":"\(toDevice)","notification":
            ["body":body, "title":title],
            "data": [
                "idPasajero": Auth.auth().currentUser!.uid,
                "latOrigenPasajero": myLocation.coordinate.latitude,
                "lngOrigenPasajero": myLocation.coordinate.longitude,
                "viajeID":viajeID,
                "destinoPasajero":"Ubicacion predeterminada, número X, Colonia X",
                "latDestinoPasajero": 19.426995,
                "lngDestinoPasajero":-99.167819

            ]]
        
        Alamofire.request(self.notificationURL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            if response.result.isSuccess{
                // Ir a otro segue
                
                self.performSegue(withIdentifier: "segue", sender: nil)
                
                
                
                
            }
        }
    }
    

}


extension RequestDriverViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coor = manager.location?.coordinate{
            
            myLocation = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
            print("myLocation: \(myLocation)")
        }
    }
}
