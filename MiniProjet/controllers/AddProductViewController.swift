//
//  AddProductViewController.swift
//  Pi
//
//  Created by Mac Os on 12/3/18.
//  Copyright © 2018 Louay Baccary. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class AddProductViewController: UIViewController ,UIPickerViewDelegate,
UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var Discription: UITextField!
    @IBOutlet weak var Price: UITextField!
    @IBOutlet weak var NameProd: UITextField!
    @IBOutlet weak var Quantity: UITextField!
    @IBOutlet weak var imageProduct: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var imageData : Data?
    let headers: HTTPHeaders = [:]
    var pickedImageProduct = UIImage()
    var imageName:String = ""
    
    @IBOutlet weak var PickerSize: UIPickerView!
    let size = ["SMALL","MEDIUM","LARG"]
    var sizeSelected : String = ""
    
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
    
    
    @IBAction func addImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        //addProduct
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
                            let defaultValues = UserDefaults.standard
                            let idp = defaultValues.string(forKey: "user_id")
                            
                            Service.init().addProduct(image: self.imageName, name: self.NameProd.text! , description: self.Discription.text!, price: self.Price.text, quantity: self.Quantity.text, size: self.sizeSelected, id: idp!)
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            })
        }else{
            let defaultValues = UserDefaults.standard
            let idp = defaultValues.string(forKey: "user_id")
            
            Service.init().addProduct(image: self.imageName, name: self.NameProd.text! , description: self.Discription.text!, price: self.Price.text, quantity: self.Quantity.text, size: self.sizeSelected, id: idp!)
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        PickerSize.delegate = self
        PickerSize.dataSource = self
        imagePicker.delegate = self
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


