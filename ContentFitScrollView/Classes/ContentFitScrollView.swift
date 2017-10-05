//
//  ContentFitScrollView.swift
//  ContentFitScrollView
//
//  Created by Anton Plebanovich on 23.02.16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Self adjustable Scroll View that proportionally reducing provided height constraints constants to fit all content on screen without scrolling.
/// It takes into account `ContentFitLayoutConstraint`'s `minimumHeight` value.
/// If it's unable to fit content on screen without scrolling it'll just allow scrolling.
public class ContentFitScrollView: UIScrollView {
    
    //-----------------------------------------------------------------------------
    // MARK: - Types
    //-----------------------------------------------------------------------------
    
    struct Properties {
        let defaultConstant: CGFloat
        let minimumHeight: CGFloat
        let resizeCoef: CGFloat
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - @IBOutlets
    //-----------------------------------------------------------------------------
    
    @IBOutlet public var heightConstraintsCollection: [NSLayoutConstraint]!
    
    //-----------------------------------------------------------------------------
    // MARK: - Private Properties
    //-----------------------------------------------------------------------------
    
    private var configurationDictionary = Dictionary<NSLayoutConstraint, Properties>()
    private var previousBoundsSize: CGSize = .zero
    private var previousContentSize: CGSize = .zero
    
    //-----------------------------------------------------------------------------
    // MARK: - UIView Methods
    //-----------------------------------------------------------------------------
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        fillConfigurationDictionary()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        resizeIfNeeded()
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Private Methods
    //-----------------------------------------------------------------------------
    
    private func fillConfigurationDictionary() {
        guard let heightConstraintsCollection = heightConstraintsCollection, !heightConstraintsCollection.isEmpty else {
            NSLog("WARNING: ContentFitScrollView doesn't have constraints to resize")
            return
        }
        
        let summaryAvailableHeight: CGFloat = heightConstraintsCollection.reduce(0) { value, constraint in
            return value + constraint.constant
        }
        
        for currentConstraint in heightConstraintsCollection {
            let constant = currentConstraint.constant
            let minimumHeight: CGFloat
            let resizeCoef: CGFloat
            if let currentConstraint = currentConstraint as? ContentFitLayoutConstraint {
                minimumHeight = currentConstraint.minimumHeight
                resizeCoef = constant / summaryAvailableHeight
            } else {
                minimumHeight = 0
                resizeCoef = constant / summaryAvailableHeight
            }
            
            configurationDictionary[currentConstraint] = Properties(defaultConstant: constant, minimumHeight: minimumHeight, resizeCoef: resizeCoef)
        }
    }
    
    private func resizeIfNeeded() {
        guard previousBoundsSize != bounds.size || previousContentSize != contentSize else { return }
        
        previousBoundsSize = bounds.size
        previousContentSize = contentSize
        
        let topInset: CGFloat
        if #available(iOS 11.0, *) {
            topInset = adjustedContentInset.top
        } else {
            topInset = contentInset.top
        }
        
        let bottomInset: CGFloat
        if #available(iOS 11.0, *) {
            bottomInset = adjustedContentInset.bottom
        } else {
            bottomInset = contentInset.bottom
        }
        
        let contentSizeShortage = contentSize.height + topInset + bottomInset - frame.size.height
        
        var availableLength: CGFloat = 0
        for (constraint, properties) in configurationDictionary {
            availableLength += constraint.constant - properties.minimumHeight
        }
        
        guard contentSizeShortage < availableLength else {
            setMinimumConstants()
            isScrollEnabled = true
            return
        }
        
        isScrollEnabled = false
        contentOffset.y = -topInset
        for (constraint, properties) in configurationDictionary {
            var newConstant = constraint.constant - contentSizeShortage * properties.resizeCoef
            newConstant = max(newConstant, properties.minimumHeight)
            
            constraint.constant = newConstant
        }
    }
    
    private func restoreDefaultConstants() {
        for (constraint, properties) in configurationDictionary {
            constraint.constant = properties.defaultConstant
        }
    }
    
    private func setMinimumConstants() {
        for (constraint, properties) in configurationDictionary {
            constraint.constant = properties.minimumHeight
        }
    }
}
