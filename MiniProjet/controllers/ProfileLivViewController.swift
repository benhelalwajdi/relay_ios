//
//  ProfileLivreurViewController.swift
//  Pi
//
//  Created by wajdii on 17/01/2019.
//  Copyright © 2019 Louay Baccary. All rights reserved.
//

import UIKit
import GoogleMaps
import AlamofireImage
import Alamofire

class ProfileLivViewController:UIViewController, GMSMapViewDelegate{
    var ListDatd: Dictionary <String,Any?>! = [:]
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var vehicle: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var order: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var storeName : String = ""
    var adresse : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchStore()
        //fetchMarker()
    }
    
    func fetchStore(){
        let defaultValues = UserDefaults.standard
        let idp = defaultValues.string(forKey: "user_id")
        
        Alamofire.request(Constant.URL_GET_CLIENT+idp!).responseJSON{response in
            print(response.result.value as Any)
            let ListDate = response.result.value! as! Dictionary <String,Any?>
            self.ListDatd = ListDate as Dictionary<String, Any?>
            self.vehicle.text=(ListDate["vehicle"]as! String)
            self.phone.text=(ListDate["phone_number"]as! String)
            self.email.text=(ListDate["mail"]as! String)
            self.address.text=(ListDate["address"]as! String)
            
        }
       // fetchMarker()
        
    }
    
    func fetchMarker(){
        let postParameters:[String: Any] = [ "address": self.address.text as Any,"key":"AIzaSyBlasXelU4_D8fni4lotACrm_3jyioAIvk"]
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
            let lat = resultsGeo["lat"] as! Double
            print(lat)
            let lng = resultsGeo["lng"] as! Double
            print(lng)
            let address_components = Allresult["address_components"] as! NSArray
            print(address_components)
            let address_components2 = address_components[0]as! Dictionary <String,Any>
            let short_name = address_components2["short_name"] as! String
            print(short_name)
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 4.0)
            self.mapView.animate(to: camera)
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            marker.title = short_name
            marker.snippet = self.address.text
            marker.map = self.mapView
            return ;
        }
        
    }
    
}
