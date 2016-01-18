//
//  Drawing.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

/// Defines a rendering block for a context
public typealias Render = CGContextRef? -> Void

public let PI = CGFloat(M_PI)

/// Encapsulates the graphics state stack for the context
/// - Parameter context: the graphic context whose the graphics state you want to encapsulate
/// - Parameter render: encapsulated rendering block
public func drawInState(context: CGContextRef?, render: Render) {
    CGContextSaveGState(context)
    render(context)
    CGContextRestoreGState(context)
}