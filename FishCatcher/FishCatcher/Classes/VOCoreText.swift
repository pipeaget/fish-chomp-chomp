//
//  VOCoreText.swift
//  FishCatcher
//
//  Created by Javier Castañeda on 9/11/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import UIKit

class VOCoreText: NSObject{
    
    static func textWithAttachment(text:String,
                                   font:UIFont?,
                                   textColor:UIColor,
                                   attachment:UIImage?,
                                   position:AttachmentPosition) -> NSAttributedString {
        let retAttributedString = NSMutableAttributedString(string: "")
        var attributes:[String:AnyObject] = [NSForegroundColorAttributeName:textColor]
        attributes[NSFontAttributeName] = (font != nil) ? font! : UIFont.systemFont(ofSize: 15)
        attributes[NSBaselineOffsetAttributeName] = 5 as AnyObject?
        
        var substring:NSAttributedString
        switch position {
        case .top:
            if let img = attachment {
                substring = attachImage(img: img)
                retAttributedString.append(substring)
                substring = NSAttributedString(string: "\n"+text, attributes: attributes)
                retAttributedString.append(substring)
            }else{
                substring = NSAttributedString(string: text, attributes: attributes)
                retAttributedString.append(substring)
            }
            break
        case .bottom:
            if let img = attachment {
                substring = NSAttributedString(string: text+"\n", attributes: attributes)
                retAttributedString.append(substring)
                substring = attachImage(img: img)
                retAttributedString.append(substring)
            }else{
                substring = NSAttributedString(string:text, attributes: attributes)
                retAttributedString.append(substring)
            }
            break
        case .left:
            if let img = attachment {
                substring = attachImage(img: img)
                retAttributedString.append(substring)
                substring = NSAttributedString(string: "\t"+text, attributes: attributes)
                retAttributedString.append(substring)
                
            }else{
                substring = NSAttributedString(string:text, attributes: attributes)
                retAttributedString.append(substring)
            }
            break
        case .right:
            if let img = attachment {
                substring = NSAttributedString(string: text+"\t", attributes: attributes)
                retAttributedString.append(substring)
                substring = attachImage(img: img)
                retAttributedString.append(substring)
            }else{
                substring = NSAttributedString(string:text, attributes: attributes)
                retAttributedString.append(substring)
            }
            break
        }
        return retAttributedString
    }
    
    
    static private func attachImage(img:UIImage) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = img
        attachment.bounds = CGRect(origin: CGPoint.zero, size: img.size)
        let attributedString = NSAttributedString(attachment: attachment)
        return attributedString
    }
}
