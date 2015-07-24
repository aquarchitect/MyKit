//
//  draw.swift
//  Essential
//
//  Created by Hai Nguyen on 7/23/15.
//
//

public func renderInContext(size: CGSize, opaque: Bool, render: Render) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0)

    let context = UIGraphicsGetCurrentContext()
    render(context)
    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()
    
    return image
}
