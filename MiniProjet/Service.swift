//
//  Service.swift
//  Pi
//
//  Created by wajdii on 15/01/2019.
//  Copyright © 2019 Louay Baccary. All rights reserved.
//


import UIKit
import Alamofire
import AlamofireImage

class  Service{
    
    let headers: HTTPHeaders = [:]
    var imageName : String?
    
    func updateProduct(image: String?,name: String?, description: String?, price:String?,
                       quantity: String?, size: String?, id: String? ){
        
        let parameters: Parameters = [
            "name": name!,
            "description": description!,
            "price": price!,
            "quantity": quantity!,
            "size": size!,
            "image": image!,
            "id": id!
        ]
        let headersUpdate: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            ]
        
        Alamofire.request(Constant.URL_UPDATE_PRODUCT, method:.post, parameters:parameters, headers:headersUpdate).responseJSON { response in
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
    func update(store_name : String, store_type: String, mail: String, address: String, image: String, phone_number:String, id: String){
        let parameters: Parameters = [
            "store_name": store_name,
            "store_type": store_type,
            "mail": mail,
            "address": address,
            "image": image,
            "phone_number": phone_number,
            "id": id
        ]
        
        let headersUpdate: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            ]
        
        Alamofire.request(Constant.URL_UPDATE_STORE, method:.post, parameters:parameters, headers:headersUpdate).responseJSON {
            response in
            print(response.result.value as Any)
            let prod = response.result.value as! Dictionary<String,Any>
            let test = prod["status"] as! Int
            if(test == 0){
                let alert = UIAlertController(title: "erreur", message: "update Product erreur", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
            }else{
                let alert = UIAlertController(title: "Succes", message: "Prodcut succes", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
            }
        }
    }
    //URL_UPDATE_LIV
    
    func updateLiv(store_name : String, store_type: String, mail: String, address: String, image: String, phone_number:String, id: String){
        let parameters: Parameters = [
            "first_name": store_name,
            "last_name": image,
            "vehicle": store_type,
            "mail": mail,
            "address": address,
            "phone_number": phone_number,
            "id": id
        ]
        
        let headersUpdate: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            ]
        
        Alamofire.request(Constant.URL_UPDATE_LIV, method:.post, parameters:parameters, headers:headersUpdate).responseJSON {
            response in
            print(response.result.value as Any)
            let prod = response.result.value as! Dictionary<String,Any>
            let test = prod["status"] as! Int
            if(test == 0){
                let alert = UIAlertController(title: "erreur", message: "update Product erreur", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
            }else{
                let alert = UIAlertController(title: "Succes", message: "Prodcut succes", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
            }
        }
    }
    func addProduct(image: String?,name: String?, description: String?, price:String?,quantity: String?, size: String?, id: String? ){
        
        let parameters: Parameters = [
            "name": name!,
            "description": description!,
            "price": price!,
            "quantity": quantity!,
            "size": size!,
            "image": image!,
            "store_id": id!
        ]
        let headersUpdate: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            ]
        
        Alamofire.request(Constant.URL_CREATE_PRODUCT, method:.post, parameters:parameters, headers:headersUpdate).responseJSON { response in
            print(response.result.value as Any)
            let prod = response.result.value as! Dictionary<String,Any>
            let test = prod["status"] as! Int
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
    
    func uploadImage(imageData:Data?)->String{
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!, withName: "profile", fileName:"image.jpg" , mimeType: "image/jpeg")
        },
            to: Constant.URL_UPLOAD_IMAGE,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        self.imageName = response.result.value as? String
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
        
        return self.imageName!
    }
}
