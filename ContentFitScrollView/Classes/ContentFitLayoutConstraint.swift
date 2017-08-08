//
//  ContentFitLayoutConstraint.swift
//  ContentFitScrollView
//
//  Created by Anton Plebanovich on 23.02.16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Custom constraint class to allow specify minimum height constant
public class ContentFitLayoutConstraint: NSLayoutConstraint {
    /// Minimum allowed height for constraint
    @IBInspectable public var minimumHeight: CGFloat = 0
}
