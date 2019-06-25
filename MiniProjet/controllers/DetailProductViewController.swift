//
//  DetailViewController.swift
//  Pi
//
//  Created by ESPRIT on 11/12/18.
//  Copyright © 2018 Louay Baccary. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class DetailProductViewController : UIViewController{
    
    var discription : String?
    var price : String?
    var nameProd : String?
    var quantity : String?
    var id : String?
    var image : String?
    var date : String?
    var sizetxt:String?
    var ListProduct:NSArray=[]
    
    @IBOutlet weak var descriptionProduct: UITextView!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("reload after update")
        fetch()
        
    }
    func fetch(){
        let defaultValues = UserDefaults.standard
        if let idp = defaultValues.string(forKey: "id_product"){
            Alamofire.request(Constant.URL_PRODUCTS+idp).responseJSON{response in
                print(response.result.value as Any)
                let ListProduct = response.result.value! as! Dictionary <String,Any>
                self.discription=(ListProduct["description"] as! String)
                self.price = (ListProduct["price"]as! String)
                self.nameProd = (ListProduct["name"]as! String)
                self.quantity = (ListProduct["quantity"]as! String)
                self.id = String(ListProduct["id"]as! Int)
                self.image = (ListProduct["image"]as! String)
                self.date = (ListProduct["date"]as! String)
                self.sizetxt = (ListProduct["size"]as! String)
                self.descriptionProduct.text! = self.discription!
                self.priceProduct.text! = self.price!+" dtn"
                self.nameProduct.text! = self.nameProd!
                //quantity.text! =
                self.imageProduct.af_setImage(withURL: URL(string: Constant.URL_IMAGE+""+self.image!)!)
            }
        }else{
            descriptionProduct.text! = discription!
            priceProduct.text! = price!+" dtn"
            nameProduct.text! = nameProd!
            //quantity.text! =
            imageProduct.af_setImage(withURL: URL(string: Constant.URL_IMAGE+""+image!)!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateProduct"{
            let destinationViewController =  segue.destination as? UpdateProuctViewController
            destinationViewController?.discription = self.discription
            destinationViewController?.nameProd = self.nameProd
            destinationViewController?.price = self.price
            destinationViewController?.quantity = self.quantity
            destinationViewController?.sizetxt = self.sizetxt
            destinationViewController?.id = self.id
            destinationViewController?.image = self.image
        }else if segue.identifier == "reviewProduct"{
            let destinationViewController =  segue.destination as? ReviewTableViewController
            destinationViewController?.id = self.id!
        }
    }
    
}
