//
//  UpdateDataStoreViewController.swift
//  Pi
//
//  Created by wajdii on 16/01/2019.
//  Copyright © 2019 Louay Baccary. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class UpdateDataStoreViewController: UIViewController ,UIPickerViewDelegate,
UIPickerViewDataSource ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    let size = ["Electronic","Sport","General"]
    var sizetxt:String?
    var sizeSelected : String = ""
    var imageData : Data?
    var imageName:String = ""
    var img :String = ""
    let headers: HTTPHeaders = [:]
    var pickedImageProduct = UIImage()
    let imagePicker = UIImagePickerController()
    var ListData:NSArray=[]
    @IBOutlet weak var PickerSize: UIPickerView!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBAction func addImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
    }
    @IBAction func updateStore(_ sender: Any) {
        //Todo
        print("Update click")
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
                            Service.init().update(store_name: self.Name.text!, store_type: self.sizeSelected, mail: self.email.text!, address: self.address.text!, image: self.imageName, phone_number: self.phoneNumber.text!, id: "54")
                            
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        
                    }
            })
            
        }else{
            Service.init().update(store_name: self.Name.text!, store_type: self.sizeSelected, mail: self.email.text!, address: self.address.text!, image: self.img , phone_number: self.phoneNumber.text!, id: "54")
        }
    }
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PickerSize.delegate = self
        PickerSize.dataSource = self
        imagePicker.delegate = self
        let defaultValues = UserDefaults.standard
        let idp = defaultValues.string(forKey: "user_id")
        
      //  getDataStore(id: idp!)
        
    }
    
    
    func getDataStore(id:String?){
        Alamofire.request(Constant.URL_STROES+id!).responseJSON{response in
            print(response.result.value as Any)
            self.ListData = response.result.value! as! NSArray
            let ListData = self.ListData[0] as! Dictionary <String,Any>
            self.Name.text=(ListData["store_name"]as! String)
            self.address.text=(ListData["address"]as! String)
            self.phoneNumber.text=(ListData["phone_number"]as! String)
            self.email.text=(ListData["mail"]as! String)
            self.img = (ListData["image"]as! String)
            self.imageProduct.af_setImage(withURL: URL(string: Constant.URL_IMAGE+""+(ListData["image"]as! String))!)
            print(ListData)
            
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
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

