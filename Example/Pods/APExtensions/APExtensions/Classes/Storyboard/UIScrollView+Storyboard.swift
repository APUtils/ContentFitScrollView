//
//  UIScrollView+Storyboard.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 5/18/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

//-----------------------------------------------------------------------------
// MARK: - Helper Extension
//-----------------------------------------------------------------------------

fileprivate extension UIView {
    fileprivate var _viewController: UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
}

//-----------------------------------------------------------------------------
// MARK: - Adjustment Behavior
//-----------------------------------------------------------------------------

@available(iOS 11.0, *)
public extension UIScrollView {
    @IBInspectable public var disableAutomaticContentAdjustment: Bool {
        get {
            return contentInsetAdjustmentBehavior == .never
        }
        set {
            contentInsetAdjustmentBehavior = newValue ? .never : .automatic
        }
    }
}

//-----------------------------------------------------------------------------
// MARK: - Bars Avoid
//-----------------------------------------------------------------------------

public extension UIScrollView {
    @available(iOS, deprecated: 11.0, obsoleted: 12.0, message: "avoidTopBars was deprecated, please use avoidNavigationBar")
    @IBInspectable public var avoidTopBars: Bool {
        get {
            NSLog("avoidTopBars was deprecated, please use avoidNavigationBar")
            
            return avoidNavigationBar
        }
        set {
            NSLog("avoidTopBars was deprecated, please use avoidNavigationBar")
            
            avoidNavigationBar = newValue
        }
    }
    
    /// Sets 64 or 0 for top content inset and disables automatic mechanisms to prevent conflict.
    /// Returns true if scroll view avoids top bars. Takes into account `contentInsetAdjustmentBehavior`.
    @IBInspectable public var avoidNavigationBar: Bool {
        get {
            if #available(iOS 11.0, *) {
                switch contentInsetAdjustmentBehavior {
                case .always: return adjustedContentInset.top == 64
                case .never: return contentInset.top == 64
                    
                case .scrollableAxes:
                    if isScrollEnabled || alwaysBounceVertical {
                        return adjustedContentInset.top == 64
                    } else {
                        return contentInset.top == 64
                    }
                
                case .automatic:
                    if let _ = _viewController?.navigationController {
                        return adjustedContentInset.top == 64
                    } else {
                        return contentInset.top == 64
                    }
                }
            } else {
                return contentInset.top == 64
            }
        }
        set {
            if #available(iOS 11.0, *) {
                disableAutomaticContentAdjustment = true
            }
            
            _viewController?.automaticallyAdjustsScrollViewInsets = false
            contentInset.top = newValue ? 64 : 0
            
            
            
            
            if #available(iOS 11.0, *) {
                adjustedContentInsetDidChange()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    /// Sets 49 or 0 for bottom inset and disables automatic mechanisms to prevent conflict.
    /// Returns true if scroll view avoids bottom bars. Takes into account `contentInsetAdjustmentBehavior`.
    @IBInspectable public var avoidTabBar: Bool {
        get {
            if #available(iOS 11.0, *) {
                switch contentInsetAdjustmentBehavior {
                case .always: return adjustedContentInset.bottom == 49
                case .never: return contentInset.bottom == 49
                    
                case .scrollableAxes:
                    if isScrollEnabled || alwaysBounceVertical {
                        return adjustedContentInset.bottom == 49
                    } else {
                        return contentInset.bottom == 49
                    }
                    
                case .automatic:
                    if let _ = _viewController?.navigationController {
                        return adjustedContentInset.bottom == 49
                    } else {
                        return contentInset.bottom == 49
                    }
                }
            } else {
                return contentInset.bottom == 49
            }
        }
        set {
            if #available(iOS 11.0, *) {
                disableAutomaticContentAdjustment = true
            }
            
            _viewController?.automaticallyAdjustsScrollViewInsets = false
            contentInset.bottom = newValue ? 49 : 0
            
            
            
            
            
            
            if #available(iOS 11.0, *) {
                adjustedContentInsetDidChange()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
