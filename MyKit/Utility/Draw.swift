//
//  Drawing.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public let PI = CGFloat(M_PI)

/**
Encapsulates the graphics state stack for a context.

- parameter context: The graphic context whose the graphics state you want to encapsulate.
- parameter render: Tendering block for the encapsulated graphics state.
*/
public func drawInState(context: CGContextRef, render: CGContextRef -> Void) {
    CGContextSaveGState(context)
    render(context)
    CGContextRestoreGState(context)
}