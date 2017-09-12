
//
//  UIFontExtension.swift
//  FishCatcher
//
//  Created by Javier Castañeda on 9/11/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import UIKit

extension UIFont{
    class func glimstick(size: CGFloat) -> UIFont{
        guard let font = UIFont(name: "Glimstick", size: size) else{
            return UIFont.systemFont(ofSize:size)
        }
        return font
    }
}
