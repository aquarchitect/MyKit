//
//  Drawing.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

/// Defines a rendering block for a context
public typealias Render = CGContextRef -> Void

public let PI = CGFloat(M_PI)

/**
    Encapsulates the graphics state stack for the context.

    - Parameters:
        - context: The graphic context whose the graphics state you want to encapsulate
        - render: Tendering block for the encapsulated graphics state
*/
public func drawInState(context: CGContextRef?, render: Render) {
    CGContextSaveGState(context)
    if let context = context { render(context) }
    CGContextRestoreGState(context)
}