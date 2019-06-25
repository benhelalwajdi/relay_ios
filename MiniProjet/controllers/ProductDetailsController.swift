//
//  ProductDetailsController.swift
//  MiniProjet
//
//  Created by Ahlem on 12/11/2018.
//  Copyright © 2018 Ahlem. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import Toast_Swift
import Cosmos


class ProductDetailsController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return dataResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "review", for: indexPath)
        
        let contentview = cell.viewWithTag(0)
        let ratingBar = contentview?.viewWithTag(1) as! CosmosView
        let comment = contentview?.viewWithTag(2) as! UITextView
    
        let reviews = dataResponse[indexPath.item] as! Dictionary<String , Any>
        ratingBar.settings.updateOnTouch = false
        ratingBar.rating = reviews["rating"] as! Double
        comment.text = reviews["comment"] as! String
        print(reviews["comment"] as! String)
     
        return cell
    
    }
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productPrice: UILabel!
    var dataResponse:NSArray = []

    
    var idProduct : String?
    var idStore : String?
    var product : ProductModel?
    
    let managedContext = DBHelper.persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(idProduct!)
        fetchSingleProduct()
        getReviews()

        
    }
    
    @IBAction func addToShoppingBag(_ sender: Any) {
        
        //TODO: Check if product already exist in shopping bag
        
        let coredateProduct = Product(context: DBHelper.context)
        coredateProduct.id = idProduct!
        coredateProduct.name = self.product?.name
        coredateProduct.descriptions = self.product?.description
        coredateProduct.price = Float((self.product?.price)!)
        coredateProduct.image = "nike"
        coredateProduct.storeId = self.product!.idStore
        coredateProduct.quantity = self.product!.quantity
        
        DBHelper.saveContext()
        
        //TODO: Check if product is added succesfully here and not in the DBHelper
        self.view.makeToast("You added \(String(describing: self.product!.name)) to your shopping bag", duration: 3.0, position: .center)
        
    }
    
    func fetchSingleProduct(){
        let URL = "http://"+Constant.IP_ADDRESS+":11809/products/\(String(describing: idProduct!))"
        print(URL)
        Alamofire.request(URL, method: .get)
            .responseJSON { response in
                if response.data != nil {
                    do {
                        let json = try JSON(data: response.data!)
                        self.product = ProductModel(id: self.idProduct!,
                                                    name: json["name"].string!,
                                                    price: Float(json["price"].string!)!,
                                                    description : json["description"].string!,
                                                    quantity : "1",
                                                    idStore: String(json["store_id"].int!),
                                                    image : json["image"].string!)

                        let imgURL = "http://"+Constant.IP_ADDRESS+":11809/uploads/\(self.product!.image)"
                        self.setImageFromServer(url: imgURL)

                        //  self.image.af_setImage(withURL: URL(string: imgURL)!)


                        self.productName.text = self.product?.name
                        self.productDescription.text = self.product?.description
                       // val string =
                        self.productPrice.text = "\(String(describing: self.product!.price)) TND"
                       // String(describing: self.product!.price)
                        
                    }catch{
                        print(error)
                    }
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        let destinationViewController = segue.destination as? AddReviewToProductPopupController
        destinationViewController?.productId = idProduct!
    }
    
    
    func getReviews(){
        let jsonUrl = "http://"+Constant.IP_ADDRESS+":11809/reviews/product/\(idProduct!)";
        print (jsonUrl)
        Alamofire.request(jsonUrl)
            .responseJSON{response in
                self.dataResponse = response.result.value! as! NSArray
                self.collectionView.reloadData()
                
        }
    
    }
    
    
    func setImageFromServer(url : String){
        self.image.af_setImage(withURL: URL(string: url)!)
    }
}
