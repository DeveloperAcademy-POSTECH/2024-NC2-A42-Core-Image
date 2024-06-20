//
//  RotateImage.swift
//  CoreImageApp
//
//  Created by Jerrie on 6/20/24.
//

import Foundation
import UIKit

func fixOrientation(img: UIImage) -> UIImage {
    if (img.imageOrientation == .up) {
        return img
    }
    
    UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
    let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
    img.draw(in: rect)
    
    let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return normalizedImage
}
