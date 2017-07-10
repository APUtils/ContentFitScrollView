//
//  ViewController.swift
//  ContentFitScrollView
//
//  Created by Anton Plebanovich on 07/10/2017.
//  Copyright (c) 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //-----------------------------------------------------------------------------
    // MARK: - @IBOutlets
    //-----------------------------------------------------------------------------
    
    @IBOutlet private weak var scrollViewTopConstraint: NSLayoutConstraint!

    //-----------------------------------------------------------------------------
    // MARK: - Actions
    //-----------------------------------------------------------------------------

    @IBAction private func onFullTap(_ sender: Any) {
        scrollViewTopConstraint.constant = 0
    }
    
    @IBAction private func onFitTap(_ sender: Any) {
        scrollViewTopConstraint.constant = UIScreen.main.bounds.height - 64 - 300
    }
    
    @IBAction private func onScrollTap(_ sender: Any) {
        scrollViewTopConstraint.constant = UIScreen.main.bounds.height - 64 - 200
    }
}
