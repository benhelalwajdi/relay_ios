//
//  ListProductsController.swift
//  MiniProjet
//
//  Created by Ahlem on 11/11/2018.
//  Copyright © 2018 Ahlem. All rights reserved.
//

import UIKit
import Alamofire

class ListProductsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var storeId : String?
    var sender : String?
    
    var dataResponse:NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if (sender! == "NEW"){
            fetchNewReleases()
        }else if (sender! == "TOPRATED"){
            fetchTopRatedProducts()
        }else {
            fetchStores()

        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath)
        
      /*  cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        */
        cell.contentView.layer.cornerRadius = 14.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        /*cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath

        
        */
        let contentview = cell.viewWithTag(0)
        let productName = contentview?.viewWithTag(1) as! UILabel
        /*  let productDescription = contentview?.viewWithTag(2) as! UILabel
        let productPrice = contentview?.viewWithTag(3) as!UILabel*/
        let storeImage = contentview?.viewWithTag(4) as! UIImageView
        
    

        
        let products = dataResponse[indexPath.item] as! Dictionary<String , Any>
        productName.text = products["name"] as? String
       /* productDescription.text = products["description"] as? String
        productPrice.text = products["price"] as? String
      */
        storeImage.image = UIImage(named: "nike")
        
        return cell
    }
    
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     performSegue(withIdentifier: "detailsProduct", sender: indexPath)
     }
 
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = sender as! IndexPath
        let products = dataResponse[indexPath.item] as! Dictionary<String , Any>
        let destinationViewController = segue.destination as? ProductDetailsController
        destinationViewController?.idProduct = String(describing: products["id"] as! Int)
        destinationViewController?.idStore = storeId
    }
    
    func fetchStores (){
        let jsonUrl = "http://"+Constant.IP_ADDRESS+":11809/products/store/\(storeId!)";
        print (jsonUrl)
        Alamofire.request(jsonUrl)
            .responseJSON{response in
                self.dataResponse = response.result.value! as! NSArray
                self.collectionView.reloadData()
                
        }
    }
    
    func fetchNewReleases (){
        let jsonUrl = "http://"+Constant.IP_ADDRESS+":11809/products/";
        print (jsonUrl)
        Alamofire.request(jsonUrl)
            .responseJSON{response in
                self.dataResponse = response.result.value! as! NSArray
                self.collectionView.reloadData()
                
        }
    }
    

    
    func fetchTopRatedProducts(){
        let jsonUrl = "http://"+Constant.IP_ADDRESS+":11809/products/rated";
        print (jsonUrl)
        Alamofire.request(jsonUrl)
            .responseJSON{response in
                self.dataResponse = response.result.value! as! NSArray
                self.collectionView.reloadData()
        }
    }
    
}
