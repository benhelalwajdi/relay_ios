//
//  UpdateProuctViewController.swift
//  Pi
//
//  Created by Mac Os on 12/3/18.
//  Copyright © 2018 Louay Baccary. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class UpdateProuctViewController: UIViewController ,UIPickerViewDelegate,
UIPickerViewDataSource ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var discription : String?
    var price : String?
    var nameProd : String?
    var quantity : String?
    var id : String?
    var image : String?
    let urlprod = Constant.URL_PRODUCTS+"update_product"
    var imageData : Data?
    let headers: HTTPHeaders = [:]
    var pickedImageProduct = UIImage()
    let imagePicker = UIImagePickerController()
    var categoryId:Int = 0
    var imageName:String = ""
    
    var sizetxt:String?
    let size = ["SMALL","MEDIUM","LARG"]
    var sizeSelected : String = ""
    
    let ListProduct : Dictionary <String,Any> = [:]
    let defaultValues = UserDefaults.standard
    
    
    @IBOutlet weak var Discription: UITextField!
    @IBOutlet weak var Price: UITextField!
    @IBOutlet weak var NameProd: UITextField!
    @IBOutlet weak var Quantity: UITextField!
    @IBOutlet weak var imageProduct: UIImageView!
    
    @IBAction func addImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var PickerSize: UIPickerView!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return size.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return size[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sizeSelected = size[row]
        print(sizeSelected)
    }
    
    @IBAction func UpdateProduct(_ sender: Any) {
        
        //if(sizeSelected!=""){
        if (imageData != nil){
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(self.imageData!, withName: "profile", fileName:"image.jpg" , mimeType: "image/jpeg")
            },
                to: Constant.URL_UPLOAD_IMAGE,
                headers: headers,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                            let prod = response.result.value as! Dictionary<String,Any>
                            let test = prod["image"] as! String
                            self.imageName = test
                            Service.init().updateProduct(image: self.imageName, name: self.NameProd.text! , description: self.Discription.text!, price: self.Price.text, quantity: self.Quantity.text, size: self.sizeSelected, id: self.id!)
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        
                    }
            })
            
        }else{
            Service.init().updateProduct(image: self.image!, name: self.NameProd.text! , description: self.Discription.text!, price: self.Price.text, quantity: self.Quantity.text, size: self.sizeSelected, id: self.id!)
        }
    }
    
    
    @IBAction func DeleteProduct(_ sender: Any) {
        if(id != ""){
            Alamofire.request(" ").responseJSON{response in
                print(response.result.value as Any)
                _ = response.result.value! as! String
            }
        }else{
            print("id product nil")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PickerSize.delegate = self
        PickerSize.dataSource = self
        imagePicker.delegate = self
        Discription.text = discription
        Price.text = price
        NameProd.text = nameProd
        Quantity.text = quantity
        imageProduct.af_setImage(withURL: URL(string: Constant.URL_IMAGE+""+image!)!)
        self.defaultValues.set(self.id!, forKey: "id_product")
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Error: \(info)")
        }
        pickedImageProduct = selectedImage
        let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as! URL
        print(fileUrl.lastPathComponent)
        if (( pickedImageProduct.jpegData(compressionQuality: 0.5)) != nil){
            imageData = pickedImageProduct.jpegData(compressionQuality: 0.5)
        } else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        // 2
        self.imageProduct.image = pickedImageProduct
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        return view
    }()
    
}
private func pinBackground(_ view: UIView, to stackView: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    stackView.insertSubview(view, at: 0)
}
