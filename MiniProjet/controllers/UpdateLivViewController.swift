//
//  UpdateLivViewController.swift
//  Pi
//
//  Created by wajdii on 18/01/2019.
//  Copyright © 2019 Louay Baccary. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class UpdateLivViewController: UIViewController ,UIPickerViewDelegate,
UIPickerViewDataSource ,UINavigationControllerDelegate{
    
    let size = ["Car","Truck","Bicyclette"]
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
    @IBOutlet weak var imageProduct: UITextField!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBAction func updateStore(_ sender: Any) {
        //Todo
        print("Update click")
        Service.init().updateLiv(store_name: self.Name.text!, store_type: self.sizeSelected, mail: self.email.text!, address: self.address.text!, image: self.imageProduct.text!, phone_number: self.phoneNumber.text!, id: "74")
        
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
        let defaultValues = UserDefaults.standard
        let idp = defaultValues.string(forKey: "user_id")
        
        getDataStore(id: idp!)
        
    }
    
    
    func getDataStore(id:String?){
        Alamofire.request(Constant.URL_STROES+id!).responseJSON{response in
            print(response.result.value as Any)
            self.ListData = response.result.value! as! NSArray
            let ListData = self.ListData[0] as! Dictionary <String,Any>
            self.Name.text=(ListData["first_name"]as! String)
            self.address.text=(ListData["address"]as! String)
            self.phoneNumber.text=(ListData["phone_number"]as! String)
            self.email.text=(ListData["mail"]as! String)
            self.img = (ListData["last_name"]as! String)
            self.imageProduct.text = self.img
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
}

