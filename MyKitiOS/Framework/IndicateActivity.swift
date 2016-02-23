//
//  IndicateActivity.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/22/16.
//  
//

public protocol IndicateActivity: class, Then {

    func startAnimating()
    func stopAnimating()
    func isAnimating() -> Bool
}

extension UIActivityIndicatorView: IndicateActivity {}