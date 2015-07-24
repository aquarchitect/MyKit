//
//  Drawing.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public typealias Render = CGContextRef -> Void

public let PI = CGFloat(M_PI)

public func drawInState(context: CGContextRef, handle: Void -> Void) {
    CGContextSaveGState(context)
    handle()
    CGContextRestoreGState(context)
}