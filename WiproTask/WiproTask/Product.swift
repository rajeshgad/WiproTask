//
//  Product.swift
//  Sample_TableView
//
//  Created by Esat Kemal Ekren on 5.04.2018.
//  Copyright © 2018 Esat Kemal Ekren. All rights reserved.
//

import UIKit

struct Product {

    var productName : String?
    var productImage : String?
    var productDesc : String?
    init(productNmae : String, productImg :String , productDes : String) {
        self.productDesc = productDes
        self.productImage = productImg
        self.productName = productNmae
    }
}
