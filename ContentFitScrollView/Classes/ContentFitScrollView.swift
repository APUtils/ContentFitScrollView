//
//  ContentFitScrollView.swift
//  ContentFitScrollView
//
//  Created by Anton Plebanovich on 23.02.16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit


private let constantKey = "constant"
private let minimumHeightKey = "minimumHeight"
private let availableResizeHeightKey = "availableResizeHeight"

/// Self adjustable Scroll View that proportionally reducing provided height constraints constants to fit all content on screen without scrolling.
/// It takes into account `ContentFitLayoutConstraint`'s `minimumHeight` value.
/// If it's unable to fit content on screen without scrolling it'll just allow scrolling.
public class ContentFitScrollView: UIScrollView {
    
    //-----------------------------------------------------------------------------
    // MARK: - @IBOutlets
    //-----------------------------------------------------------------------------
    
    @IBOutlet private var heightConstraintsCollection: [NSLayoutConstraint]!
    
    //-----------------------------------------------------------------------------
    // MARK: - Private Properties
    //-----------------------------------------------------------------------------
    
    // TODO: Refactor into enum
    private var configurationDictionary = Dictionary<NSLayoutConstraint, Dictionary<String, CGFloat>>()
    private var summaryAvailableLength: CGFloat = 0
    private var defaultContentHeight: CGFloat!
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
        
        if defaultContentHeight == nil {
            defaultContentHeight = contentSize.height
        }
        
        resizeIfNecessary()
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Private Methods
    //-----------------------------------------------------------------------------
    
    private func fillConfigurationDictionary() {
        guard let heightConstraintsCollection = heightConstraintsCollection, !heightConstraintsCollection.isEmpty else {
            print("ContentFitScrollView doesn't have constraints to resize")
            return
        }
        
        for currentConstraint in heightConstraintsCollection {
            let constant = currentConstraint.constant
            var constraintProperties = [constantKey: constant]
            if let currentConstraint = currentConstraint as? ContentFitLayoutConstraint {
                let minimumHeight = currentConstraint.minimumHeight
                constraintProperties[minimumHeightKey] = minimumHeight
                constraintProperties[availableResizeHeightKey] = constant - minimumHeight
            } else {
                constraintProperties[minimumHeightKey] = 0
                constraintProperties[availableResizeHeightKey] = constant
            }
            
            summaryAvailableLength += constraintProperties[availableResizeHeightKey] ?? 0
            configurationDictionary[currentConstraint] = constraintProperties
        }
    }
    
    private func resizeIfNecessary() {
        guard previousBoundsSize != bounds.size || previousContentSize != contentSize else { return }
        
        previousBoundsSize = bounds.size
        previousContentSize = contentSize
        
        let topInset = contentInset.top
        let bottomInset = contentInset.bottom
        let contentSizeShortage = defaultContentHeight + topInset + bottomInset - frame.size.height
        
        if contentSizeShortage < -0.001 {
            restoreDefaultConstants()
            isScrollEnabled = false
            contentOffset.y = 0
            return
        }
        
        guard contentSizeShortage < summaryAvailableLength else {
            restoreDefaultConstants()
            isScrollEnabled = true
            return
        }
        
        isScrollEnabled = false
        contentOffset.y = 0
        for (currentConstraint, constraintProperties) in configurationDictionary {
            guard let currentAvailableResizeHeight = constraintProperties[availableResizeHeightKey] else { continue }
            guard let currentConstant = constraintProperties[constantKey] else { continue }
            
            let currentConstraintResizeCoef = currentAvailableResizeHeight / summaryAvailableLength
            currentConstraint.constant = currentConstant - contentSizeShortage * currentConstraintResizeCoef
        }
    }
    
    private func restoreDefaultConstants() {
        for (currentConstraint, constraintProperties) in configurationDictionary {
            guard let currentAvailableResizeHeight = constraintProperties[availableResizeHeightKey] else { continue }
            guard let currentConstant = constraintProperties[constantKey] else { continue }
            
            currentConstraint.constant = currentConstant
        }
    }
}
