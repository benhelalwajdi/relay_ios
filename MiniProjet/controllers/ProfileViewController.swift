//
//  ProfileViewController.swift
//  Pi
//
//  Created by Louay Baccary on 11/11/18.
//  Copyright © 2018 Louay Baccary. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import UserNotifications
import UserNotificationsUI

class ProfileViewController:UIViewController, GMSMapViewDelegate,UNUserNotificationCenterDelegate{
    
    
    @IBOutlet weak var mapView: GMSMapView!
    var ListData:NSDictionary!
    var lat : Double = 0.0
    var lng : Double = 0.0
    
   // let var 
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var numberProduct: UILabel!
    @IBOutlet weak var adresse: UILabel!
    @IBOutlet weak var storeType: UILabel!
    @IBOutlet weak var emailStore: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var ImageStore: UIImageView!
    let defaultValues = UserDefaults.standard
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
    
    
    func createnotif(){
        let content = UNMutableNotificationContent()
        content.title = "New Order"
        content.subtitle = "You Have New Order"
        content.body = " body "
        
        content.sound = UNNotificationSound.default
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false)
        let request = UNNotificationRequest(identifier: "identifier",content: content, trigger: triger)
        UNUserNotificationCenter.current().add(request){ (error) in
            print(error as Any )
        }
    }
    
    @objc func refreshCount()
    {
        let defaultValues = UserDefaults.standard
        let idp = defaultValues.string(forKey: "user_id")
        
        Alamofire.request(Constant.URL_ORDER_STORE+idp!).responseJSON{response in
            print(response.result.value as Any)
            let ListProduct = response.result.value! as! NSArray
            let order = self.defaultValues.string(forKey: "numberOrder")
            if(ListProduct.count != Int(order!)){
                self.createnotif()
                self.defaultValues.set(order, forKey: "numberOrder")
                NSLog("refresh the thread")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ImageStore.layer.cornerRadius = self.ImageStore.frame.size.width / 3
        self.ImageStore.clipsToBounds = true
        self.ImageStore.layer.borderColor = UIColor.white.cgColor
        self.ImageStore.layer.borderWidth = 3
        //getDataStore(id: "54")
     //   fetchNumberProd()
        
       // UNUserNotificationCenter.current().delegate = self
        
        /*Alamofire.request(Constant.URL_ORDER_STORE+"54").responseJSON{response in
            print(response.result.value as Any)
            let ListProduct = response.result.value! as! NSArray
            self.defaultValues.set(ListProduct.count, forKey: "numberOrder")
        }
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(refreshCount), userInfo: nil, repeats: true)*/
        //Fetchdata()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        print("reload after update")
       // getDataStore(id: "54")
      //  Fetchdata(address: self.adresse.text!)
        //fetchNumberProd()
    }
    
    
    func getDataStore(id:String?){
        Alamofire.request(Constant.URL_STROES+id!).responseJSON{response in
            print(response.result.value as Any)
            self.ListData = response.result.value! as? NSDictionary
            self.adresse.text=(self.ListData?["address"]as! String)
            self.Fetchdata(address : self.adresse.text!)
            self.phoneNumber.text=(self.ListData?["phone_number"]as! String)
            self.emailStore.text=(self.ListData?["mail"]as! String)
            self.storeType.text=(self.ListData?["store_type"]as! String)
            self.ImageStore.af_setImage(withURL: URL(string: Constant.URL_IMAGE+""+(self.ListData?["image"]as! String))!)
        }
    }
    
    func Fetchdata(address: String)
    {
        let postParameters:[String: Any] = [ "address": address,"key":"AIzaSyBlasXelU4_D8fni4lotACrm_3jyioAIvk"]
        let url : String = "https://maps.googleapis.com/maps/api/geocode/json"
        Alamofire.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in print(response.result.value as Any)
            let arrayAdresse = response.result.value as! Dictionary <String,Any>
            print(arrayAdresse)
            let results = arrayAdresse["results"] as! NSArray
            print(results)
            let Allresult = results[0] as! Dictionary <String,Any>
            print(Allresult)
            let geometry = Allresult["geometry"] as! Dictionary <String,Any>
            print(geometry)
            let resultsGeo = geometry["location"] as! Dictionary <String,Any>
            print(resultsGeo)
            self.lat = resultsGeo["lat"] as! Double
            print(self.lat)
            self.lng = resultsGeo["lng"] as! Double
            print(self.lng)
            let address_components = Allresult["address_components"] as! NSArray
            print(address_components)
            let address_components2 = address_components[0]as! Dictionary <String,Any>
            let short_name = address_components2["short_name"] as! String
            print(short_name)
            let camera = GMSCameraPosition.camera(withLatitude: self.lat, longitude: self.lng, zoom: 4.0)
            self.mapView.animate(to: camera)
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
            marker.title = short_name
            marker.snippet = address
            marker.map = self.mapView
        }
    }
    func fetchNumberProd(){
        Alamofire.request(Constant.URL_GET_PRODUCTS+"/54").responseJSON{response in
            print(response.result.value as Any)
            let ListData = response.result.value! as! NSArray
            self.numberProduct.text = String (ListData.count)
        }
    }
}
