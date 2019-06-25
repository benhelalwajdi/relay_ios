//
//  RoundButton.swift
//  MiniProjet
//
//  Created by Ahlem on 11/11/2018.
//  Copyright © 2018 Ahlem. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
