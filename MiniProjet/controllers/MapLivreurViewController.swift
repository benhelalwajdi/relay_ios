//
//  MapLivreurViewController.swift
//  Pi
//
//  Created by wajdii on 17/01/2019.
//  Copyright © 2019 Louay Baccary. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire


class MapLivreurViewController: UIViewController, GMSMapViewDelegate{
    
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var store_name: UILabel!
    @IBOutlet weak var image: UIImageView!
    var id : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStore()
    }
    @IBAction func getOrder(_ sender: Any) {
        let defaultValues = UserDefaults.standard
        let idp = defaultValues.string(forKey: "user_id")
        
        let parameters: Parameters = [
            "id_deliverer": idp!,
            "id" : id
        ]
        let headersUpdate: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            ]
        
        Alamofire.request(Constant.URL_ORDER_GET_LIV, method:.post, parameters:parameters, headers:headersUpdate).responseJSON { response in
            print(response.result.value as Any)
            let exerciceDict = response.result.value as! Dictionary<String,Any>
            let test = exerciceDict["status"] as! Int
            if(test == 0){
                let alert = UIAlertController(title: "erreur", message: "update Product erreur", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
            }
            else{
                let alert = UIAlertController(title: "Succes", message: "Prodcut succes", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
            }
        }
    }
    
    
    func fetchStore(){
        let defaultValues = UserDefaults.standard
        let idp = defaultValues.string(forKey: "id_storeLiv")
        Alamofire.request(Constant.URL_STROES+idp!).responseJSON{response in
            print(response.result.value as Any)
            let ListDatd = response.result.value! as! NSArray
            let ListDate = ListDatd[0] as! Dictionary <String,Any>
            self.store_name.text=(ListDate["store_name"]as! String)
            self.adress.text=(ListDate["address"]as! String)
            self.mail.text=(ListDate["mail"]as! String)
            self.phone.text=(ListDate["phone_number"]as! String)
            self.fetchMarker(address: self.adress.text!)
        }
    }
    
    func fetchMarker(address : String){
        let postParameters:[String: Any] = [ "address": self.adress.text as Any,"key":"AIzaSyDBHP8EZtuPWd4tlZebWLy3-0_KSzVl4n8"]
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
            marker.title = self.store_name.text
            marker.snippet = self.adress.text
            marker.map = self.mapView
        }
    }
}
