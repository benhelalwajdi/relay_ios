//
//  ProductModel.swift
//  MiniProjet
//
//  Created by Ahlem on 03/12/2018.
//  Copyright © 2018 Ahlem. All rights reserved.
//

import Foundation

class ProductModel {
    var id : String
    var name : String
    var price : Float
    var description : String
    var quantity : String
    var idStore: String
    var image : String
    
    
    init(id: String, name: String, price: Float, description: String, quantity: String, idStore: String, image: String) {
        self.id = id;
        self.name = name
        self.price = price
        self.description = description
        self.quantity = quantity
        self.idStore = idStore
        self.image = image
    }
    
}
