//
//  UpdateQuantityView.swift
//  MiniProjet
//
//  Created by Ahlem on 09/12/2018.
//  Copyright © 2018 Ahlem. All rights reserved.
//

import UIKit

@IBDesignable class UpdateQuantityView: UIView {
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
