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
    // MARK: - Struct
    //-----------------------------------------------------------------------------
    
    enum ScrollBehaviour {
        case `default`
        case minimal
    }
    
    struct Properties {
        let defaultConstant: CGFloat
        let minimumHeight: CGFloat
        let availableResizeHeightKey: CGFloat
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - @IBOutlets
    //-----------------------------------------------------------------------------
    
    @IBOutlet public var heightConstraintsCollection: [NSLayoutConstraint]!
    
    //-----------------------------------------------------------------------------
    // MARK: - @IBInspectable
    //-----------------------------------------------------------------------------
    
    @IBInspectable public var useDefaultBehaviour: Bool {
        get {
            return scrollBehaviour == .default
        }
        set {
            scrollBehaviour = newValue ? .default : .minimal
        }
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Public Properties
    //-----------------------------------------------------------------------------
    
    var scrollBehaviour: ScrollBehaviour = .default
    
    //-----------------------------------------------------------------------------
    // MARK: - Private Properties
    //-----------------------------------------------------------------------------
    
    private var configurationDictionary = Dictionary<NSLayoutConstraint, Properties>()
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
            NSLog("ContentFitScrollView doesn't have constraints to resize")
            return
        }
        
        for currentConstraint in heightConstraintsCollection {
            let constant = currentConstraint.constant
            let minimumHeight: CGFloat
            let availableResizeHeight: CGFloat
            if let currentConstraint = currentConstraint as? ContentFitLayoutConstraint {
                minimumHeight = currentConstraint.minimumHeight
                availableResizeHeight = constant - minimumHeight
            } else {
                minimumHeight = 0
                availableResizeHeight = constant
            }
            
            summaryAvailableLength += availableResizeHeight
            configurationDictionary[currentConstraint] = Properties(defaultConstant: constant, minimumHeight: minimumHeight, availableResizeHeightKey: availableResizeHeight)
        }
    }
    
    private func resizeIfNecessary() {
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
        
        let contentSizeShortage = defaultContentHeight + topInset + bottomInset - frame.size.height
        
        guard contentSizeShortage > -0.001 else {
            restoreDefaultConstants()
            isScrollEnabled = false
            contentOffset.y = -topInset
            return
        }
        
        guard contentSizeShortage < summaryAvailableLength else {
            if useDefaultBehaviour {
                restoreDefaultConstants()
            } else {
                setMinimumConstants()
            }
            
            isScrollEnabled = true
            return
        }
        
        isScrollEnabled = false
        contentOffset.y = -topInset
        for (constraint, properties) in configurationDictionary {
            let resizeCoef = properties.availableResizeHeightKey / summaryAvailableLength
            constraint.constant = properties.defaultConstant - contentSizeShortage * resizeCoef
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
