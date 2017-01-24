/*
 * CGRectEdge+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 1/23/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import CoreGraphics

public extension CGRectEdge {

    var opposite: CGRectEdge {
        switch self {
        case .minXEdge: return .maxXEdge
        case .maxXEdge: return .minXEdge
        case .minYEdge: return .maxYEdge
        case .maxYEdge: return .minXEdge
        }
    }
}
