//
//  Constant.swift
//  Pi
//
//  Created by ESPRIT on 1/13/19.
//  Copyright © 2019 Louay Baccary. All rights reserved.
//

import Foundation
public class Constant {
    //http://41.226.11.252:11809/
    public static let IP_ADDRESS = "41.226.11.252";
    private static let URL = "http://"+IP_ADDRESS+":11809";
    
    public  static let URL_PRODUCTS = URL+"/products/"
    public  static let URL_UPDATE_PRODUCT = URL_PRODUCTS+"update_product"
    public  static let URL_CREATE_PRODUCT = URL_PRODUCTS+"create_product"
    public  static let URL_GET_PRODUCTS = URL_PRODUCTS+"store"
    
    public  static let URL_STROES = URL+"/stores/"
    public  static let URL_UPDATE_STORE = URL+"/users/update_store"
    public  static let URL_UPDATE_LIV = URL+"/users/update_deliverer"
    
    
    public  static let URL_IMAGE = URL+"/uploads/"
    public  static let URL_UPLOAD_IMAGE = URL_PRODUCTS+"upload"
    
    public  static let URL_ORDER_STORE = URL+"/orders/store/"
    public  static let URL_GET_PRODUCT_REVIEWS = URL+"/reviews/product/"
    public  static let URL_ORDER_LIV = URL+"/orders/dilivreur/"
    public  static let URL_ORDER_GET_LIV = URL+"/orders/update_order"
    
    
    public  static let URL_GET_CLIENT = URL+"/clients/"
    //static ipAddress = "192.168.43.43"
    public  static let URL_ALL_STORE = URL+"/stores/"
}

